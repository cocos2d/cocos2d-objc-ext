/*
 * cocos2d for iPhone: http://www.cocos2d-swift.org
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

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// -----------------------------------------------------------------------

@interface rippleNode : CCNode

// -----------------------------------------------------------------------

@property (nonatomic, assign) float life;                       // total life span
@property (nonatomic, assign) float normalizedSpeed;            // normalized speed compared to parent width
@property (nonatomic, assign) float ripples;                    // number of ripples
@property (nonatomic, assign) float periodTime;                 // ripple period time
@property (nonatomic, assign) float normalizedRippleStrength;   // normalized strength of ripple
@property (nonatomic, assign) BOOL modifyEdges;                 // modify image edges
@property (nonatomic, assign) BOOL modifyTexture;               // modify texture in stead of vertex

@property (nonatomic, readonly) CGPoint centre;                 // centre of ripple
@property (nonatomic, readonly) float size;                     // current size
@property (nonatomic, readonly) float age;                      // current age

// -----------------------------------------------------------------------

+ (instancetype)rippleNodeAt:(CGPoint)pos;

// -----------------------------------------------------------------------

@end
