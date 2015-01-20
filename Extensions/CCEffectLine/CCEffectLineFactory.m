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

#import "CCEffectLineFactory.h"
#import "CCEffectLine.h"

// -----------------------------------------------------------------------

@implementation CCEffectLineFactory
{
    NSMutableArray *_lines;
}

// -----------------------------------------------------------------------

- (instancetype)init
{
    self = [super init];
    
    _lines = [NSMutableArray array];

    [_lines addObject:
     @{
       // basic setups
       @"name"               : @"Simple Line",
       @"image"              : @"effects.png",
       @"lineMode"           : @(CCEffectLineModePointToPoint),
       @"widthMode"          : @(CCEffectLineWidthSimple),
       @"width"              : @(10.0),
       // textures used
       @"textureCount"       : @(8),
       @"textureIndex"       : @(2),
       @"textureList"        : @[],
       @"textureMix"         : @(CCEffectLineTextureSimple),
       @"textureAnimation"   : @(CCEffectLineAnimationNone),
       @"textureScroll"      : @(0.00f),
       @"textureMixTime"     : @(1.00f),
       @"textureScale"       : @(1.0),
       // texture mixing
       @"life"               : @(1.0f),
       @"autoRemove"         : @(YES),
       @"smooth"             : @(YES),
       @"speedMultiplyer"    : @(0.40f),
       @"granularity"        : @(1.0f),
       @"drawLineStart"      : @(YES),
       @"drawLineEnd"        : @(YES),
       @"wind"               : @"{0, 0}",
       @"gravity"            : @"{0, 0}",
       @"colorStart"         : @"{0.3, 1.0, 0.3, 1.0}",
       @"colorEnd"           : @"{0.0, 0.5, 0.0, 0.0}",
       }];
    
    [_lines addObject:
     @{
       // basic setups
       @"name"               : @"Free Hand Drawing",
       @"image"              : @"effects.png",
       @"lineMode"           : @(CCEffectLineModePointToPoint),
       @"widthMode"          : @(CCEffectLineWidthSpeed),
       @"widthStart"         : @(2.0),
       @"widthEnd"           : @(50.0),
       // textures used
       @"textureCount"       : @(8),
       @"textureIndex"       : @(2),
       @"textureList"        : @[],
       @"textureMix"         : @(CCEffectLineTextureSimple),
       @"textureAnimation"   : @(CCEffectLineAnimationNone),
       @"textureScroll"      : @(0.00f),
       @"textureMixTime"     : @(1.00f),
       @"textureScale"       : @(1.0),
       // texture mixing
       @"life"               : @(1.0f),
       @"autoRemove"         : @(YES),
       @"smooth"             : @(YES),
       @"speedMultiplyer"    : @(0.40f),
       @"granularity"        : @(1.0f),
       @"drawLineStart"      : @(YES),
       @"drawLineEnd"        : @(YES),
       @"wind"               : @"{0, 0}",
       @"gravity"            : @"{0, 0}",
       @"colorStart"         : @"{1.0, 1.0, 0.3, 1.0}",
       @"colorEnd"           : @"{0.5, 0.5, 0.0, 0.0}",
       }];
    
    [_lines addObject:
     @{
       // basic setups
       @"name"               : @"Vertical Smoke",
       @"image"              : @"effects.png",
       @"lineMode"           : @(CCEffectLineModePointToPoint),
       @"widthMode"          : @(CCEffectLineWidthSimple),
       @"widthStart"         : @(50.0),
       @"widthEnd"           : @(200.0),
       // textures used
       @"textureCount"       : @(8),
       @"textureIndex"       : @(7),
       @"textureList"        : @[],
       @"textureMix"         : @(CCEffectLineTextureSimple),
       @"textureAnimation"   : @(CCEffectLineAnimationScroll),
       @"textureScroll"      : @(0.030f),
       @"textureMixTime"     : @(0.50f),
       @"textureScale"       : @(1.25),
       // texture mixing
       @"life"               : @(3.00f),
       @"autoRemove"         : @(YES),
       @"smooth"             : @(YES),
       @"speedMultiplyer"    : @(1.00f),
       @"granularity"        : @(1.0f),
       @"drawLineStart"      : @(YES),
       @"drawLineEnd"        : @(YES),
       @"wind"               : @"{0, 0}",
       @"gravity"            : @"{0, 0}",
       @"colorStart"         : @"{1.0, 1.0, 1.0, 1.0}",
       @"colorEnd"           : @"{0.5, 0.5, 0.5, 0.0}",
       }];

    [_lines addObject:
     @{
       // basic setups
       @"name"               : @"Horizontal Fog",
       @"extra"              : @"Vertical Smoke",
       @"image"              : @"effects.png",
       @"lineMode"           : @(CCEffectLineModePointToPoint),
       @"widthMode"          : @(CCEffectLineWidthSimple),
       @"widthStart"         : @(50.0),
       @"widthEnd"           : @(200.0),
       // textures used
       @"textureCount"       : @(8),
       @"textureIndex"       : @(7),
       @"textureList"        : @[],
       @"textureMix"         : @(CCEffectLineTextureSimple),
       @"textureAnimation"   : @(CCEffectLineAnimationScroll),
       @"textureScroll"      : @(-0.015f),
       @"textureMixTime"     : @(0.50f),
       @"textureScale"       : @(1.25),
       // texture mixing
       @"life"               : @(3.00f),
       @"autoRemove"         : @(YES),
       @"smooth"             : @(YES),
       @"speedMultiplyer"    : @(1.00f),
       @"granularity"        : @(1.0f),
       @"drawLineStart"      : @(YES),
       @"drawLineEnd"        : @(YES),
       @"wind"               : @"{0, 0}",
       @"gravity"            : @"{0, 0}",
       @"colorStart"         : @"{1.0, 1.0, 1.0, 1.0}",
       @"colorEnd"           : @"{0.5, 0.5, 0.5, 0.0}",
       }];
    
    [_lines addObject:
     @{
       // basic setups
       @"name"               : @"Sword Effect",
       @"image"              : @"effects.png",
       @"lineMode"           : @(CCEffectLineModeFreeHand),
       @"widthMode"          : @(CCEffectLineWidthSimple),
       @"width"              : @(200.0),
       // textures used
       @"textureCount"       : @(8),
       @"textureIndex"       : @(2),
       @"textureList"        : @[],
       @"textureMix"         : @(CCEffectLineTextureSimple),
       @"textureAnimation"   : @(CCEffectLineAnimationNone),
       @"textureScroll"      : @(0.00f),
       @"textureMixTime"     : @(3.00f),
       @"textureScale"       : @(1.00),
       // texture mixing
       @"locked"             : @(YES),
       @"life"               : @(0.15f),
       @"autoRemove"         : @(YES),
       @"smooth"             : @(YES),
       @"speedMultiplyer"    : @(1.00f),
       @"granularity"        : @(1.50f),
       @"drawLineStart"      : @(YES),
       @"drawLineEnd"        : @(NO),
       @"wind"               : @"{0, 0}",
       @"gravity"            : @"{0, 0}",
       @"colorStart"         : @"{1.0, 1.0, 1.0, 0.8}",
       @"colorEnd"           : @"{1.0, 1.0, 1.0, 0.0}",
       }];

    [_lines addObject:
     @{
       // basic setups
       @"name"               : @"Bullet Tracer",
       @"image"              : @"effects.png",
       @"lineMode"           : @(CCEffectLineModePointToPoint),
       @"widthMode"          : @(CCEffectLineWidthSimple),
       @"widthStart"         : @(30.0),
       @"widthEnd"           : @(50.0),
       // textures used
       @"textureCount"       : @(8),
       @"textureIndex"       : @(0),
       @"textureList"        : @[@(0), @(1)],
       @"textureMix"         : @(CCEffectLineTextureBlendLinear),
       @"textureAnimation"   : @(CCEffectLineAnimationScroll),
       @"textureScroll"      : @(0.00f),
       @"textureMixTime"     : @(0.50f),
       @"textureScale"       : @(0.50),
       // texture mixing
       @"life"               : @(1.00f),
       @"autoRemove"         : @(YES),
       @"smooth"             : @(YES),
       @"speedMultiplyer"    : @(1.00f),
       @"granularity"        : @(1.0f),
       @"drawLineStart"      : @(YES),
       @"drawLineEnd"        : @(YES),
       @"wind"               : @"{0, 0}",
       @"gravity"            : @"{0, 0}",
       @"colorStart"         : @"{1.0, 1.0, 1.0, 1.0}",
       @"colorEnd"           : @"{0.5, 0.5, 0.5, 0.0}",
       }];
    
    [_lines addObject:
     @{
       // basic setups
       @"name"               : @"Rocket Smoke Trail",
       @"image"              : @"effects.png",
       @"lineMode"           : @(CCEffectLineModeFreeHand),
       @"widthMode"          : @(CCEffectLineWidthBarrel),
       @"widthStart"         : @(20.0),
       @"widthEnd"           : @(100.0),
       // textures used
       @"textureCount"       : @(8),
       @"textureIndex"       : @(0),
       @"textureList"        : @[@(5), @(6)],
       @"textureMix"         : @(CCEffectLineTextureBlendLinear),
       @"textureAnimation"   : @(CCEffectLineAnimationScroll),
       @"textureScroll"      : @(-0.05f),
       @"textureMixTime"     : @(3.00f),
       @"textureScale"       : @(0.50),
       // texture mixing
       @"life"               : @(3.00f),
       @"autoRemove"         : @(YES),
       @"smooth"             : @(YES),
       @"speedMultiplyer"    : @(1.00f),
       @"granularity"        : @(0.25f),
       @"drawLineStart"      : @(YES),
       @"drawLineEnd"        : @(YES),
       @"wind"               : @"{0, 0}",
       @"gravity"            : @"{0, 0}",
       @"colorStart"         : @"{1.0, 1.0, 1.0, 1.0}",
       @"colorEnd"           : @"{1.0, 1.0, 1.0, 0.0}",
       }];
    
    [_lines addObject:
     @{
       // basic setups
       @"name"               : @"Electricity",
       @"image"              : @"effects.png",
       @"lineMode"           : @(CCEffectLineModeStraight),
       @"widthMode"          : @(CCEffectLineWidthBarrel),
       @"widthStart"         : @(10.0),
       @"widthEnd"           : @(150),
       // textures used
       @"textureCount"       : @(8),
       @"textureIndex"       : @(4),
       @"textureList"        : @[],
       @"textureMix"         : @(CCEffectLineTextureSimple),
       @"textureAnimation"   : @(CCEffectLineAnimationRandom),
       @"textureScroll"      : @(0.00f),
       @"textureMixTime"     : @(1.00f),
       @"textureScale"       : @(0.75),
       // texture mixing
       @"locked"             : @(YES),
       @"life"               : @(0.05f),
       @"autoRemove"         : @(YES),
       @"smooth"             : @(YES),
       @"speedMultiplyer"    : @(0.40f),
       @"granularity"        : @(1.0f),
       @"drawLineStart"      : @(YES),
       @"drawLineEnd"        : @(YES),
       @"wind"               : @"{0, 0}",
       @"gravity"            : @"{0, 0}",
       @"colorStart"         : @"{1.0, 1.0, 1.0, 1.0}",
       @"colorEnd"           : @"{1.0, 0.0, 0.0, 0.0}",
       }];
    
    [_lines addObject:
     @{
       // basic setups
       @"name"               : @"Smoke Dragon",
       @"image"              : @"effects.png",
       @"lineMode"           : @(CCEffectLineModePointToPoint),
       @"widthMode"          : @(CCEffectLineWidthSimple),
       @"widthStart"         : @(100.0),
       @"widthEnd"           : @(200.0),
       // textures used
       @"textureCount"       : @(8),
       @"textureIndex"       : @(3),
       @"textureList"        : @[],
       @"textureMix"         : @(CCEffectLineTextureSimple),
       @"textureAnimation"   : @(CCEffectLineAnimationClamped),
       @"textureScroll"      : @(0.00f),
       @"textureMixTime"     : @(1.00f),
       @"textureScale"       : @(1.0),
       // texture mixing
       @"life"               : @(2.0f),
       @"autoRemove"         : @(YES),
       @"smooth"             : @(YES),
       @"speedMultiplyer"    : @(1.0f),
       @"granularity"        : @(1.0f),
       @"drawLineStart"      : @(YES),
       @"drawLineEnd"        : @(YES),
       @"wind"               : @"{50, 0}",
       @"gravity"            : @"{0, 50}",
       @"colorStart"         : @"{1.0, 1.0, 1.0, 1.0}",
       @"colorEnd"           : @"{0.5, 0.5, 0.0, 0.0}",
       }];

    return self;
}

- (NSUInteger)count
{
    return _lines.count;
}

- (NSDictionary *)lineFromIndex:(NSUInteger)index
{
    NSAssert(index < self.count, @"Invalid index");
    return [_lines objectAtIndex:index];
}

- (NSDictionary *)lineFromName:(NSString *)name
{
    for (NSDictionary *dict in _lines)
    {
        if ([name isEqualToString:[dict objectForKey:@"name"]]) return dict;
    }
    return nil;
}

- (NSString *)nameFromIndex:(NSUInteger)index
{
    NSAssert(index < self.count, @"Invalid index");
    return [[_lines objectAtIndex:index] objectForKey:@"name"];
}

// -----------------------------------------------------------------------

@end
