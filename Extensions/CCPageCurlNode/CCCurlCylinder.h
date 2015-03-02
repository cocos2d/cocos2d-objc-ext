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

#import <Foundation/Foundation.h>
#import "cocos2d.h"

/*
 CCCurlCylinder is a helper class, encapsuling a cylinder to curl around
 The coordinate system the cylinder operates in, is 0,0,size.width,size.height
 All coordinates should be supplied in node space
 The cylinder has a side, where curl will be reduces to simulate the page being anchored
*/

typedef NS_ENUM(NSUInteger, CCPageAnchor)
{
    CCPageAnchorLeft,
    CCPageAnchorTop,
    CCPageAnchorRight,
    CCPageAnchorBottom,
};

typedef struct
{
    CGSize size;
    CCPageAnchor anchor;
} CCPageDefinition;

// -----------------------------------------------------------------------

@interface CCCurlCylinder : NSObject

// -----------------------------------------------------------------------

@property (nonatomic, readonly) float diameter;
@property (nonatomic, readonly) CCPageDefinition pageDefinition;
@property (nonatomic, readonly) BOOL active;
@property (nonatomic, readonly) CGPoint startPosition;
@property (nonatomic, readonly) CGPoint position;

@property (nonatomic, readonly) CGPoint endPositionA;
@property (nonatomic, readonly) CGPoint endPositionB;
@property (nonatomic, readonly) float radiusA;
@property (nonatomic, readonly) float radiusB;
@property (nonatomic, readonly) CGPoint anchorPosition;
@property (nonatomic, readonly) CGPoint anchorVector;
@property (nonatomic, readonly) CGPoint pageVector;

// -----------------------------------------------------------------------

+ (instancetype)cylinderWithDiameter:(float)diameter pageDefinition:(CCPageDefinition)pageDefinition;
- (instancetype)initWithDiameter:(float)diameter pageDefinition:(CCPageDefinition)pageDefinition;

- (BOOL)begin:(CGPoint)pos;
- (void)update:(CGPoint)pos;
- (void)end:(CGPoint)pos;

- (BOOL)curl:(GLKVector4 *)pos;

// -----------------------------------------------------------------------

@end





















