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

#import <Foundation/Foundation.h>
#import "CCSpineTexture.h"

// ----------------------------------------------------------------------------------------------

@interface CCSpineSkin : NSObject

// ----------------------------------------------------------------------------------------------

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSDictionary *spriteList;

// ----------------------------------------------------------------------------------------------

+ (instancetype)skinWithDictionary:(NSDictionary *)dict andName:(NSString *)name;
- (instancetype)initWithDictionary:(NSDictionary *)dict andName:(NSString *)name;

- (int)getTextureTag:(NSString *)textureName spriteName:(NSString *)spriteName;
- (CCSpineTexture *)getSpineTexture:(NSString *)textureName spriteName:(NSString *)spriteName;

// ----------------------------------------------------------------------------------------------

@end













































