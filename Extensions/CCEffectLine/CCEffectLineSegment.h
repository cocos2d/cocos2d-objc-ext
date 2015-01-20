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

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// -----------------------------------------------------------------------

@interface NSValue(CCEffectLineSegment)

- (GLKVector4)GLKVector4Value;

@end

// -----------------------------------------------------------------------
// Holding a single line point
// - 2 points created from a point, a direction and a width

@interface CCEffectLineSegment : NSObject

// -----------------------------------------------------------------------

@property (nonatomic, readonly) float life;
@property (nonatomic, readonly) float age;
@property (nonatomic, readonly) float progress;
@property (nonatomic, readonly) BOOL expired;
@property (nonatomic, readonly) CGPoint position;
@property (nonatomic, readonly) CGPoint posA;
@property (nonatomic, readonly) CGPoint posB;
@property (nonatomic, readonly) float widthStart;
@property (nonatomic, readonly) float widthEnd;
@property (nonatomic, readonly) GLKVector4 color;
@property (nonatomic, readonly) GLKVector4 colorStart;
@property (nonatomic, readonly) GLKVector4 colorEnd;

@property (nonatomic, assign) float textureOffset;
@property (nonatomic, assign) CGPoint direction;
@property (nonatomic, assign) float width;
@property (nonatomic, assign) BOOL hasChanged;
@property (nonatomic, assign) CGPoint wind;
@property (nonatomic, assign) CGPoint gravity;

// -----------------------------------------------------------------------

+ (instancetype)segmentWithDictionary:(NSDictionary *)settings;
- (instancetype)initWithDictionary:(NSDictionary *)settings;

- (void)setPosA:(CGPoint)pos;
- (void)setPosB:(CGPoint)pos;

- (void)update:(CCTime)delta;

// -----------------------------------------------------------------------

@end




































