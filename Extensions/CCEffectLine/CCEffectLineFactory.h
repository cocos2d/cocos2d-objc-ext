/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2012-2014 Lars Birkemose
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

// Note!
// The CCEffectLineFactory is a helper class, mainly intended for template usage

// Default "effects.png" textures are
// 0 : Dark trail 0
// 1 : Dark smoke trail 1
// 2 : Simple (slightly blurred) line
// 3 : Smoke dragon
// 4 : Electricity
// 5 : White smoke trail 0
// 6 : White smoke trail 1
// 7 : Thin smoke

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// -----------------------------------------------------------------------

@interface CCEffectLineFactory : NSObject

// -----------------------------------------------------------------------

@property (nonatomic, readonly) NSUInteger count;

- (NSDictionary *)lineFromIndex:(NSUInteger)index;
- (NSDictionary *)lineFromName:(NSString *)name;

- (NSString *)nameFromIndex:(NSUInteger)index;

// -----------------------------------------------------------------------

@end
