//
//  CCSpriteGridTest.m
//  cocos2d-iphone-ext
//
//  Created by Lars Birkemose on 15/09/14.
//  Copyright 2014 Cocos2D-iphone. All rights reserved.
//

#import "TestBase.h"
#import "CCSpriteGrid.h"
#import "rippleNode.h"

#define GridCount 48
#define GridTouchInterval 20

//----------------------------------------------------------------------

typedef enum
{
    SpriteGridTestTypeNervousPebbles,
    SpriteGridTestTypeRubberThing,
    SpriteGridTestTypeWaterRipples,

} SpriteGridTestType;

//----------------------------------------------------------------------

@interface CCSpriteGridTest : TestBase
{
    CCSpriteGrid *_grid;
    SpriteGridTestType _testType;
    CGPoint _lastTouch;
}


@end

//----------------------------------------------------------------------

@implementation CCSpriteGridTest

- (NSArray *)testConstructors
{
    return [NSArray arrayWithObjects:
            @"waterRipples",
            @"rubberThing",
            @"nervousPebbles",
            nil];
}

- (CCSpriteGrid *)createGrid
{
    CCSpriteGrid *grid = [CCSpriteGrid spriteWithImageNamed:@"pebbles.png"];
    grid.positionType = CCPositionTypeNormalized;
    grid.position = ccp(0.5, 0.5);
    [grid setGridWidth:GridCount andHeight:GridCount];
    return grid;
}

// -----------------------------------------------------------------------

- (void)nervousPebbles
{
    self.subTitle = @"Nervous Pebbles";
    _testType = SpriteGridTestTypeNervousPebbles;
    
    // load pebbles
    _grid = [self createGrid];
    [self.contentNode addChild:_grid];
}

// -----------------------------------------------------------------------

- (void)rubberThing
{
    self.subTitle = @"Rubber Thing";
    _testType = SpriteGridTestTypeRubberThing;
    self.userInteractionEnabled = YES;
    
    // load pebbles
    _grid = [self createGrid];
    [self.contentNode addChild:_grid];
}

// -----------------------------------------------------------------------

- (void)waterRipples
{
    self.subTitle = @"Water Ripples";
    _testType = SpriteGridTestTypeWaterRipples;
    self.userInteractionEnabled = YES;
    
    // load pebbles
    _grid = [self createGrid];
    [self.contentNode addChild:_grid];
    
    
    
    CCPhysicsNode *physics = [CCPhysicsNode node];
    [self.contentNode addChild:physics];
    
    [CCDirector sharedDirector].fixedUpdateInterval = 1.0 / 120.0;
    
    
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    _lastTouch = ccp(-GridTouchInterval, -GridTouchInterval);
    [self touchMoved:touch withEvent:event];
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint pos = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[CCDirector sharedDirector].view]];

    // check for valid touch
    if (![_grid hitTestWithWorldPos:pos]) return;
    if (ccpDistance(_lastTouch, pos) < GridTouchInterval) return;

    _lastTouch = pos;
    
    // register a grid touch
    switch (_testType)
    {
        // does not respond to touches
        case SpriteGridTestTypeNervousPebbles:
            break;
            
        // make a rubber ripple
        case SpriteGridTestTypeRubberThing:
        {
            rippleNode *ripple = [rippleNode rippleNodeAt:[_grid convertToNodeSpace:pos]];
            
            // default a rubber - blupper effect
            ripple.modifyEdges = YES;
            [_grid addChild:ripple];
            break;
        }

        // make a water ripple
        case SpriteGridTestTypeWaterRipples:
        {
            rippleNode *ripple = [rippleNode rippleNodeAt:[_grid convertToNodeSpace:pos]];
            
            // ripple data for watter ripples
            ripple.modifyEdges = NO;
            ripple.ripples = 2.0;
            ripple.life = 2.00;
            ripple.normalizedSpeed = 0.75;
            ripple.normalizedRippleStrength = 0.50;
            ripple.periodTime = 0.15;
            ripple.modifyTexture = YES;
            
            [_grid addChild:ripple];
            break;
        }
    }
}

// -----------------------------------------------------------------------
// update functions
// -----------------------------------------------------------------------

- (void)update:(CCTime)delta
{
    [_grid resetGrid];
    
    switch (_testType)
    {
        case SpriteGridTestTypeNervousPebbles:
            for (NSUInteger index = 0; index < _grid.vertexCount; index ++)
            {
                if (![_grid isEdge:index])
                {
                    [_grid adjustVertex:index adjustment:ccp(CCRANDOM_MINUS1_1() * 3, CCRANDOM_MINUS1_1() * 3)];
                }
            }
            break;

        case SpriteGridTestTypeRubberThing:
            break;
            
        case SpriteGridTestTypeWaterRipples:
            break;
            
    }
}

// -----------------------------------------------------------------------

- (void)updateNervousPebbles:(CCTime)delta
{
}

@end

