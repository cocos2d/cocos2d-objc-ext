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

#import "TestBase.h"
#import "CCSpriteMultiTouch.h"
#import "cardNode.h"

//----------------------------------------------------------------------

@interface CCSpriteMultiTouchTest : TestBase

@end

//----------------------------------------------------------------------

@implementation CCSpriteMultiTouchTest

//----------------------------------------------------------------------

- (NSArray *)testConstructors
{
    return [NSArray arrayWithObjects:
            @"multiTouchTest",
            nil];
}

//----------------------------------------------------------------------

- (void)multiTouchTest
{
    self.subTitle = @"Drag, rotate and scale the card";
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"cards.classic.plist"];

    // load a multi touch sprite
    CCSpriteMultiTouch *card = [CCSpriteMultiTouch spriteWithImageNamed:[cardNode randomCardName]];
    card.position = ccp([CCDirector sharedDirector].viewSize.width * 0.5, [CCDirector sharedDirector].viewSize.height * 0.5);
    card.scale = 2.5;
    [self.contentNode addChild:card];
    
    // enable dragging, scaling etc
    card.touchCountForDrag = 2;         // zwei fingers to drag
    card.touchCountForRotate = 2;       // dos fingers to rotate
    card.touchCountForScale = 2;        // two fingers to scale
    
    card.userInteractionEnabled = YES;
    card.multipleTouchEnabled = YES;
}

//----------------------------------------------------------------------

@end
