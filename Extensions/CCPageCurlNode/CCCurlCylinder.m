/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2012-2015 Lars Birkemose
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

#import "CCCurlCylinder.h"

// -----------------------------------------------------------------------

@implementation CCCurlCylinder
{
    CGPoint _center;
    CGPoint _cornerA;
    CGPoint _cornerB;
    float _diagonal;
    float _hypotenuse;
}

// -----------------------------------------------------------------------

+ (instancetype)cylinderWithDiameter:(float)diameter pageDefinition:(CCPageDefinition)pageDefinition
{
    return [[self alloc] initWithDiameter:diameter pageDefinition:pageDefinition];
}

- (instancetype)initWithDiameter:(float)diameter pageDefinition:(CCPageDefinition)pageDefinition
{
    self = [super init];
    
    // set up
    _diameter = diameter;
    _pageDefinition = pageDefinition;
    _active = NO;
    
    //done
    return self;
}

// -----------------------------------------------------------------------

- (BOOL)begin:(CGPoint)pos
{
    NSAssert(!_active, @"Cylinder is already active");
    
    // check if inside page
    if ((pos.x < 0) || (pos.x > _pageDefinition.size.width)) return NO;
    if ((pos.y < 0) || (pos.y > _pageDefinition.size.height)) return NO;
    
    // calculate some helper values
    _center = ccp(_pageDefinition.size.width * 0.5, _pageDefinition.size.height * 0.5);
    _diagonal = ccpLength(ccp(_pageDefinition.size.width, _pageDefinition.size.height));
    
    // find corner to grab
    switch (_pageDefinition.anchor)
    {
        case CCPageAnchorLeft:
            _anchorPosition = ccp(0, 0);
            _anchorVector = ccp(0, _pageDefinition.size.height);
            _pageVector = ccp(_pageDefinition.size.width, 0);
            if (pos.y < _center.y)
            {
                _startPosition = ccp(_pageDefinition.size.width, 0);
                _cornerA = ccp(0, 0);
                _cornerB = ccp(_pageDefinition.size.width, _pageDefinition.size.height);
            }
            else
            {
                _startPosition = ccp(_pageDefinition.size.width, _pageDefinition.size.height);
                _cornerA = ccp(_pageDefinition.size.width, 0);
                _cornerB = ccp(0, _pageDefinition.size.height);
            }
            _hypotenuse = _pageDefinition.size.width;
            break;
            
        case CCPageAnchorTop:
            _anchorPosition = ccp(0, _pageDefinition.size.height);
            _anchorVector = ccp(_pageDefinition.size.width, 0);
            _pageVector = ccp(0, -_pageDefinition.size.height);
             if (pos.x < _center.x)
             {
                 _startPosition = ccp(0, 0);
                 _cornerA = ccp(0, _pageDefinition.size.height);
                 _cornerB = ccp(_pageDefinition.size.width, 0);
             }
             else
             {
                 _startPosition = ccp(_pageDefinition.size.width, 0);
                 _cornerA = ccp(0, 0);
                 _cornerB = ccp(_pageDefinition.size.width, _pageDefinition.size.height);
             }
            _hypotenuse = _pageDefinition.size.height;
            break;
            
        case CCPageAnchorRight:
            _anchorPosition = ccp(_pageDefinition.size.width, _pageDefinition.size.height);
            _anchorVector = ccp(0, -_pageDefinition.size.height);
            _pageVector = ccp(-_pageDefinition.size.width, 0);
            if (pos.y < _center.y) {
                _startPosition = ccp(0, 0);
                _cornerA = ccp(0, _pageDefinition.size.height);
                _cornerB = ccp(_pageDefinition.size.width, 0);
            }
            else
            {
                _startPosition = ccp(0, _pageDefinition.size.height);
                _cornerA = ccp(_pageDefinition.size.width, _pageDefinition.size.height);
                _cornerB = ccp(0, 0);
            }
            _hypotenuse = _pageDefinition.size.width;
            break;
            
        case CCPageAnchorBottom:
            _anchorPosition = ccp(_pageDefinition.size.width, 0);
            _anchorVector = ccp(-_pageDefinition.size.width, 0);
            _pageVector = ccp(0, _pageDefinition.size.height);
            if (pos.x < _center.x)
            {
                _startPosition = ccp(0, _pageDefinition.size.height);
                _cornerA = ccp(_pageDefinition.size.width, _pageDefinition.size.height);
                _cornerB = ccp(0, 0);
            }
            else
            {
                _startPosition = ccp(_pageDefinition.size.width, _pageDefinition.size.height);
                _cornerA = ccp(_pageDefinition.size.width, 0);
                _cornerB = ccp(0, _pageDefinition.size.height);
            }
            _hypotenuse = _pageDefinition.size.height;
            break;
            
        default:
            NSAssert(NO, @"Invalid page anchor");
            break;
    }

    // perform an update, to calculate cylinder data
    [self update:pos];
    
    // begin successful
    _active = YES;
    return YES;
}

// -----------------------------------------------------------------------

