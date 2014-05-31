/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2008-2010 Ricardo Quesada
 * Copyright (c) 2011 Zynga Inc.
 * Copyright (c) 2013-2014 Cocos2D Authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "CCSpineAnimation.h"
#import "CCSpineTimeline.h"
#import <objc/message.h>

// ----------------------------------------------------------------------------------------------

const float CCSpineAnimationBlendTime = 0.25;

// ----------------------------------------------------------------------------------------------

typedef void (*animationCallback)(id, SEL, id);

// ----------------------------------------------------------------------------------------------

@implementation spineAnimationCallback

+ (instancetype)animationCallbackWithTime:(float)time delegate:(id)delegate selector:(SEL)selector
{
    return([[spineAnimationCallback alloc] initWithTime:time delegate:delegate selector:selector]);
}

- (instancetype)initWithTime:(float)time delegate:(id)delegate selector:(SEL)selector
{
    self = [super init];
    // initialize
    _time = time;
    _delegate = delegate;
    _selector = selector;
    // done
    return(self);
}

@end

// ----------------------------------------------------------------------------------------------

@implementation CCSpineAnimation
{
    NSString *_name;
    CCSpineAnimationState _state;
    float _runTime;
    float _cycleTime;
    NSMutableArray *_timelineList;
    NSMutableDictionary *_spriteFrameList;
    NSMutableDictionary *_colorSampleList;
    float _stateTime;                                                                           // timer used for state timing
    float _speed;                                                                               // animation speed controlled by blending
    float _blendTime;
    CCSpineAnimation *_parent;                                                                  // if set, return to this one after completion
    BOOL _runTimeExpired;
    NSMutableArray *_callbackList;                                                              // list of times callbacks
}

// ----------------------------------------------------------------------------------------------

+ (instancetype)animationWithDictionary:(NSDictionary *)dict andName:(NSString *)name
{
    return([[CCSpineAnimation alloc] initWithDictionary:dict andName:name]);
}

// ----------------------------------------------------------------------------------------------

- (instancetype)initWithDictionary:(NSDictionary *)dict andName:(NSString *)name
{
    self = [super init];
    
    // create lists
    
    _timelineList = [NSMutableArray array];
    _spriteFrameList = [NSMutableDictionary dictionary];
    _colorSampleList = [NSMutableDictionary dictionary];
    _callbackList = [NSMutableArray array];
    
    // reset
    
    _name = [NSString stringWithString:name];
    _cycleTime = 0.0;
    _strength = 1.0;
    _speed = 1.0;
    _state = CCSpineAnimationStateIdle;
    _runTimeExpired = NO;
    _delegate = nil;
    _selector = nil;
    
    // read animation from dictionary

    // read bone timelines
    NSDictionary* boneDict = [dict objectForKey:@"bones"];
    for (NSString* boneName in boneDict)
    {
        // create timeline for bone
        CCSpineTimeline* timeline = [CCSpineTimeline timelineWithDictionary:[boneDict objectForKey:boneName] boneName:boneName];
        if (timeline.cycleTime > _cycleTime)
            _cycleTime = timeline.cycleTime;
        // save entry
        [_timelineList addObject:timeline];
    }
    
    // read sprite timelines
    NSDictionary* spriteDict = [dict objectForKey:@"slots"];
    for (NSString* spriteName in spriteDict)
    {
        // find sprite and add animation
        NSDictionary* spriteEntries = [spriteDict objectForKey:spriteName];
        
        // read entries for "attachment"
        NSArray* attachmentList = [spriteEntries objectForKey:@"attachment"];
        NSMutableArray* frameList = [NSMutableArray array];
        for (NSDictionary* textureFrameDict in attachmentList)
        {
            CCSpineTextureFrame* frame = [CCSpineTextureFrame textureFrameWithDictionary:textureFrameDict];
            [frameList addObject:frame];
        }
        [_spriteFrameList setObject:frameList forKey:spriteName];
        
        // read entries for "color"
        NSArray* colorList = [spriteEntries objectForKey:@"color"];
        NSMutableArray* colorSampleList = [NSMutableArray array];
        for (NSDictionary *colorDict in colorList)
        {
            CCSpineSample *colorSample = [CCSpineSample sampleWithDictionary:colorDict andType:CCSpineSampleTypeColor];
            [colorSampleList addObject:colorSample];
        }
        [_colorSampleList setObject:colorSampleList forKey:spriteName];
    }
    
    // blend time
    self.blendTime = CCSpineAnimationBlendTime;

    // done
    return(self);
}

