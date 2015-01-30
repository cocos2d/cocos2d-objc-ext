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

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TestBase.h"
#import "CCBusyNode.h"

//----------------------------------------------------------------------

@interface CCBusyNodeTest : TestBase

@end

//----------------------------------------------------------------------

@implementation CCBusyNodeTest
{
    BOOL _psychedelic;
    float _timing;
}

- (NSArray *)testConstructors
{
    return [NSArray arrayWithObjects:
            @"busyTest",
            nil];
}

- (void)busyTest
{
    self.subTitle = @"Click button to toggle busy test";

    CCButton *button = [CCButton buttonWithTitle:@"[ undefined ]"];
    button.positionType = CCPositionTypeNormalized;
    button.position = ccp(0.5, 0.5);
    [self.contentNode addChild:button];
    [button setTarget:self selector:@selector(busyClicked:)];
    
    // create a busy node
    CCBusyNode *busy = [CCBusyNode new];
    [self.contentNode addChild:busy];
    busy.positionType = CCPositionTypeNormalized;
    busy.position = ccp(0.5, 0.7);
    busy.color = [CCColor yellowColor];
    busy.scale = 1.5;
    busy.name = @"busy";
    busy.visible = NO;

    // force a click to turn busy node on
    [self busyClicked:button];
}

- (void)busyClicked:(id)sender
{
    CCBusyNode *busy = (CCBusyNode *)[self.contentNode getChildByName:@"busy" recursively:YES];
    CCButton *button = (CCButton *)sender;
    
    if (!busy.visible)
    {
        busy.visible = YES;
        button.title = @"[ Application busy ]";
    }
    else
    {
        busy.visible = NO;
        button.title = @"[ Not busy ]";
    }
}

@end