- (void)update:(CGPoint)pos
{
    CGPoint perp;
    float s,t;
    CGPoint anchorEnd = ccpAdd(_anchorPosition, _anchorVector);
    
    _position = pos;
    
    // clamp position to max length from start position
    float distance = ccpDistance(_position, _startPosition);
    if (distance > _hypotenuse)
    {
        distance = _hypotenuse;
        _position = ccpAdd(ccpMult(ccpNormalize(ccpSub(_position, _startPosition)), _hypotenuse), _startPosition);
    }
    
    
    // create cylinder axis
    perp = ccpNormalize(ccpPerp(ccpSub(_position, _startPosition)));
    _endPositionA = ccpAdd(_position, ccpMult(perp, _diagonal));
    _endPositionB = ccpSub(_position, ccpMult(perp, _diagonal));
    
    // find out if axis intersects anchor
    if (ccpLineIntersect(_endPositionA, _endPositionB, _anchorPosition, anchorEnd, &s, &t))
    {
        if ((t > 0) && (t < 1))
        {
            // adjust cylinder position to prevent anchor intersection
            
            // calculate the perpendicular length
            float perpLength = sqrtf((_hypotenuse * _hypotenuse) - (distance * distance));
            
            // calculate triangle height (y coordinate)
            float s = (distance + perpLength + _hypotenuse) / 2.0;
            float area = sqrtf(s * (s - distance) * (s - perpLength) * (s - _hypotenuse));
            float y = 2.0f * area / _hypotenuse;
            
            // calculate x coordinate
            float x = sqrtf((perpLength * perpLength) - (y * y));
            
            // we have no real vertex information, and whatever we have is lost in the area calculation,
            // so we painstakingly have to adjust according to anchor and start position
            switch (_pageDefinition.anchor) {
                case CCPageAnchorLeft:
                    _position = (_startPosition.y == 0)
                    ? ccp(x, y)
                    : ccp(x, _pageDefinition.size.height - y);
                    break;
                    
                case CCPageAnchorTop:
                    _position = (_startPosition.x == 0)
                    ? ccp(y, _pageDefinition.size.height - x)
                    : ccp(_pageDefinition.size.width - y, _pageDefinition.size.height - x);
                    break;
                    
                case CCPageAnchorRight:
                    _position = (_startPosition.y == 0)
                    ? ccp(_pageDefinition.size.width - x, y)
                    : ccp(_pageDefinition.size.width - x, _pageDefinition.size.height - y);
                    break;
                    
                case CCPageAnchorBottom:
                    _position = (_startPosition.x == 0)
                    ? ccp(y, x)
                    : ccp(_pageDefinition.size.width - y, x);
                    break;
            }
            
            // re-calculate cylinder axis
            perp = ccpNormalize(ccpPerp(ccpSub(_position, _startPosition)));
            _endPositionA = ccpAdd(_position, ccpMult(perp, _diagonal));
            _endPositionB = ccpSub(_position, ccpMult(perp, _diagonal));
        }
    }
    
    // after cylinder now is placed in a valid position, the diameter has to be adjusted, of to close to anchor
    // first adjust endpoints to always be perpendicular to page corners
    ccpLineIntersect(_startPosition, _cornerA, _endPositionA, _endPositionB, &s, &t);
    CGPoint posA = ccpAdd(_endPositionA, ccpMult(ccpSub(_endPositionB, _endPositionA), t));
    CGPoint projectionA = ccpProject(ccpSub(_cornerA, posA), ccpSub(_endPositionA, posA));
     _endPositionA = ccpAdd(posA, projectionA);
    
    ccpLineIntersect(_startPosition, _cornerB, _endPositionA, _endPositionB, &s, &t);
    CGPoint posB = ccpAdd(_endPositionA, ccpMult(ccpSub(_endPositionB, _endPositionA), t));
    CGPoint projectionB = ccpProject(ccpSub(_cornerB, posB), ccpSub(_endPositionA, posB));
    _endPositionB = ccpAdd(posB, projectionB);
    
    // now the end radius can be adjusted
    _radiusA = _radiusB = _diameter * 0.5;
    
    float lengthA = ccpDistance(_endPositionA, _anchorPosition);
    if (lengthA < _radiusA) _radiusA = lengthA;
    
    float lengthB = ccpDistance(_endPositionB, ccpAdd(_anchorPosition, _anchorVector));
    if (lengthB < _radiusB) _radiusB = lengthB;
    
    // and we are done!
}

// -----------------------------------------------------------------------

- (void)end:(CGPoint)pos
{
    _active = NO;
}

// -----------------------------------------------------------------------
// curls any given point. returns true if facing downwards

- (BOOL)curl:(GLKVector4 *)vector
{
    CGPoint pos = ccp(vector->x, vector->y);
    // calculate cylinder axis intersection
    CGPoint projection = ccpProject(ccpSub(pos, _position), ccpSub(_endPositionB, _endPositionA));
    CGPoint intersect = ccpAdd(_position, projection);
    
    // find out if pos is in curl area
    // if distance from start to pos, is greater than to intersection, point is not curled
    vector->z = 0;
    if (ccpDistance(_startPosition, pos) >= ccpDistance(_startPosition, intersect)) return NO;
    
    // point must be curled
    // find diameter at intersection point
    float ratio = ccpDistance(_endPositionA, intersect) / ccpDistance(_endPositionA, _endPositionB);
    float radius = _radiusA + ((_radiusB - _radiusA) * ratio);
    
    // calculate curled point
    float curlLength = ccpDistance(pos, intersect);
    CGPoint curlVector = ccpNormalize(ccpSub(intersect, pos));
    float height = 1;
    if (curlLength < radius * M_PI)
    {
        // sinus curl
        height = curlLength / (radius * M_PI);
        curlLength = -sinf(curlLength / radius) * radius;
    }
    else
    {
        // linear curl
        curlLength -= radius * M_PI;
    }
    pos = ccpAdd(intersect, ccpMult(curlVector, curlLength));
    
    *vector = (GLKVector4){pos.x, pos.y, height, 1};
    
    // for now, just return YES
    // TODO:
    return YES;
}

// -----------------------------------------------------------------------

@end























