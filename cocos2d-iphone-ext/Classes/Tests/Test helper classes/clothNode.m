/*
 * cocos2d for iPhone: http://www.cocos2d-swift.org
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

#import "clothNode.h"
#import "clothRope.h"
#import "CCSpriteGrid.h"

// -----------------------------------------------------------------------

@implementation clothNode
{
    NSMutableArray *_ropes;
}

// -----------------------------------------------------------------------

- (instancetype)init
{
    self = [super init];
    // initialise
    _clothAnchor = clothAnchorTop;
    _iterations = 5;
    _elasticity = 0.00;
    _stiffness = 0.25;
    _gravity = (CGPoint){0, -100};
    _ropes = nil;
    // done
    return self;
}

// -----------------------------------------------------------------------

- (void)createRopes
{
    // get sprite grid to work on
    CCSpriteGrid *grid = (CCSpriteGrid *)self.parent;

    _ropes = [NSMutableArray array];
    for (NSUInteger count = 0; count <= grid.gridWidth; count ++)
    {
        clothRope *rope = [clothRope clothRopeWithLength:grid.contentSize.height andSegments:grid.gridHeight];
        CGPoint pos = [grid vertexPosition:count];
        rope.position = (CGPoint)ccp(pos.x, 0);
        rope.gridIndex = count;
        
        [_ropes addObject:rope];
    }
}

// -----------------------------------------------------------------------

- (void)updateCloth:(CCTime)delta
{
    NSAssert((self.parent == nil) || ([self.parent isKindOfClass:[CCSpriteGrid class]]),
             @"A clothNode's parent must be a CCSpriteGrid");

    // make sure cloth is ready for use
    if (_ropes == nil) [self createRopes];

    // get sprite grid to work on
    CCSpriteGrid *grid = (CCSpriteGrid *)self.parent;
    
    // apply cloth simulation
    for (clothRope *rope in _ropes)
    {
        [rope update:delta angle:-grid.rotation];
        NSUInteger index = rope.gridIndex;
        for (NSUInteger count = 0; count <= grid.gridHeight; count ++)
        {
            CGPoint adjustment = [rope ropePos:count];
            CGPoint origin = [grid vertexPosition:index];
            adjustment = (CGPoint){adjustment.x, adjustment.y - (grid.contentSize.height - origin.y)};
            [grid adjustVertex:index adjustment:adjustment];
            index += (grid.gridWidth + 1);
        }
    }
}

// -----------------------------------------------------------------------

@end