// ----------------------------------------------------------------------------------------------

- (BOOL)hasTextureAnimation:(NSString *)spriteName
{
    NSArray* textureList = [_spriteFrameList objectForKey:spriteName];
    if ((textureList == nil) || (textureList.count == 0)) return(NO);
    return(YES);
}

// ----------------------------------------------------------------------------------------------

- (CCSpineTextureFrame *)getTextureFrameAt:(float)time forName:(NSString *)spriteName
{
    CCSpineTextureFrame* current = nil;
    CCSpineTextureFrame* next;
    NSArray* textureList = [_spriteFrameList objectForKey:spriteName];
    
    if ((textureList == nil) || (textureList.count == 0)) return(nil);
    //
    if (textureList.count == 1)
    {
        current = [textureList objectAtIndex:0];
        if (time < current.time) return(current);
        return(nil);
    }
    //
    for (int index = 0; index < textureList.count; index ++)
    {
        next = [textureList objectAtIndex:index];
        if (time <= next.time) return(current);
        current = next;
    }
    // done
    return(current);
}

// ----------------------------------------------------------------------------------------------

- (BOOL )hasColorAnimation:(NSString *)spriteName
{
    NSArray *colorList = [_colorSampleList objectForKey:spriteName];
    if ((colorList == nil) || (colorList.count == 0)) return(NO);
    return(YES);
}

// ----------------------------------------------------------------------------------------------

- (CCSpineSample *)getColorAt:(float)time forName:(NSString *)spriteName
{
    CCSpineSample *current;
    CCSpineSample *next;
    NSArray *colorArray = [_colorSampleList objectForKey:spriteName];
    
    if ((colorArray == nil) || (colorArray.count == 0)) return(nil);
    //
    current = [colorArray objectAtIndex:0];
    if (time < current.time) return(current);
    if (colorArray.count == 1) return(current);
    //
    for (int index = 0; index < colorArray.count; index ++)
    {
        next = [colorArray objectAtIndex:index];
        if (time <= next.time) return(current);
        current = next;
    }
    // done
    return(current);
}

// ----------------------------------------------------------------------------------------------

- (void)tick:(CCTime)dt
{
    float absDt = fabs(dt);
    float preRunTime = _runTime;
    
    // animation state machine
    switch (_state) {
            
        case CCSpineAnimationStateIdle:
            break;

        case CCSpineAnimationStateStart:
            _stateTime += absDt;
            _runTime += dt;
            _speed = clampf(_stateTime / _blendTime, 0, 1);
            if (_speed >= 1) _state = CCSpineAnimationStateRun;
            break;

        case CCSpineAnimationStateRun:
            _runTime += dt;
            break;

        case CCSpineAnimationStateStop:
            _stateTime += absDt;
            _runTime += dt;
            _speed = clampf(1 - (_stateTime / _blendTime), 0, 1);
            if (_speed <= 0) _state = CCSpineAnimationStateIdle;
            break;            
            
        case CCSpineAnimationStateBlend:
            _stateTime += absDt;
            _runTime += dt;
            if (_stateTime >= _blendTime) {
                for (CCSpineTimeline* timeline in _timelineList) timeline.blendTime = 0;
                _state = CCSpineAnimationStateRun;
            }
            break;
            
        case CCSpineAnimationStateExpired:
            // non looped base animations will end here
            
            // we really should not get here very often
            // CCLOG(@"Warning ! animation is ticked in the expired state");
            break;
     
    }
    
    // check times callbacks
    for (spineAnimationCallback* callback in _callbackList)
    {
        if ((preRunTime <= callback.time) && (_runTime >= callback.time) && (dt != 0))
        {
            ((animationCallback)objc_msgSend)(callback.delegate, callback.selector, self);
        }
    }
    
    // check runtimes
    while (_runTime < 0)
    {
        _runTimeExpired = YES;
        if (_isLooped)
        {
            _runTime += _cycleTime;
        }
        else
        {
            _runTime = 0;
            _state = CCSpineAnimationStateExpired;
        }
        if ((_delegate != nil) && (_selector != nil))
        {
            ((animationCallback)objc_msgSend)(_delegate, _selector, self);
        }
    }
    while (_runTime > _cycleTime)
    {
        _runTimeExpired = YES;
        if (_isLooped)
        {
            _runTime -= _cycleTime;
        }
        else
        {
            _runTime = _cycleTime;
            _state = CCSpineAnimationStateExpired;
        }
        if ((_delegate != nil) && (_selector != nil))
        {
            ((animationCallback)objc_msgSend)(_delegate, _selector, self);
        }
    };
    
}

