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
    _perspective = 1.0;
    _dirty = YES;
    // done
    return(self);
}

//----------------------------------------------------------------------

- (void)visit:(CCRenderer *)renderer parentTransform:(const GLKMatrix4 *)parentTransform
{
    if (_dirty)
    {
       
        // create rotation matrix
        GLKMatrix4 matrixPitch = GLKMatrix4MakeXRotation(_pitch);
        GLKMatrix4 matrixRoll = GLKMatrix4MakeYRotation(_roll);
        _transformation = GLKMatrix4Multiply(matrixRoll, matrixPitch);

        // apple perspective
        _transformation.m03 = _perspective * sinf(_roll) * cosf(_pitch);
        _transformation.m13 = _perspective * sinf(_pitch) * cosf(_roll);
        
        // transformation is up to date
        _dirty = NO;
    }

    // calculate final transformation (used for backface calculation)
    _finalTransformation = GLKMatrix4Multiply(_transformation, *parentTransform);
    
    [super visit:renderer parentTransform:&_finalTransformation];
}

//----------------------------------------------------------------------

- (BOOL)isBackFacing
{
    // this can not be calculated uder _dirty, as parent transform might change
    GLKVector3 vector = (GLKVector3){0,0,1};
    vector = GLKMatrix4MultiplyVector3 (_finalTransformation, vector);
    return(vector.z > 0);
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

//----------------------------------------------------------------------

@end




