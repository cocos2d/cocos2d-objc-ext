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

#import <Foundation/Foundation.h>
#import "CCSpineBone.h"
#import "CCSpineSprite.h"

// ----------------------------------------------------------------------------------------------

extern const float CCSpineAnimationBlendTime;

// ----------------------------------------------------------------------------------------------

typedef NS_ENUM(NSInteger, CCSpineAnimationState)
{
    CCSpineAnimationStateIdle,
    CCSpineAnimationStateStart,
    CCSpineAnimationStateRun,
    CCSpineAnimationStateStop,
    CCSpineAnimationStateBlend,
    CCSpineAnimationStateExpired
};
 
// ----------------------------------------------------------------------------------------------

@interface spineAnimationCallback : NSObject

@property (nonatomic, readonly) float time;
@property (nonatomic, readonly) id delegate;
@property (nonatomic, readonly) SEL selector;

+ (instancetype)animationCallbackWithTime:(float)time delegate:(id)delegate selector:(SEL)selector;
- (instancetype)initWithTime:(float)time delegate:(id)delegate selector:(SEL)selector;

@end

// ----------------------------------------------------------------------------------------------

@interface CCSpineAnimation : NSObject

// ----------------------------------------------------------------------------------------------

@property (nonatomic) float blendTime;                                                        // blend in and out time
@property (nonatomic) float strength;                                                         // animation strength
@property (nonatomic) BOOL isLooped;                                                          // loop

@property (nonatomic, readonly) NSString *name;                                                 // animation name
@property (nonatomic, readonly) float runTime;                                                // current animation runtime
@property (nonatomic, readonly) float cycleTime;                                              // cycle time of the animation
@property (nonatomic, readonly) float progress;                                               // animation progress
@property (nonatomic, readonly) float speed;                                                  // speed applied to starting and stopping animations
@property (nonatomic, readonly) CCSpineAnimationState state;                                        // current state of animation
@property (nonatomic, readonly) id delegate;                                                  // callback delegate
@property (nonatomic, readonly) SEL selector;                                                 // callback selector
@property (nonatomic, readonly) BOOL runTimeExpired;                                          // runtime expired at least once

@property (nonatomic, readonly) NSArray *timelineList;                                        // array of CCSpineTimeline*
@property (nonatomic, readonly) NSDictionary *spriteFrameList;                                // NSDictionary* of NSArray*[spriteName] of CCSpineTextureFrame*

// ----------------------------------------------------------------------------------------------

+ (instancetype)animationWithDictionary:(NSDictionary *)dict andName:(NSString *)name;
- (instancetype)initWithDictionary:(NSDictionary *)dict andName:(NSString *)name;

- (BOOL)hasTextureAnimation:(NSString *)spriteName;                                             // checks if a sprite has texture animations
- (CCSpineTextureFrame *)getTextureFrameAt:(float)time forName:(NSString *)spriteName;            // return sprite sprite for any given time. returning nil means no sprite should be shown

- (void)setCallback:(id)delegate selector:(SEL)selector;
- (void)addTimedCallback:(float)time delegate:(id)delegate selector:(SEL)selector;

- (void)tick:(CCTime)dt;

- (void)reset;
- (void)start;
- (void)idle;
- (void)blend:(CCSpineAnimation *)from;
- (void)remove;

// ----------------------------------------------------------------------------------------------

@end













































