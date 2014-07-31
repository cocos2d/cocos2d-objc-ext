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
#import "CCTransformationNode.h"
#import "CCCropNode.h"

#import "cardNode.h"

//----------------------------------------------------------------------

@interface CCCropNodeTest : TestBase

@end

//----------------------------------------------------------------------

@implementation CCCropNodeTest
{
    CCTransformationNode *_transformation;
    CCCropNode *_cropNode;
    cardNode *_card;
    CCSprite *_cropCard;
}

// -----------------------------------------------------------------

// -----------------------------------------------------------------

- (NSArray *)testConstructors
{
    return [NSArray arrayWithObjects:
            @"cropNodeTest",
            nil];
}

// -----------------------------------------------------------------

- (void)cropNodeTest
{
    self.subTitle = @"Click to change crop type";
    self.userInteractionEnabled = YES;

    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"cards.classic.plist"];
    
    CCSprite *temp = [CCSprite spriteWithImageNamed:[cardNode randomCardName]];
    temp.positionType = CCPositionTypeNormalized;
    temp.position = ccp(0.2, 0.2);
    temp.rotation = 10;
    [self.contentNode addChild:temp];
    
    CCButton *button = [CCButton buttonWithTitle:@"" spriteFrame:[CCSpriteFrame frameWithImageNamed:[cardNode randomCardName]]];
    button.positionType = CCPositionTypeNormalized;
    button.position = ccp(0.25, 0.25);
    [self.contentNode addChild:button];
    
    button.color = [CCColor colorWithRed:1 green:0 blue:0 alpha:0.25];
    
    _cropNode = [CCCropNode cropNode];
    [temp addChild:_cropNode];
    
    // add a card to the crop node
    _cropCard = [CCSprite spriteWithImageNamed:[cardNode randomCardName]];
    _cropCard.positionType = CCPositionTypeNormalized;
    _cropCard.position = ccp(0.5, 0.5);
    _cropCard.rotation = -10;
    [_cropNode addChild:_cropCard];

    _cropNode.mode = CCCropModeNone;
    [_cropNode setCropNode:_cropCard];
    CCLOG(@"%@", [_cropNode debugString]);
    
    _transformation = [CCTransformationNode node];
    _transformation.positionType = CCPositionTypeNormalized;
    _transformation.position = ccp(0.5, 0.5);
    [_cropNode addChild:_transformation];

    _card = [cardNode cardWithName:[cardNode randomCardName]];
    _card.scale = 2;
    [_transformation addChild:_card];
    
    
    
    
    
}

// -----------------------------------------------------------------

- (void)update:(CCTime)delta
{
    delta *= 0.125;
    
    _card.backFacing = _transformation.isBackFacing;
    _transformation.pitch += 11.0 * delta;
    _transformation.rotation += 100 * delta;    
}

// -----------------------------------------------------------------

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    _cropNode.mode = (_cropNode.mode + 1) % 4;
    CCLOG(@"%@", [_cropNode debugString]);
}

// -----------------------------------------------------------------

@end

