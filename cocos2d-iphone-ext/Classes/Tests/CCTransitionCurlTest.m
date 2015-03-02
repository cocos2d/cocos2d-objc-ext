//
//  CCTransitionCurlTest.m
//  cocos2d-iphone-ext
//
//  Created by Lars Birkemose on 02/03/15.
//  Copyright 2015 Cocos2D-iphone. All rights reserved.
//

#import "TestBase.h"
#import "CCTransitionCurlIn.h"
#import "CCTransitionCurlOut.h"
#import "bookPage.h"

//----------------------------------------------------------------------

@interface CCTransitionCurlTest : TestBase @end

//----------------------------------------------------------------------

@implementation CCTransitionCurlTest
{
    CCTransition* _transition;
}

- (NSArray*) testConstructors
{
    return [NSArray arrayWithObjects:
            @"curlOutTest",
            @"curlInTest",
            // TODO: Fix all tests
            nil];
}

//----------------------------------------------------------------------

- (void)curlOutTest
{
    self.subTitle = @"Curl out test";
    _transition = [CCTransitionCurlOut transitionCurlOutWithDirection:CCTransitionDirectionLeft duration:0.75];

    CCNodeColor* bgLayer = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.6 green:0.6 blue:0.6]];
    bgLayer.contentSize = CGSizeMake(1, 1);
    bgLayer.contentSizeType = CCSizeTypeNormalized;
    [self.contentNode addChild:bgLayer];

    CCLabelTTF *label;
    
    label = [CCLabelTTF labelWithString:@"Some have curly hair" fontName:@"ArialMT" fontSize:48];
    label.positionType = CCPositionTypeNormalized;
    label.position = ccp(0.5,0.75);
    [self.contentNode addChild:label];
    
    label = [CCLabelTTF labelWithString:@"Cocos2D-SpriteBuilder has" fontName:@"ArialMT" fontSize:48];
    label.positionType = CCPositionTypeNormalized;
    label.position = ccp(0.5,0.6);
    label.color = [CCColor colorWithRed:0.4 green:0.4 blue:0.1];
    [self.contentNode addChild:label];
    
    label = [CCLabelTTF labelWithString:@"curly transitions" fontName:@"ArialMT" fontSize:64];
    label.positionType = CCPositionTypeNormalized;
    label.position = ccp(0.5,0.45);
    [self.contentNode addChild:label];

}

//----------------------------------------------------------------------

- (void)curlInTest
{
    self.subTitle = @"Curl in test";
    _transition = [CCTransitionCurlIn transitionCurlInWithDirection:CCTransitionDirectionLeft duration:0.75];
    
    bookPage *page = [bookPage spriteWithImageNamed:@"moon.png"];
    page.positionType = CCPositionTypeNormalized;
    page.position = ccp(0.5, 0.5);
    [self.contentNode addChild:page];
    
    CCLabelTTF *label;
 
    label = [CCLabelTTF labelWithString:@"Drag image ->" fontName:@"ArialMT" fontSize:24];
    label.positionType = CCPositionTypeNormalized;
    label.position = ccp(0.15,0.15);
    label.rotation = 20;
    [self.contentNode addChild:label];

    
}

//----------------------------------------------------------------------

- (void)pressedNext:(id)sender
{
    NSInteger newTest = _currentTest + 1;
    if (newTest >= self.testConstructors.count) newTest = 0;
    
    CCScene* testScene = [TestBase sceneWithTestName:self.testName];
    [[[testScene children] objectAtIndex:0] setupTestWithIndex:newTest];
    
    [[CCDirector sharedDirector] replaceScene:testScene withTransition:_transition];
}

- (void)pressedPrev:(id)sender
{
    NSInteger newTest = _currentTest - 1;
    if (newTest < 0) newTest = self.testConstructors.count - 1;
    
    CCScene* testScene = [TestBase sceneWithTestName:self.testName];
    [[[testScene children] objectAtIndex:0] setupTestWithIndex:newTest];
    
    [[CCDirector sharedDirector] replaceScene:testScene withTransition:_transition];
}

//----------------------------------------------------------------------

@end
