//
//  CCLayerSmoothLineTest.m
//  cocos2d-iphone-ext
//
//  Created by Lars Birkemose on 14/08/14.
//  Copyright 2014 Cocos2D-iphone. All rights reserved.
//

#import "TestBase.h"
#import "CCLayerSmoothLine.h"

//----------------------------------------------------------------------

@interface CCLayerSmoothLineTest : TestBase

@end

//----------------------------------------------------------------------

@implementation CCLayerSmoothLineTest

- (NSArray *)testConstructors
{
    return [NSArray arrayWithObjects:
            @"smoothLineTest",
            nil];
}

- (void)smoothLineTest
{
    self.subTitle = @"Touch and hold to wipe drawing";
    [self.contentNode addChild:[CCLayerSmoothLine layer]];
}

@end

//----------------------------------------------------------------------
