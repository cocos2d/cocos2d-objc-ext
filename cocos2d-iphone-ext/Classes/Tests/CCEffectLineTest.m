/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2008-2010 Ricardo Quesada
 * Copyright (c) 2011 Zynga Inc.
 * Copyright (c) 2013-2015 Cocos2D Authors
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
#import "effectLineNode.h"

//----------------------------------------------------------------------

@interface CCEffectLineTest : TestBase

@end

//----------------------------------------------------------------------

@implementation CCEffectLineTest

- (NSArray *)testConstructors
{
    return [NSArray arrayWithObjects:
            @"simpleLine",
            @"freeHand",
            @"smokeSimple",
            @"fog",
            @"swordEffect",
            @"bulletTrail",
            @"rocketTrail",
            @"electricity",
            @"smokeDragon",
            nil];
}

- (void)simpleLine { [self.contentNode addChild:[effectLineNode nodeWithLine:0]]; }
- (void)freeHand { [self.contentNode addChild:[effectLineNode nodeWithLine:1]]; }
- (void)smokeSimple { [self.contentNode addChild:[effectLineNode nodeWithLine:2]]; }
- (void)fog { [self.contentNode addChild:[effectLineNode nodeWithLine:3]]; }
- (void)swordEffect { [self.contentNode addChild:[effectLineNode nodeWithLine:4]]; }
- (void)bulletTrail { [self.contentNode addChild:[effectLineNode nodeWithLine:5]]; }
- (void)rocketTrail { [self.contentNode addChild:[effectLineNode nodeWithLine:6]]; }
- (void)electricity { [self.contentNode addChild:[effectLineNode nodeWithLine:7]]; }
- (void)smokeDragon { [self.contentNode addChild:[effectLineNode nodeWithLine:8]]; }

@end
