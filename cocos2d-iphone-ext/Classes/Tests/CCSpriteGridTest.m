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
#import "clothNode.h"

#define GridCountDefault 48
#define GridCountCloth 16
#define GridCountStream 16

#define GridTouchInterval 20

#define GridClothWobbleAngle 10
#define GridClothWobbleTime 1.5

//----------------------------------------------------------------------

typedef enum
{
    SpriteGridTestTypeNervousPebbles,
    SpriteGridTestTypeRubberThing,
    SpriteGridTestTypeWaterRipples,
    SpriteGridTestTypeCloth,

} SpriteGridTestType;

//----------------------------------------------------------------------

@interface CCSpriteGridTest : TestBase
{
    CCSpriteGrid *_grid;
    SpriteGridTestType _testType;
    CGPoint _lastTouch;
    float _timing;
}

@end

//----------------------------------------------------------------------

@implementation CCSpriteGridTest

- (NSArray *)testConstructors
{
    return [NSArray arrayWithObjects:
            @"cloth",
            @"waterRipples",
            @"rubberThing",
            @"nervousPebbles",
            nil];
}

- (CCSpriteGrid *)createGrid:(NSUInteger)count
{
    CCSpriteGrid *grid = [CCSpriteGrid spriteWithImageNamed:@"pebbles.png"];
    grid.positionType = CCPositionTypeNormalized;
    grid.position = ccp(0.5, 0.5);
    grid.colorRGBA = [CCColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.25];
    [grid setGridWidth:count andHeight:count];
    return grid;
}

// -----------------------------------------------------------------------

- (void)nervousPebbles
{
    self.subTitle = @"Nervous Pebbles";
    _testType = SpriteGridTestTypeNervousPebbles;
    
    // load pebbles
    _grid = [self createGrid:GridCountStream];
    [self.contentNode addChild:_grid];
}

// -----------------------------------------------------------------------

- (void)rubberThing
{
    self.subTitle = @"Rubber Thing";
    _testType = SpriteGridTestTypeRubberThing;
    self.userInteractionEnabled = YES;
    
    // load pebbles
    _grid = [self createGrid:GridCountDefault];
    [self.contentNode addChild:_grid];
}

// -----------------------------------------------------------------------

- (void)waterRipples
{
    self.subTitle = @"Water Ripples";
    _testType = SpriteGridTestTypeWaterRipples;
    self.userInteractionEnabled = YES;
    
    // load pebbles
    _grid = [self createGrid:GridCountDefault];
    [self.contentNode addChild:_grid];
}

// -----------------------------------------------------------------------

- (void)cloth
{
    self.subTitle = @"Cloth Simulation";
    _testType = SpriteGridTestTypeCloth;
    self.userInteractionEnabled = YES;
    
    // load pebbles
    _grid = [self createGrid:GridCountCloth];
    [self.contentNode addChild:_grid];

    // let the cloth rotate back and forth
    [_grid runAction:
     [CCActionRepeatForever actionWithAction:
      [CCActionSequence actions:
       [CCActionEaseSineInOut actionWithAction:
        [CCActionRotateTo actionWithDuration:GridClothWobbleTime angle:-GridClothWobbleAngle]],
       [CCActionEaseSineInOut actionWithAction:
        [CCActionRotateTo actionWithDuration:GridClothWobbleTime angle:+GridClothWobbleAngle]],
       nil]]];

    // load cloth simulation
    clothNode *cloth = [clothNode node];
    [_grid addChild:cloth];
}

// -----------------------------------------------------------------------

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    _lastTouch = ccp(-GridTouchInterval, -GridTouchInterval);
    [self touchMoved:touch withEvent:event];
}

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    CGPoint pos = [[CCDirector sharedDirector] convertToGL:[touch locationInView:(CCGLView *)[CCDirector sharedDirector].view]];

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
            ripple.normalizedRippleStrength = 0.75;
            ripple.normalizedMaxSize = 0.50;
            ripple.periodTime = 0.15;
            ripple.modifyTexture = YES;
            
            [_grid addChild:ripple];
            break;
        }
            
        // affect cloth
        case SpriteGridTestTypeCloth:
            break;
    }
}

// -----------------------------------------------------------------------
// update functions
// -----------------------------------------------------------------------

- (void)update:(CCTime)delta
{
    
    switch (_testType)
    {
        case SpriteGridTestTypeNervousPebbles:
            [_grid resetGrid];

            _timing += delta;
            for (NSUInteger index = 0; index < _grid.vertexCount; index ++)
            {
                if (![_grid isEdge:index])
                {
                    [_grid adjustTextureCoordinate:index adjustment:ccp(CCRANDOM_MINUS1_1() * 0.0075,
                                                                        CCRANDOM_MINUS1_1() * 0.0075)];
                    float color = CCRANDOM_0_1() * -0.2;
                    [_grid adjustColor:index adjustment:[CCColor colorWithRed:color green:color blue:color]];
                }
            }
            break;

        case SpriteGridTestTypeRubberThing:
            [_grid resetGrid];
            break;
            
        case SpriteGridTestTypeWaterRipples:
            [_grid resetGrid];
            break;

        case SpriteGridTestTypeCloth:
        {
            [_grid resetGrid];
            clothNode *cloth = (clothNode *)[_grid.children objectAtIndex:0];
            [cloth updateCloth:delta];
            break;
        }
    }
}

// -----------------------------------------------------------------------

- (void)updateNervousPebbles:(CCTime)delta
{
}

@end

