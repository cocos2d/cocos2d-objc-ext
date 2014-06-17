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

#import "spineNode.h"
#import "CCSpineSkeleton.h"

//----------------------------------------------------------------------
// Used for maintaining a simple mode state machine for the skeleton.
// Depending on mode, swiping will do different things

typedef NS_ENUM(NSInteger, animationMode)
{
    animationModeIdle,
    animationModeRun1,
    animationModeRun2,
    animationModeRun3,
};

//----------------------------------------------------------------------

@implementation spineNode
{
    CCSpineSkeleton *_skeleton;
    NSInteger _skinNumber;
    animationMode _animationMode;
}

// -----------------------------------------------------------------

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class");

    // create the spine node
    
    // create the skeleton
    // 3 files are needed for this
    // filename.json        An exported json file from Spine
    // filename.plist       A plist, created by ex. TexturePacker
    // filename.png         A spritesheet, created by ex. TexturePacker
    _skeleton = [CCSpineSkeleton skeletonWithJsonFile:@"chase_johnson.json" andSpriteSheet:@"chase_johnson.plist"];
    
    // place and scale the skeleton
    // OBS! the demo is in very low resolution
    _skeleton.position = ccp([CCDirector sharedDirector].viewSize.width * 0.5, [CCDirector sharedDirector].viewSize.height * 0.25);
    _skeleton.scale = 0.5;
    
    // show available animations and skins is log
    [_skeleton logAnimations];
    [_skeleton logSkins];
    
    // add the skeleton to the node
    [self addChild:_skeleton];

    // reset skin
    _skinNumber = 0;
    [_skeleton assignSkinByName:@"BASEBALL"];
    
    // set base animation
    [_skeleton setBaseAnimation:@"IDLE_CATCH_BREATH"];

    // set mode
    _animationMode = animationModeIdle;
    
    // add gesture recognizers
    UISwipeGestureRecognizer* swipe;
    
    // swipe up
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionUp];
    [[CCDirector sharedDirector].view addGestureRecognizer:swipe];
    
    // swipe down
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionDown];
    [[CCDirector sharedDirector].view addGestureRecognizer:swipe];
    
    // swipe right
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [[CCDirector sharedDirector].view addGestureRecognizer:swipe];
    
    // swipe left
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [swipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[CCDirector sharedDirector].view addGestureRecognizer:swipe];
    
    // done
    return(self);
}

//----------------------------------------------------------------------

- (void)swipeUp:(id)sender {
    
    if (_animationMode == animationModeIdle) {
        
        // if idle, insert a random idle animation
        switch (arc4random() % 3) {
            case 0: [_skeleton insertAnimation:@"IDLE_BOXING"]; break;
            case 1: [_skeleton insertAnimation:@"IDLE_GUITAR"]; break;
            case 2: [_skeleton insertAnimation:@"IDLE_MOON_WALK"]; break;
        }
    } else {
        
        // if not idle, insert a jump animation
        
        // jump up part
        [_skeleton insertAnimation:@"JUMP_JUMP"];
        
        // falling part is used too loop a fall from unknown height
        // in this demo there is no height to the jump, so this part is skipped
        // [_skeleton insertAnimation:@"JUMP_FALLING"];
        
        // select a random landing from 2 possible
        if ((arc4random() %2) == 0) {
            // land normally
            [_skeleton insertAnimation:@"JUMP_LAND"];
        } else {
            // land with a forward roll
            [_skeleton insertAnimation:@"JUMP_LAND_ROLL"];
        }
    }
    
}

//----------------------------------------------------------------------

- (void)swipeDown:(id)sender {
    
    if (_animationMode == animationModeIdle) {
        
        // if idle, demonstrate a small motorcycle sequence
        [_skeleton insertAnimation:@"VEHICLE_MOTORCYCLE_MOUNT"];
        [_skeleton insertAnimation:@"VEHICLE_MOTORCYCLE_RIDE"];
        [_skeleton insertAnimation:@"VEHICLE_MOTORCYCLE_DISMOUNT"];
        
    } else {
        
        // if not idle, insert a slide animation
        if ((arc4random() %2) == 0) {
            [_skeleton insertAnimation:@"SLIDE_1_DOWN"];
            [_skeleton insertAnimation:@"SLIDE_1_UP"];
        } else {
            [_skeleton insertAnimation:@"SLIDE_2_DOWN"];
            [_skeleton insertAnimation:@"SLIDE_2_UP"];
        }
    }
}

//----------------------------------------------------------------------

- (void)swipeLeft:(id)sender {
    switch (_animationMode) {
        case animationModeIdle:
            
            // switch skin
            _skinNumber ++;
            _skinNumber %= [_skeleton.skinList allKeys].count;
            [_skeleton assignSkinByName:[[_skeleton.skinList allKeys] objectAtIndex:_skinNumber]];
            
            break;
        case animationModeRun1:
            _animationMode = animationModeIdle;
            [_skeleton setBaseAnimation:@"IDLE_CATCH_BREATH"];
            break;
        case animationModeRun2:
            _animationMode = animationModeRun1;
            [_skeleton setBaseAnimation:@"RUN_1"];
            break;
        case animationModeRun3:
            _animationMode = animationModeRun2;
            [_skeleton setBaseAnimation:@"RUN_2"];
            break;
    }
    
}

//----------------------------------------------------------------------

- (void)swipeRight:(id)sender {
    switch (_animationMode) {
        case animationModeIdle:
            _animationMode = animationModeRun1;
            [_skeleton setBaseAnimation:@"RUN_1"];
            break;
        case animationModeRun1:
            _animationMode = animationModeRun2;
            [_skeleton setBaseAnimation:@"RUN_2"];
            break;
        case animationModeRun2:
            _animationMode = animationModeRun3;
            [_skeleton setBaseAnimation:@"RUN_3"];
            break;
        case animationModeRun3:
            [_skeleton insertAnimation:@"RUSH_1"];
            break;
    }
}

//----------------------------------------------------------------------

@end
