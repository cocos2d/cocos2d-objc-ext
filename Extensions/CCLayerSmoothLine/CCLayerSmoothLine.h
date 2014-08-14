/*
 * Smooth drawing: http://merowing.info
 *
 * Copyright (c) 2012 Krzysztof Zabłocki
 * Copyright (c) 2014 Richard Groves
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
 *
 */

#import "cocos2d.h"

typedef struct
{
    CGPoint pos;
    float z;
    ccColor4F color;
} CCSmoothLineVertex;

// -----------------------------------------------------------------------

@interface CCSmoothLinePoint : NSObject

@property(nonatomic, assign) CGPoint pos;
@property(nonatomic, assign) float width;

@end

// -----------------------------------------------------------------------

@interface CCLayerSmoothLine : CCNode

// -----------------------------------------------------------------------

+ (instancetype)layer;
- (instancetype)init;

- (void)startNewLineFrom:(CGPoint)newPoint withSize:(CGFloat)aSize;
- (void)endLineAt:(CGPoint)aEndPoint withSize:(CGFloat)aSize;
- (void)addPoint:(CGPoint)newPoint withSize:(CGFloat)size;

// -----------------------------------------------------------------------

@end