// ----------------------------------------------------------------------------------------------

- (void)addTimedCallback:(float)time delegate:(id)delegate selector:(SEL)selector
{
    spineAnimationCallback* callback = [spineAnimationCallback animationCallbackWithTime:time delegate:delegate selector:selector];
    [_callbackList addObject:callback];
}

// ----------------------------------------------------------------------------------------------

- (void)setCallback:(id)delegate selector:(SEL)selector
{
    _delegate = delegate;
    _selector = selector;
}

// ----------------------------------------------------------------------------------------------

- (void)reset
{
    _stateTime = 0;
    _runTime = 0;
    _runTimeExpired = NO;
    _state = CCSpineAnimationStateIdle;
}

// ----------------------------------------------------------------------------------------------

- (void)start
{
    [self reset];
    _state = CCSpineAnimationStateStart;
}

// ----------------------------------------------------------------------------------------------

- (void)stop
{
    [self reset];
    _state = CCSpineAnimationStateStop;
}

// ----------------------------------------------------------------------------------------------

- (void)idle
{
    _state = CCSpineAnimationStateIdle;
}

// ----------------------------------------------------------------------------------------------

- (void)remove
{
    _state = CCSpineAnimationStateExpired;
}

// ----------------------------------------------------------------------------------------------

- (void)blend:(CCSpineAnimation *)from
{
    if (from == nil)
    {
        [self start];
        return;
    }
    for (CCSpineTimeline* timeline in from.timelineList)
    {
        // find timeline.bone in own timeline
        for (CCSpineTimeline* ownTimeline in _timelineList)
        {
            if (timeline.bone == ownTimeline.bone)
            {
                timeline.blendTime = 0;
                ownTimeline.blendData = [timeline getSpineDataAt:from.runTime strength:from.strength];
                ownTimeline.blendTime = _blendTime;
                break;
            }
        }
    }
    [self reset];
    _state = CCSpineAnimationStateBlend;
}

// ----------------------------------------------------------------------------------------------
// properties
// - runTime ------------------------------------------------------------------------------------

- (float)runTime
{
    return(_runTime);
}

- (void)setRunTime:(float)runTime
{
    NSAssert(_state == CCSpineAnimationStateIdle || _state == CCSpineAnimationStateStop, @"[CCSpineAnimation setRunTime] runTime can only be set for idle or expired animations");
    NSAssert(_runTime >= 0 && _runTime < _cycleTime, @"[CCSpineAnimation setRunTime] runTime must be within animation cycle time");
    _runTime = runTime;
}

// - blendTime ----------------------------------------------------------------------------------

- (float)blendTime
{
    return(_blendTime);
}

- (void)setBlendTime:(float)blendTime
{
    _blendTime = clampf(blendTime, 0, _cycleTime);
}

// - runTimeExpired -----------------------------------------------------------------------------

- (BOOL)runTimeExpired
{
    BOOL result = _runTimeExpired;
    _runTimeExpired = NO;
    return(result);
}

// - progress -----------------------------------------------------------------------------------

- (float)progress
{
    return(clampf(_runTime / _cycleTime, 0, 1));
}

// ----------------------------------------------------------------------------------------------

@end









































