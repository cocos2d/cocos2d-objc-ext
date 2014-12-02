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

#import "clothRope.h"

// -----------------------------------------------------------------------

typedef struct
{
    CGPoint position;
    float length;
    float angle;
    float angularVelocity;
} clothRopeSegment;

// -----------------------------------------------------------------------

@implementation clothRope
{
    clothRopeSegment *_segment;
}

// -----------------------------------------------------------------------

+ (instancetype)clothRopeWithLength:(float)length andSegments:(NSUInteger)segments
{
    return [[self alloc] initWithLength:length andSegments:segments];
}

- (instancetype)initWithLength:(float)length andSegments:(NSUInteger)segments
{
    self = [super init];
    //
    _position = CGPointZero;
    _segmentCount = segments;
    _segmentLength = length / segments;
    _segment = malloc(segments * sizeof(clothRopeSegment));
    CGPoint pos = (CGPoint){0, _segmentLength};
    for (NSUInteger index = 0; index < segments; index ++)
    {
        _segment[index].position = pos;
        _segment[index].angle = 0;
        _segment[index].length = _segmentLength;
        _segment[index].angularVelocity = 0;
        pos = ccpAdd(pos, (CGPoint){0, _segmentLength});
    }
    
    //
    return self;
}

// -----------------------------------------------------------------------

- (void)update:(CCTime)delta angle:(float)angle
{
    CGPoint pos = CGPointZero;
    float sumAngle = 0;
    
    for (NSUInteger index = 0; index < _segmentCount; index ++)
    {
        _segment[index].angle -= (_segment[index].angle - angle) * delta * 1.0;
        angle -= _segment[index].angle;
        sumAngle += _segment[index].angle;
        
        CGPoint vector = ccpRotateByAngle((CGPoint){0, _segment[index].length}, CGPointZero, sumAngle * M_PI / 180);
        _segment[index].position = ccpAdd(pos, vector);
        pos = _segment[index].position;
    }
}

// -----------------------------------------------------------------------

- (CGPoint)ropePos:(NSUInteger)index
{
    if (index == 0) return CGPointZero;
    return _segment[index - 1].position;
}

// -----------------------------------------------------------------------

@end
