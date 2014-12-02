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

#import "rippleNode.h"
#import "CCSpriteGrid.h"

// -----------------------------------------------------------------------

@implementation rippleNode
{
    float _absoluteSpeed;
    float _absoluteRippleStrength;
    float _absoluteRippleWidth;
    float _absoluteMaxSize;
}

// -----------------------------------------------------------------------

+ (instancetype)rippleNodeAt:(CGPoint)pos
{
    return [[self alloc] initAt:pos];
}

- (instancetype)initAt:(CGPoint)pos
{
    self = [super init];
    
    // initialize to defaults
    _life = 2.0f;
    _normalizedSpeed = 1.0;
    _ripples = 5;
    _periodTime = 1.0;
    _normalizedRippleStrength = 1.0;
    _normalizedMaxSize = 1.0;
    _modifyEdges = NO;
    _modifyTexture = NO;
    
    _centre = pos;
    _size = 0;
    _age = 0;
    
    // internal stuff
    _absoluteSpeed = -1;
    _absoluteRippleStrength = -1;
    _absoluteRippleWidth = -1;

    // done
    return self;
}

- (void)update:(CCTime)delta
{
    NSAssert((self.parent == nil) || ([self.parent isKindOfClass:[CCSpriteGrid class]]),
             @"A rippleNode's parent must be a CCSpriteGrid");

    // get sprite grid to work on
    CCSpriteGrid *grid = (CCSpriteGrid *)self.parent;

    // check if absolute data has been assigned
    if (_absoluteSpeed < 0)
    {
        _absoluteSpeed = grid.contentSize.width * _normalizedSpeed;
        _absoluteRippleStrength = grid.contentSize.width * _normalizedRippleStrength * 0.01f;
        _absoluteRippleWidth = grid.contentSize.width * _periodTime;
        _absoluteMaxSize = grid.contentSize.width * _normalizedMaxSize;
    }
    
    // update data
    _age += delta;
   _size += (_absoluteSpeed * delta);
    
    // scan through all the nodes in grid
    for (NSUInteger index = 0; index < grid.vertexCount; index ++)
    {
        if (_modifyEdges || ![grid isEdge:index])
        {
            CGPoint vertexPos = [grid vertexPosition:index];
            float distance = ccpDistance(vertexPos, _centre);
            if (distance <= _size)
            {
                float progress = clampf((_size - distance) / (_absoluteRippleWidth * _ripples), 0, 1);
                progress = (1 - progress) * (1 - progress);
                progress *= clampf((_absoluteMaxSize - distance) / _absoluteMaxSize, 0, 1);
                
                // calculate movement of vertex
                float sin = sinf((_size - distance) / _absoluteRippleWidth * 2 * M_PI);
                float gain = sin * _absoluteRippleStrength * progress;
                
                CGPoint adjustment = ccpSub(vertexPos, _centre);
                
                if (_modifyTexture)
                {
                    adjustment = ccpMult(adjustment, gain / distance * 0.01);
                    [grid adjustTextureCoordinate:index adjustment:adjustment];
                }
                else
                {
                    adjustment = ccpMult(adjustment, gain / distance);
                    [grid adjustVertex:index adjustment:adjustment];
                }
            }
        }
    }
    
    // check for ripple expired
    if (_age >= _life) [self.parent removeChild:self];
}

// -----------------------------------------------------------------------

@end
