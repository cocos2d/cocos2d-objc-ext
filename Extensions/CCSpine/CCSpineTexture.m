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

#import "CCSpineTexture.h"
#import "CCDictionary.h"

// ----------------------------------------------------------------------------------------------

const int CCSpineTextureAutoTag = 5000;
const int CCSpineTextureInvalidTag = -1;

// ----------------------------------------------------------------------------------------------

@implementation CCSpineTextureFrame
{
    float _time;
    NSString *_name;
    int _tag;
}

// ----------------------------------------------------------------------------------------------

+ (instancetype)textureFrameWithDictionary:(NSDictionary *)dict
{
    return([[CCSpineTextureFrame alloc] initDictionary:dict]);
}

- (instancetype)initDictionary:(NSDictionary *)dict
{
    self = [super init];
    // load from dict
    _time = [dict readFloat:@"time" def:0];
    _name = [[dict readString:@"name" def:nil] lastPathComponent];
    _tag = CCSpineTextureInvalidTag;
    // done
    return(self);
}

@end

// ----------------------------------------------------------------------------------------------

@implementation CCSpineTexture
{
    NSString *_attachment;
    NSString *_name;
    CGPoint _position;
    CGSize _size;
    float _rotation;
}

// ----------------------------------------------------------------------------------------------

static int g_spriteTag = CCSpineTextureAutoTag;

// ----------------------------------------------------------------------------------------------

+ (instancetype)spriteWithDictionary:(NSDictionary *)dict attachment:(NSString *)attachment
{
    return([[CCSpineTexture alloc] initWithDictionary:dict attachment:attachment]);
}

// ----------------------------------------------------------------------------------------------

- (instancetype)initWithDictionary:(NSDictionary *)dict attachment:(NSString *)attachment
{
    self = [super init];
    
    // load data from dictionary
    
    _attachment = [[NSString stringWithString:attachment] lastPathComponent];
    _name = [dict readString:@"name" def:nil];
    if (_name != nil)
        _name = [_name lastPathComponent];
    else
        _name = [_attachment lastPathComponent];
    _position.x = [dict readFloat:@"x" def:0];
    _position.y = [dict readFloat:@"y" def:0];
    _size.width = [dict readFloat:@"width" def:0];
    _size.height = [dict readFloat:@"height" def:0];
    _scale.x = [dict readFloat:@"scaleX" def:1];
    _scale.y = [dict readFloat:@"scaleY" def:1];
    _rotation = [dict readFloat:@"rotation" def:0];
    _tag = g_spriteTag ++;
    _frame = nil;
    
    // done
    return (self);
}


// ----------------------------------------------------------------------------------------------

- (void)assignNewTag:(int)tag
{
    _tag = tag;
}

// ----------------------------------------------------------------------------------------------

@end













































