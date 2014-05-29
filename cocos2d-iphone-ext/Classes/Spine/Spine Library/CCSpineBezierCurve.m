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

#import "CCSpineBezierCurve.h"

// ----------------------------------------------------------------------------------------------

@implementation CCSpineBezierCurve
{
    CCSpineInterpolation                    _interpolation;
    NSInteger                               _count;
    CGPoint*                                _bezier;
}

// ----------------------------------------------------------------------------------------------

+ (instancetype)bezierCurveWithDictionary:(NSDictionary *)dict
{
    return([[CCSpineBezierCurve alloc] initWithDictionary:dict]);
}

// ----------------------------------------------------------------------------------------------

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self                        = [super init];
    // load curve from dictionary
    
    // default type is linear
    _interpolation              = CCSpineInterpolationLinear;
    _count                      = 0;
    _bezier                     = NULL;
    // load values from dictionary
    id object                   = [dict objectForKey:@"curve"];
    if ([object isKindOfClass:[NSString class]])
    {
        // curve defined as a string
        // only value accepted for now is "stepped"
        NSString* curve = object;
        if ([curve isEqualToString:@"stepped"])
        {
            _interpolation      = CCSpineInterpolationStepped;
        }
        else
        {
            NSAssert(NO, @"[spineAnimationCurve initWithDictionary] Unknown interpolation : %@", object);
        }
    }
    else if ([object isKindOfClass:[NSArray class]])
    {
        // curve defined as an array
        // this must be an array of floats
        // add 0 at the begining and 1 at the end, to make later interpolation easier
        NSArray* array          = object;
        if (array.count > 0)
        {
            _interpolation      = CCSpineInterpolationBezier;
            _count              = array.count;
            _bezier             = malloc(sizeof(CGPoint) * _count / 2);
            int index           = 0;
            for (NSNumber* value in array)
            {
                // read alternating values as x, y
                if ((index & 1) == 0) _bezier[index / 2].x = [value floatValue]; else _bezier[index / 2].y = [value floatValue];
                index ++;
            }
        }
    }
    
    // done
    return(self);
}

// ----------------------------------------------------------------------------------------------

- (void)dealloc
{
    // clean up
    if (_bezier != NULL) free(_bezier);
    
}

// ----------------------------------------------------------------------------------------------

- (float)translate:(float)value
{
    // translate a normalized value
    switch (_interpolation)
    {
        case CCSpineInterpolationLinear:            return(value);
        case CCSpineInterpolationStepped:           return(0);
        case CCSpineInterpolationBezier:
            
            // TODO
            // convert according to bezier curve
            return(value);
            
    }
    NSAssert(NO, @"[CCSpineBezierCurve translate] Invalid interpolation");
    return(0);
}

// ----------------------------------------------------------------------------------------------

@end








































