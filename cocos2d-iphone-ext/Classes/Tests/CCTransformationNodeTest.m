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
#import "cardNode.h"

//----------------------------------------------------------------------

typedef enum
{
    CCFlipTypePitchRotation,
    CCFlipTypeRollRotation,
    CCFlipTypePitchRoll,
} CCFlipType;

//----------------------------------------------------------------------

@interface CCTransformationNodeTest : TestBase

@end

//----------------------------------------------------------------------

@implementation CCTransformationNodeTest
{
    CCTransformationNode *_transformation;
    CCNode *_card;
    CCFlipType _flipType;
}

// -----------------------------------------------------------------

- (NSArray *)testConstructors
{
    return [NSArray arrayWithObjects:
            @"cardFlipTestA",
            @"cardFlipTestB",
            @"cardFlipTestC",
            nil];
}

// -----------------------------------------------------------------

- (void)cardFlipTest
{
    // Load card images
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"cards.classic.plist"];
    
    _transformation = [CCTransformationNode node];
    
    // defindes the amount of perspective, added to the transfomation
    // 1.0 is default, and adds a "medium" sense of perspective
    _transformation.perspective = 1.0;
    
    _transformation.positionType = CCPositionTypeNormalized;
    _transformation.position = ccp(0.5, 0.5);
    
    [self.contentNode addChild:_transformation];
    
    _card = [cardNode cardWithName:[cardNode randomCardName]];
    // _card.scale = 2;
    _card.name = @"card.0";
    [_transformation addChild:_card];
}

// -----------------------------------------------------------------

- (void)cardFlipTestA
{
    self.subTitle = @"Pitch + Rotation";
    _flipType = CCFlipTypePitchRotation;
    [self cardFlipTest];
}

- (void)cardFlipTestB
{
    self.subTitle = @"Roll + Rotation";
    _flipType = CCFlipTypeRollRotation;
    [self cardFlipTest];
}

- (void)cardFlipTestC
{
    self.subTitle = @"Pitch + Roll";
    _flipType = CCFlipTypePitchRoll;
    [self cardFlipTest];
}

//----------------------------------------------------------------------

- (void)update:(CCTime)delta
{
    delta *= 0.125;
    
    CCNode *card = [self getChildByName:@"card.0" recursively:YES];
    
    if ([card isKindOfClass:[cardNode class]])
    {
        ((cardNode *)card).backFacing = _transformation.isBackFacing;
    }
    
    switch (_flipType) {
        case CCFlipTypePitchRoll:
            _transformation.pitch += 11.0 * delta;
            _transformation.roll += delta;
            break;
            
        case CCFlipTypePitchRotation:
            _transformation.pitch += 11.0 * delta;
            // _transformation.rotation += 100 * delta;
            _transformation.yaw += delta;
            break;
            
        case CCFlipTypeRollRotation:
            _transformation.roll += 11.0 * delta;
            // _transformation.rotation += 100 * delta;
            _transformation.yaw += delta;
            break;
    }
}

//----------------------------------------------------------------------

@end
