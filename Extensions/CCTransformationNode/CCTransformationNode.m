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

#import "CCTransformationNode.h"

//----------------------------------------------------------------------

#define FAR_PLANE           1000.0f
#define NEAR_PLANE          0.5f


//----------------------------------------------------------------------

@implementation CCTransformationNode
{
    GLKMatrix4 _transformation;
    GLKMatrix4 _finalTransformation;
    BOOL _dirty;
}

//----------------------------------------------------------------------

- (instancetype)init
{
    self = [super init];
    // initialize
    _roll = 0.0f;
    _pitch = 0.0f;
    _yaw = 0.0f;
    _perspective = 1.0;
    _dirty = YES;
    // done
    return(self);
}

//----------------------------------------------------------------------

- (void)visit:(CCRenderer *)renderer parentTransform:(const GLKMatrix4 *)parentTransform
{
    if (!_visible) return;

    if (_dirty)
    {
        CGSize size = [CCDirector sharedDirector].viewSize;
        // float aspect = size.width / size.height;

        // create rotation matrix
        GLKMatrix4 matrixPitch = GLKMatrix4MakeXRotation(_pitch);
        GLKMatrix4 matrixRoll = GLKMatrix4MakeYRotation(_roll);
        GLKMatrix4 matrixYaw = GLKMatrix4MakeZRotation(_yaw);
        
        // create translation matrix
        CGPoint pos = [self positionInPoints];
        pos = ccp((2 * pos.x / size.width) - 1.0, (2 * pos.y / size.height) - 1.0);
        GLKMatrix4 matrixTranslate = GLKMatrix4MakeTranslation(pos.x, pos.y, 0);
        
        // greate perspective matrix
        GLKMatrix4 perspective = GLKMatrix4Make(
                                                1.0, 0.0, 0.0, 0.0,
                                                0.0, 1.0, 0.0, 0.0,
                                                0.0, 0.0, 0.0, _perspective,
                                                0.0, 0.0, 0.0, 1.0
                                                );

        // calculate combined rotation
        GLKMatrix4 rotation = GLKMatrix4Multiply(matrixRoll, matrixPitch);
        
        // adjust perspective for yaw and translation
        perspective = GLKMatrix4Multiply(matrixYaw, perspective);
        perspective = GLKMatrix4Multiply(matrixTranslate, perspective);
        
        // create final rotation + perspective martix
        _transformation = GLKMatrix4Multiply(perspective, rotation);
        
        // transformation is up to date
        _dirty = NO;
    }

    // calculate final transformation (used for backface calculation)
    _finalTransformation = GLKMatrix4Multiply(_transformation, *parentTransform);
    
    // create basic transformation matrix
    // position is not used
    CGAffineTransform t = [self nodeToParentTransform];
    t.tx = [CCDirector sharedDirector].viewSize.width / 2;
    t.ty = [CCDirector sharedDirector].viewSize.height / 2;
    
    // Convert to 4x4 column major GLK matrix.
    _finalTransformation = GLKMatrix4Multiply(_finalTransformation,
                                              GLKMatrix4Make(
                                                             t.a,  t.b, 0.0f, 0.0f,
                                                             t.c,  t.d, 0.0f, 0.0f,
                                                             0.0f, 0.0f, 1.0f, 0.0f,
                                                             t.tx, t.ty, _vertexZ, 1.0f
                                                             ));
    
    // draw self and children
    BOOL drawn = NO;
    
    for (CCNode *child in _children)
    {
        if (!drawn && (child.zOrder >= 0))
        {
            [self draw:renderer transform:&_finalTransformation];
            drawn = YES;
        }
        [child visit:renderer parentTransform:&_finalTransformation];
    }
    
    if (!drawn) [self draw:renderer transform:&_finalTransformation];
    
    // reset for next frame
    _orderOfArrival = 0;
}

//----------------------------------------------------------------------

- (BOOL)isBackFacing
{
    return(_finalTransformation.m23 > 0);
}

//----------------------------------------------------------------------

- (void)setRoll:(float)roll
{
    _dirty = YES;
    _roll = roll;
}

- (void)setPitch:(float)pitch
{
    _dirty = YES;
    _pitch = pitch;
}

- (void)setYaw:(float)yaw
{
    _dirty = YES;
    _yaw = yaw;
}

//----------------------------------------------------------------------

@end




