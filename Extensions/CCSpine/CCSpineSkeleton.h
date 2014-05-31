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
#import "cocos2d.h"
#import "CCSpineAnimation.h"
#import "CCSpineSkin.h"
#import "CCSpineAnimationControl.h"

// ----------------------------------------------------------------------------------------------

@interface CCSpineSkeleton : CCNode

// ----------------------------------------------------------------------------------------------

// overall animation speed
@property (nonatomic) float animationSpeed;
@property (nonatomic, readonly) BOOL skeletonPaused;

// list of bones, skins and animations
@property (nonatomic, readonly) CCNode* spriteParent;
@property (nonatomic, readonly) NSDictionary* skinList;                             // list of CCSpineSkin*
@property (nonatomic, readonly) CCSpineAnimationControl* animationControl;          // animation control

// ----------------------------------------------------------------------------------------------

// create a skeleton from Spine json and TexturePacker spritesheet
+ (instancetype)skeletonWithJsonFile:(NSString *)file andSpriteSheet:(NSString *)spriteSheet;
- (instancetype)initWithJsonFile:(NSString *)file andSpriteSheet:(NSString *)spriteSheet;

// convenience methods
- (CCSpineBone *)getBoneByName:(NSString *)name;

// assigns a complete skin to skeleton
- (void)assignSkin:(CCSpineSkin *)skin;
- (void)assignSkinByName:(NSString *)skinName;
- (void)replaceTexture:(NSString *)oldTextureName newTextureName:(NSString *)newTextureName;
- (void)clearSkin;

// find animation by name
- (CCSpineAnimation *)animationByName:(NSString *)name;

// returns skeleton to pose
- (void)pose;

- (void)pauseAnimation;
- (void)resumeAnimation;

- (void)clearAnimations;

- (CCSpineAnimation *)setBaseAnimation:(NSString *)name;
- (CCSpineAnimation *)setBaseAnimation:(NSString *)name delegate:(id)delegate selector:(SEL)selector;

- (CCSpineAnimation *)insertAnimation:(NSString *)name;
- (CCSpineAnimation *)insertAnimation:(NSString *)name delegate:(id)delegate selector:(SEL)selector;

- (CCSpineAnimation *)forceAnimation:(NSString *)name;
- (CCSpineAnimation *)forceAnimation:(NSString *)name delegate:(id)delegate selector:(SEL)selector;

- (void)addTimedCallback:(NSString *)name time:(float)time delegate:(id)delegate selector:(SEL)selector;

- (void)logAnimations;
- (void)logSkins;

// ----------------------------------------------------------------------------------------------

@end












































