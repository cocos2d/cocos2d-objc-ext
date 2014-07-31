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

#import "CCSpriteMultiTouch.h"

//----------------------------------------------------------------------

#define CCSpriteMultiTouchMaxTouches 3
#define CCSpriteMultiTouchFuntionDisable 0

//----------------------------------------------------------------------

@implementation CCSpriteMultiTouch
{
    // must be weak, to avoid retaining touches
    __weak UITouch *_touch[CCSpriteMultiTouchMaxTouches];
    // variables used internally to
    CGPoint _dragCentre;
    CGPoint _scaleCentre;
    float _scaleStartDistance;
    float _scaleStartScale;
    CGPoint _rotationCentre;
    float _rotationLast;
}

//----------------------------------------------------------------------

- (instancetype)init
{
    self = [super init];
    // initialize
    _touchCountForDrag = CCSpriteMultiTouchFuntionDisable;
    _touchCountForScale = CCSpriteMultiTouchFuntionDisable;
    _touchCountForRotate = CCSpriteMultiTouchFuntionDisable;
    _touchCount = 0;
    // done
    return(self);
}

//----------------------------------------------------------------------
// helper functions

// calculates the centre of all current touches
- (CGPoint)centre
{
    CGPoint sum = CGPointZero;
    
    for (int index = 0; index < _touchCount; index ++)
    {
        CGPoint pos = [_touch[index] locationInView:[CCDirector sharedDirector].view];
        pos = [[CCDirector sharedDirector] convertToGL:pos];
        sum = ccpAdd(sum, pos);
    }
    return(ccpMult(sum, 1.0f / (float)_touchCount));
}

// calculates the average distance of oll touches from touch centre
- (float)distance:(CGPoint)centre
{
    float sum = 0;
    for (int index = 0; index < _touchCount; index ++)
    {
        CGPoint pos = [_touch[index] locationInView:[CCDirector sharedDirector].view];
        pos = [[CCDirector sharedDirector] convertToGL:pos];
        sum = sum + ccpDistance(centre, pos);
    }
    return(sum / (float)_touchCount);
}

// calculates the average rotation of all touches, relative to touch centre
- (float)rotation:(CGPoint)centre
{
    float sum = 0;
    for (int index = 0; index < _touchCount; index ++)
    {
        CGPoint pos = [_touch[index] locationInView:[CCDirector sharedDirector].view];
        pos = [[CCDirector sharedDirector] convertToGL:pos];
        sum = sum + ccpToAngle(ccpSub(pos, centre));
    }
    return(sum / (float)_touchCount);
}

//----------------------------------------------------------------------

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // if max touches exceeded, drop the touch
    if (_touchCount == CCSpriteMultiTouchMaxTouches)
    {
        [super touchBegan:touch withEvent:event];
        return;
    }
    
    // add the touch to the list
    _touch[_touchCount] = touch;
    _touchCount ++;
    CCLOG(@"touches : %d", (int)_touchCount);
    
    // check if drag function activates
    if (_touchCount == _touchCountForDrag) _dragCentre = [self centre];
    
    // check for scale function
    if (_touchCount == _touchCountForScale)
    {
        _scaleCentre = [self centre];
        _scaleStartDistance = [self distance:_scaleCentre];
        _scaleStartScale = self.scale;
    }
    
    // check for rotate function
    if (_touchCount == _touchCountForRotate)
    {
        _rotationCentre = [self centre];
        _rotationLast = [self rotation:_rotationCentre];
    }
}

//----------------------------------------------------------------------

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    // check for dragging
    if (_touchCount == _touchCountForDrag) [self touchDrag];
    
    // check for scaling
    if (_touchCount == _touchCountForScale) [self touchScale];
    
    // check for rotation
    if (_touchCount == _touchCountForRotate) [self touchRotate];
}

//----------------------------------------------------------------------

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    // remove the touch from the list
    for (int index = 0; index < _touchCount; index ++)
    {
        if (_touch[index] == touch)
        {
            _touch[index] = _touch[_touchCount - 1];
            _touchCount --;
            return;
        }
    }
}

//----------------------------------------------------------------------

- (void)touchDrag
{
    // OBS !!
    // dragging (for now) only supports defualt positioning
    CGPoint pos = [self centre];
    CGPoint movement = ccpSub(pos, _dragCentre);
    self.position = ccpAdd(self.position, movement);
    _dragCentre = pos;
}

//----------------------------------------------------------------------

- (void)touchScale
{
    _scaleCentre = [self centre];
    float distance = [self distance:_scaleCentre];
    self.scale = _scaleStartScale * (distance / _scaleStartDistance);
}

//----------------------------------------------------------------------

- (void)touchRotate
{
    _rotationCentre = [self centre];
    float rotation = [self rotation:_rotationCentre];
    float delta = rotation - _rotationLast;
    _rotationLast = rotation;
    // make sure the rotation is smooth
    if (delta < -M_PI_2) delta = M_PI + delta;
    if (delta > M_PI_2) delta = M_PI - delta;
    self.rotation = self.rotation - (180.0f / M_PI * delta);
}

//----------------------------------------------------------------------

@end
