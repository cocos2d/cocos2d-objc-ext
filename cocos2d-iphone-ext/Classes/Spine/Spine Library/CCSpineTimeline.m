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

#import "CCSpineTimeline.h"
#import "CCSpineSample.h"

// ----------------------------------------------------------------------------------------------

@implementation CCSpineTimeline
{
    NSString*                           _boneName;
    NSMutableArray*                     _rotateList;
    NSMutableArray*                     _translateList;
    NSMutableArray*                     _scaleList;
}

// ----------------------------------------------------------------------------------------------

+ (instancetype)timelineWithDictionary:(NSDictionary *)dict boneName:(NSString *)name
{
    return([[CCSpineTimeline alloc] initDictionary:dict boneName:name]);
}

// ----------------------------------------------------------------------------------------------

- (instancetype)initDictionary:(NSDictionary *)dict boneName:(NSString *)name
{
    self                        = [super init];
    
    // load bone timeline from dictionary
    // if a sprite timeline exists, it will be added later
    // create animation lists
    
    _rotateList                         = [NSMutableArray array];
    _translateList                      = [NSMutableArray array];
    _scaleList                          = [NSMutableArray array];
    
    _boneName                           = [NSString stringWithString:name];
    _bone                               = nil;
    
    // load animations from dictionary
    
    // rotations
    NSArray* rotateArray                = [dict objectForKey:@"rotate"];
    for (NSDictionary* dict in rotateArray)
    {
        // create rotation animation
        CCSpineSample* data               = [CCSpineSample sampleWithDictionary:dict andType:CCSpineSampleTypeRotate];
        if (data.time > _cycleTime) _cycleTime = data.time;
        // save to list
        [_rotateList addObject:data];
    }
    
    // translations
    NSArray* translateArray             = [dict objectForKey:@"translate"];
    for (NSDictionary* dict in translateArray)
    {
        // create translate animation
        CCSpineSample* data               = [CCSpineSample sampleWithDictionary:dict andType:CCSpineSampleTypeTranslate];
        if (data.time > _cycleTime) _cycleTime = data.time;
        // save to list
        [_translateList addObject:data];
    }
    
    // scale
    NSArray* scaleArray                 = [dict objectForKey:@"scale"];
    for (NSDictionary* dict in scaleArray)
    {
        // create scale animation
        CCSpineSample* data               = [CCSpineSample sampleWithDictionary:dict andType:CCSpineSampleTypeScale];
        if (data.time > _cycleTime) _cycleTime = data.time;
        // save to list
        [_scaleList addObject:data];
    }
    
    // done
    return(self);
}

// ----------------------------------------------------------------------------------------------

- (CCSpineBoneData)interpolate:(NSArray *)array forTime:(float)time
{
    CCSpineBoneData result = (CCSpineBoneData){{0, 0}, 0, {1, 1}};
    CCSpineSample* current;
    CCSpineSample* next;
    float rotate;
    
    // if no interpolation data, return a blank
    if (array.count == 0) return(result);
    // if one interpolation data of time below first entry, return it
    current = [array objectAtIndex:0];
    if ((array.count == 1) || (time <= current.time)) return(current.data);
    // interpolate
    for (int index = 1; index < array.count; index ++)
    {
        next = [array objectAtIndex:index];
        if (time <= next.time)
        {
            // interpolate from next to current
            float progress = (time - current.time) / (next.time - current.time);
            progress = [current.curve translate:progress];
            switch (current.type)
            {
                case CCSpineSampleTypeRotate:
                    rotate                      = next.data.rotation - current.data.rotation;
                    while (rotate > 180)      rotate -= 360;
                    while (rotate < -180)     rotate += 360;
                    result.rotation             = current.data.rotation + (rotate * progress);
                    break;
                case CCSpineSampleTypeTranslate:
                    result.position             = ccpLerp(current.data.position, next.data.position, progress);
                    break;
                case CCSpineSampleTypeScale:
                    result.scale                = ccpLerp(current.data.scale, next.data.scale, progress);
                    break;
                default:
                    break;
            }
            return(result);
        }
        current = next;;
    }
    // ups
    return(current.data);
}

// ----------------------------------------------------------------------------------------------
// blend from _blendData to data

- (CCSpineBoneData)blendData:(CCSpineBoneData)data time:(float)time
{
    float progress = clampf(time / _blendTime, 0, 1);
    
    data.position = ccpLerp(_blendData.position, data.position, progress);
    
    float rotate = data.rotation - _blendData.rotation;
    while (rotate > 180)      rotate -= 360;
    while (rotate < -180)     rotate += 360;
    data.rotation = _blendData.rotation + (rotate * progress);
    
    data.scale = ccpLerp(_blendData.scale, data.scale, progress);

    return(data);
}

// ----------------------------------------------------------------------------------------------
// returns spine data at any given time

- (CCSpineBoneData)getSpineDataAt:(float)time strength:(float)strength
{
    CCSpineBoneData result            = (CCSpineBoneData){{0, 0}, 0, {1, 1}};
    
    // interpolate from data
    
    // position
    result.position                 = [self interpolate:_translateList forTime:time].position;
    result.position                 = ccpMult(result.position, strength);

    // rotation
    result.rotation                 = [self interpolate:_rotateList forTime:time].rotation;
    // make sure rotation is in valid range
    while (result.rotation < -180)    result.rotation += 360;
    while (result.rotation > 180)     result.rotation -= 360;
    result.rotation                 *= strength;
    
    // scale
    result.scale                    = [self interpolate:_scaleList forTime:time].scale;
    
    // check for blending
    if (_blendTime > 0) result  = [self blendData:result time:time];
    // done
    return(result);
}

// ----------------------------------------------------------------------------------------------

@end







































