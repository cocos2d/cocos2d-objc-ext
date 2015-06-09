/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2012-2015 Lars Birkemose
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
#import "TestBase.h"
#import "CCSpriteVideo.h"

//----------------------------------------------------------------------

@interface CCSpriteVideoTest : TestBase

@end

//----------------------------------------------------------------------

@implementation CCSpriteVideoTest

//----------------------------------------------------------------------

- (NSArray *)testConstructors
{
    return [NSArray arrayWithObjects:
            @"videoTest",
            nil];
}

- (void)videoTest
{
    CCSpriteVideo *sprite = [CCSpriteVideo spriteWithVideoNamed:@"stranded.m4v"];
    sprite.positionType = CCPositionTypeNormalized;
    sprite.position = (CGPoint){0.5, 0.5};
    [self.contentNode addChild:sprite];
    sprite.scale = 0.5;
    
    // slowly rotate the video
    [sprite runAction:[CCActionRepeatForever actionWithAction:[CCActionRotateBy actionWithDuration:1 angle:30]]];
    
    // loop video forever
    [sprite playFromTime:0 loop:YES];
}

//----------------------------------------------------------------------

@end














































