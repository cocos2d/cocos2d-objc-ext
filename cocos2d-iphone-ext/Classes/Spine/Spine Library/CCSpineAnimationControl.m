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

#import "CCSpineAnimationControl.h"

// ----------------------------------------------------------------------------------------------

const int CCSpineAnimationNotRunning = -1;

// ----------------------------------------------------------------------------------------------

@implementation CCSpineAnimationControl
{
    CCSpineAnimation            *_baseAnimation;
    NSMutableArray              *_animationList;
    NSMutableArray              *_pendingList;
}

// ----------------------------------------------------------------------------------------------

+ (instancetype)animationControl
{
    return([[CCSpineAnimationControl alloc] init]);
}

// ----------------------------------------------------------------------------------------------

- (instancetype)init
{
    self                            = [super init];
    // initialize
    
    _animationList                  = [NSMutableArray array];
    _pendingList                    = [NSMutableArray array];
    
    _currentAnimation               = nil;

    // done
    return(self);
}

// ----------------------------------------------------------------------------------------------

- (void)tick:(CCTime)dt {
    BOOL restartAnimation = NO;
    CCSpineAnimation* oldAnimation = nil;
    
    // go through animation in list, and see if any expired
    for (NSInteger index = _animationList.count - 1; index > 0; index --) {
        CCSpineAnimation* animation           = [_animationList objectAtIndex:index];
        if (animation.state == CCSpineAnimationStateExpired) [_animationList removeObjectAtIndex:index];
    }
    // run though insert animation, and see if runtime expired
    for (NSInteger index = _pendingList.count - 1; index >= 0; index --) {
        CCSpineAnimation* animation           = [_pendingList objectAtIndex:index];
        if (animation.state == CCSpineAnimationStateExpired) {
            oldAnimation = animation;
            [animation remove];
            [_pendingList removeObjectAtIndex:index];
            restartAnimation = YES;
        }
    }
    // check if new animation should be started
    if (restartAnimation == YES) {
        if (_pendingList.count == 0) {
            [_baseAnimation blend:oldAnimation];
            _currentAnimation               = _baseAnimation;
        } else {
            CCSpineAnimation* animation       = [_pendingList objectAtIndex:0];
            [_animationList addObject:animation];
            [animation blend:oldAnimation];
            _currentAnimation               = animation;
        }
    }
    
    
}

// ----------------------------------------------------------------------------------------------

- (void)reset {
    [_animationList removeAllObjects];
    [_pendingList removeAllObjects];
    _baseAnimation = nil;
    _currentAnimation = nil;
}

// ----------------------------------------------------------------------------------------------

- (int)animationIsRunning:(CCSpineAnimation *)animation {
    for (int index = 0; index < _animationList.count; index ++) {
        CCSpineAnimation* runningAnimation = [_animationList objectAtIndex:index];
        if (runningAnimation == animation) return(index);
    }
    return(CCSpineAnimationNotRunning);
}

// ----------------------------------------------------------------------------------------------

- (void)setBaseAnimation:(CCSpineAnimation *)animation {
    CCSpineAnimation* oldBaseAnimation = nil;

    _baseAnimation = animation;
    _baseAnimation.isLooped = YES;

    // first time
    if (_animationList.count == 0) {
        [_animationList addObject:animation];
        [_baseAnimation start];
        _currentAnimation               = _baseAnimation;
        return;
    }
    
    // find out if base animation present
    int index = [self animationIsRunning:animation];
    if (index == 0) {
        CCLOG(@"[CCSpineAnimationControl setBaseAnimation] Animation %@ is already base animation", animation.name);
        return;
    }
    if (index != CCSpineAnimationNotRunning) {
        oldBaseAnimation = [_animationList objectAtIndex:index];
        [_animationList removeObjectAtIndex:index];
    } else {
        oldBaseAnimation = [_animationList objectAtIndex:0];
        [_animationList removeObjectAtIndex:0];
    }
    // 
    [_animationList insertObject:animation atIndex:0];
    if (oldBaseAnimation.state != CCSpineAnimationStateIdle) {
        [animation blend:oldBaseAnimation];
        _currentAnimation               = animation;
    } else {
        [animation idle];
    }
}

// ----------------------------------------------------------------------------------------------

- (void)insertAnimation:(CCSpineAnimation *)animation {
    // check if animation is already running in some form
    if ([self animationIsRunning:animation] != CCSpineAnimationNotRunning) {
        CCLOG(@"[CCSpineAnimationControl insertAnimation] Animation %@ is already running", animation.name);
        return;
    }
    // force no loop
    animation.isLooped = NO;
    [animation reset];
    // stop the base animation if first insert
    if (_pendingList.count == 0) {
        [_baseAnimation idle];
        [_animationList addObject:animation];
        [animation blend:_baseAnimation];
        _currentAnimation               = animation;
    }
    // add animation to insert list
    [_pendingList addObject:animation];
}

// ----------------------------------------------------------------------------------------------

- (void)forceAnimation:(CCSpineAnimation *)animation {
    [_pendingList removeAllObjects];
    for (NSInteger index = _animationList.count - 1; index >= 1; index --) {
        CCSpineAnimation* oldAnimation = [_animationList objectAtIndex:index];
        [oldAnimation idle];
        [_animationList removeObjectAtIndex:index];
    }
    [_baseAnimation idle];
    //
    [_animationList addObject:animation];
    [_pendingList addObject:animation];
    [animation blend:_currentAnimation];
    _currentAnimation = animation;
}

// ----------------------------------------------------------------------------------------------
// properties
// ----------------------------------------------------------------------------------------------


// ----------------------------------------------------------------------------------------------

@end















































