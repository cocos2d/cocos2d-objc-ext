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

// TODO Add documentation

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// -----------------------------------------------------------------------

typedef NS_ENUM(NSInteger, CCEffectLineMode)
{
    CCEffectLineModePointToPoint,           // line is drawn point to point as defined
    CCEffectLineModeFreeHand,               // free hand drawing
    CCEffectLineModeStraight,               // line is drawn as a straight line between start and end
};

typedef NS_ENUM(NSInteger, CCEffectLineWidth)
{
    CCEffectLineWidthSimple,                // line width is constant
    CCEffectLineWidthSpeed,                 // line width is dependent on drawing speed
    CCEffectLineWidthBarrel,                // line width is barrel shaped
};

typedef NS_ENUM(NSInteger, CCEffectLineTexture)
{
    CCEffectLineTextureSimple,              // simple texturing
    CCEffectLineTextureBlendSinus,          // textures are blended according to sinus shape
    CCEffectLineTextureBlendLinear,         // textures are blended linear
    CCEffectLineTextureRandom,              // textures are shown random
};

typedef NS_ENUM(NSInteger, CCEffectLineAnimation)
{
    CCEffectLineAnimationNone,              // no texture animation
    CCEffectLineAnimationScroll,            // texture scrolls
    CCEffectLineAnimationRandom,            // texture is animated randomly
    CCEffectLineAnimationClamped,           // texture will be shown only once
};

typedef NS_ENUM(NSInteger, CCEffectLineDebug)
{
    CCEffectLineDebugNone,                  // no debug drawing
    CCEffectLineDebugSegments,              // line is drawn as a series of segments
    CCEffectLineDebugBoth,                  // both normal texture and segments are drawn
};

// -----------------------------------------------------------------------

@interface CCEffectLine : CCSprite

// -----------------------------------------------------------------------

// control properties
@property (nonatomic, assign) CCEffectLineMode lineMode;                // line type
@property (nonatomic, assign) float life;                               // life span of the line
@property (nonatomic, assign) BOOL autoRemove;                          // autoremove when expired
@property (nonatomic, assign) BOOL smooth;                              // a smooth line will be generated
@property (nonatomic, assign) float speedMultiplyer;                    // speed multiplyer
@property (nonatomic, assign) float granularity;                        // granularity of the line (0->1)
@property (nonatomic, assign) BOOL drawLineStart;                       // draw line start
@property (nonatomic, assign) BOOL drawLineEnd;                         // draw line end
@property (nonatomic, assign) CGPoint wind;                             // wind factor
@property (nonatomic, assign) CGPoint gravity;                          // gravity factor
@property (nonatomic, assign) GLKVector4 colorStart;                    // start color
@property (nonatomic, assign) GLKVector4 colorEnd;                      // end color
@property (nonatomic, assign) BOOL locked;                              // locked while adding
@property (nonatomic, assign) CCEffectLineWidth widthMode;              // width type
@property (nonatomic, assign) float widthStart;
@property (nonatomic, assign) float widthEnd;
@property (nonatomic, assign) CCEffectLineTexture textureMix;           // texture mixing
@property (nonatomic, assign) CCEffectLineAnimation textureAnimation;   // texture animation
@property (nonatomic, assign) NSUInteger textureCount;                  // textures in texture (number of lines, default 8)
@property (nonatomic, assign) NSUInteger textureIndex;                  // current texture index
@property (nonatomic, assign) float textureScale;                       // scale the texture
@property (nonatomic, assign) float textureScroll;                      // scroll speed for texture animation
@property (nonatomic, assign) float textureMixTime;                     // time to mix to next texture
@property (nonatomic, assign) float textureGain;                        // defines gain of texture (normally just leave)
@property (nonatomic, assign) CCEffectLineDebug debugMode;              // draw debug mode

@property (nonatomic, readonly) float contentScale;
@property (nonatomic, readonly) BOOL expired;                           // all segments have been removed
@property (nonatomic, readonly) float length;                           // return length of line
@property (nonatomic, readonly) float drawSpeed;                        // drawing speed


// -----------------------------------------------------------------------

+ (instancetype)lineWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

+ (instancetype)lineWithImageNamed:(NSString *)imageName;
- (instancetype)initWithImageNamed:(NSString *)imageName;

- (void)start:(CGPoint)pos timestamp:(NSTimeInterval)timestamp;
- (BOOL)add:(CGPoint)pos timestamp:(NSTimeInterval)timestamp;
- (void)end:(CGPoint)pos timestamp:(NSTimeInterval)timestamp;
- (void)clear;

- (void)clearTextures;
- (void)addTextures:(NSArray *)list;

// -----------------------------------------------------------------------

@end
