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

#import "CCSpineBone.h"
#import "CCDictionary.h"

// ----------------------------------------------------------------------------------------------

@implementation CCSpineBone
{
    float _length;
    CCSpineBoneData _pose;                                                                      // default pose position
    CCSpineBoneData _work;                                                                      // accumulating position
    CCSpineBoneData _current;                                                                   // current position
}

// ----------------------------------------------------------------------------------------------

+ (instancetype)boneWithDictionary:(NSDictionary *)dict
{
    return([[CCSpineBone alloc] initWithDictionary:dict]);
}

// ----------------------------------------------------------------------------------------------

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // create lists
    
    // initialize bone by reading dictionary
    
    _name = [dict readString:@"name" def:@"noname"];
    _parentName = [dict readString:@"parent" def:nil];
    
    // TODO _parentBone must be resolved later, when all bones have been loaded
    _parentBone = nil;
    _length = [dict readFloat:@"length" def:0];
    _pose.position.x = [dict readFloat:@"x" def:0];
    _pose.position.y = [dict readFloat:@"y" def:0];
    _pose.rotation = [dict readFloat:@"rotation" def:0];
    _pose.scale.x = [dict readFloat:@"scaleX" def:1];
    _pose.scale.y = [dict readFloat:@"scaleY" def:1];
    
    // reset transformationdata
    _m00 = _m01 = 0;
    _m10 = _m11 = 0;
    _position = CGPointZero;
    _rotation = 0;
    _scale = CGPointZero;

    // reset current position
    [self pose];
    
    // done
    return(self);
}

// ----------------------------------------------------------------------------------------------

- (void)pose
{
    _current = _pose;
    _work = _pose;
}

// ----------------------------------------------------------------------------------------------
// accumulates movements with strength

- (void)addAnimation:(CCSpineBoneData)animation
{
    _work.position = ccpAdd(_work.position, animation.position);
    _work.rotation = _work.rotation + animation.rotation;
    // _work.scale = _work.scale; // ccpCompMult(_work.scale, animation.scale);
    _work.scale = animation.scale;
}

// ----------------------------------------------------------------------------------------------

- (void)forceAnimation:(CCSpineBoneData)animation
{
    _work.position = animation.position;
    _work.rotation = animation.rotation;
    _work.scale = animation.scale;
}

// ----------------------------------------------------------------------------------------------

- (void)updateWorldTransform
{
	float radians, cosine, sine;
    
    _current = _work;
    
	if (_parentBone != nil)
    {
		_position = ccp(_current.position.x * _parentBone.m00 + _current.position.y * _parentBone.m01 + _parentBone.position.x,
                        _current.position.x * _parentBone.m10 + _current.position.y * _parentBone.m11 + _parentBone.position.y);
		_scale = ccpCompMult(_parentBone.scale, _current.scale);
		_rotation = _parentBone.rotation + _current.rotation;
	}
    else
    {
		_position = ccp(_current.position.x, _current.position.y);
		_scale = _current.scale;
		_rotation = _current.rotation;
	}
    
	radians = _rotation * M_PI / 180;

	cosine = cosf(radians);
	sine = sinf(radians);

	_m00 = cosine * _scale.x;
	_m10 = sine * _scale.x;
	_m01 = -sine * _scale.y;
	_m11 = cosine * _scale.y;
    
    // reset work to pose, to allow for accumulated movements 
    _work = _pose;
}

// ----------------------------------------------------------------------------------------------
// properties
// - data ---------------------------------------------------------------------------------------

- (CCSpineBoneData)data
{
    return(_current);
}

// - vector -------------------------------------------------------------------------------------

- (CGPoint)vector
{
    return(ccp(_length * _m00, _length * _m10));
}

// ----------------------------------------------------------------------------------------------

@end









































