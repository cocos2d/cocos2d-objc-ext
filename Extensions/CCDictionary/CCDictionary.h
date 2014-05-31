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
#import "cocos2d.h"

//----------------------------------------------------------------------

extern const int CCDictionaryInvalidIndex;
extern const NSString *CCDictionaryNameKey;

//----------------------------------------------------------------------

@interface NSDictionary (CCDictionary)

//----------------------------------------------------------------------

+ (instancetype)dictionaryWithPlist:(NSString *)filename;
+ (instancetype)dictionaryWithPlist:(NSString *)filename key:(NSString *)key;
+ (instancetype)dictionaryWithDictionary:(NSDictionary *)dict;
+ (instancetype)dictionaryWithDictionary:(NSDictionary *)dict key:(NSString *)key;

- (instancetype)initWithPlist:(NSString *)filename key:(NSString *)key;
- (instancetype)initWithDictionary:(NSDictionary *)dict key:(NSString *)key;
- (instancetype)subDictionary:(NSString *)key;

- (id)readObject:(NSString *)key def:(id)def;
- (int)readInteger:(NSString *)key def:(int)def;
- (float)readFloat:(NSString *)key def:(float)def;
- (CGPoint)readPoint:(NSString *)key def:(CGPoint)def;
- (CGSize)readSize:(NSString *)key def:(CGSize)def;
- (NSString *)readString:(NSString *)key def:(NSString *)def;
- (CCColor *)readColor:(NSString *)key def:(CCColor *)def;
- (NSArray *)readArray:(NSString *)key def:(NSArray *)def;

- (id)readObject:(NSString *)key index:(int)index def:(id)def;
- (int)readInteger:(NSString *)key index:(int)index def:(int)def;
- (float)readFloat:(NSString *)key index:(int)index def:(float)def;
- (CGPoint)readPoint:(NSString *)key index:(int)index def:(CGPoint)def;
- (CGSize)readSize:(NSString *)key index:(int)index def:(CGSize)def;
- (NSString *)readString:(NSString *)key index:(int)index def:(NSString *)def;
- (CCColor *)readColor:(NSString *)key index:(int)index def:(CCColor *)def;
- (NSArray *)readArray:(NSString *)key index:(int)index def:(NSArray *)def;

- (NSString *)readName;

//----------------------------------------------------------------------

@end


































