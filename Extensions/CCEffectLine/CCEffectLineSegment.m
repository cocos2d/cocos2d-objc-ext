/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2014-2015 Lars Birkemose
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

#import "CCEffectLineSegment.h"

@implementation NSValue(CCEffectLineSegment)

- (GLKVector4)GLKVector4Value
{
    GLKVector4 result;
    [self getValue:&result];
    return result;
}

@end

// -----------------------------------------------------------------------

@implementation CCEffectLineSegment
{
    CGPoint _sumGravity;
}

// -----------------------------------------------------------------------

+ (instancetype)segmentWithDictionary:(NSDictionary *)settings
{
    return [[self alloc] initWithDictionary:settings];
}

- (instancetype)initWithDictionary:(NSDictionary *)settings
{
    self = [super init];

    // load from dictionary
    _position = [[settings objectForKey:@"position"] CGPointValue];
    _direction = [[settings objectForKey:@"direction"] CGPointValue];
    _wind = [[settings objectForKey:@"wind"] CGPointValue];
    _gravity = [[settings objectForKey:@"gravity"] CGPointValue];
    _life = [[settings objectForKey:@"life"] floatValue];
    _age = [[settings objectForKey:@"startAge"] floatValue];
    _textureOffset = [[settings objectForKey:@"textureOffset"] floatValue];
    _widthStart = [[settings objectForKey:@"widthStart"] floatValue];
    _widthEnd = [[settings objectForKey:@"widthEnd"] floatValue];
    _colorStart = [[settings objectForKey:@"colorStart"] GLKVector4Value];
    _colorEnd = [[settings objectForKey:@"colorEnd"] GLKVector4Value];
    _color = _colorStart;
    _sumGravity = CGPointZero;

    // reset internal stuff
    _progress = 0;
    _hasChanged = YES;
    _width = _widthStart;

    // pre-calculate internal stuff
    _direction = ccpNormalize(_direction);
    CGPoint perp = ccpMult(ccpPerp(_direction), _width * 0.5);
    _posA = ccpSub(_position, perp);
    _posB = ccpAdd(_position, perp);
    
    return self;
}

// -----------------------------------------------------------------------

- (void)update:(CCTime)delta
{
    _age += delta;
    _progress = (_life > 0) ? clampf(_age / _life, 0.0, 1.0) : 0.0f;
    
    _color.r = _colorStart.r + (_colorEnd.r - _colorStart.r ) * _progress;
    _color.g = _colorStart.g + (_colorEnd.g - _colorStart.g ) * _progress;
    _color.b = _colorStart.b + (_colorEnd.b - _colorStart.b ) * _progress;
    _color.a = _colorStart.a + (_colorEnd.a - _colorStart.a ) * _progress;

    float lastWidth = _width;
    float newWidth = _widthStart + ((_widthEnd - _widthStart) * _progress);
    if (fabs(lastWidth - newWidth) > 1.0)
    {
        _width = newWidth;
        CGPoint perp = ccpMult(ccpPerp(_direction), _width * 0.5);
        _posA = ccpSub(_position, perp);
        _posB = ccpAdd(_position, perp);
    }
    CGPoint change;
    // add gravity
    _sumGravity = ccpAdd(_sumGravity, ccpMult(_gravity, delta));
    change = ccpMult(_sumGravity, delta);
    // add wind
    change = ccpAdd(change, ccpMult(_wind, delta));
    _position = ccpAdd(_position, change);
    _posA = ccpAdd(_posA, change);
    _posB = ccpAdd(_posB, change);
}

// -----------------------------------------------------------------------

- (void)setPosA:(CGPoint)pos
{
    _posA = pos;
    _position = ccpMidpoint(_posA, _posB);
    _direction = ccpNormalize(ccpPerp(ccpSub(_posA, _posB)));
}

- (void)setPosB:(CGPoint)pos
{
    _posB = pos;
    _position = ccpMidpoint(_posA, _posB);
    _direction = ccpNormalize(ccpPerp(ccpSub(_posA, _posB)));
}

// -----------------------------------------------------------------------

- (BOOL)expired
{
    return (_age > _life);
}

- (void)setDirection:(CGPoint)direction
{
    _direction = ccpNormalize(direction);
    CGPoint perp = ccpMult(ccpPerp(ccpNormalize(_direction)), _width * 0.5);
    _posA = ccpSub(_position, perp);
    _posB = ccpAdd(_position, perp);
}

- (void)setWidth:(float)width
{
    NSAssert(width > 0, @"Width must be greater than 0");
    _width = width;
    _widthStart = _width;
    _widthEnd = _width;
    CGPoint perp = ccpMult(ccpPerp(_direction), _width * 0.5);
    _posA = ccpSub(_position, perp);
    _posB = ccpAdd(_position, perp);
}

// -----------------------------------------------------------------------

@end


































