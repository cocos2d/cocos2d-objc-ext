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

#import "CCSpineSkin.h"

// ----------------------------------------------------------------------------------------------

@implementation CCSpineSkin
{
    NSString *_name;
    NSMutableDictionary *_spriteList;
}

// ----------------------------------------------------------------------------------------------

+ (instancetype)skinWithDictionary:(NSDictionary *)dict andName:(NSString *)name
{
    return([[CCSpineSkin alloc] initWithDictionary:dict andName:name]);
}

// ----------------------------------------------------------------------------------------------

- (instancetype)initWithDictionary:(NSDictionary *)dict andName:(NSString *)name
{
    self = [super init];
    
    // create lists
    _spriteList = [NSMutableDictionary dictionary];
    
    // initialize skin by reading dictionary
    _name = [NSString stringWithString:name];
    
    for (NSString* spriteName in dict)
    {
        // create the new sprite texture list
        NSMutableArray* spriteTextureList = [NSMutableArray array];
        
        // scan through the sprites
        NSDictionary* textureList = [dict objectForKey:spriteName];
        
        for (NSString* textureName in textureList)
        {
            // create the texture and add it
            // if the sprite entry does not have a name entry, use spriteEntry as filename
            CCSpineTexture* texture = [CCSpineTexture spriteWithDictionary:[textureList objectForKey:textureName] attachment:textureName];
            [spriteTextureList addObject:texture];
        }
        
        // add the entire texture list to the sprite
        [_spriteList setObject:spriteTextureList forKey:spriteName];
    }
    
    // done
    return(self);
}

// ----------------------------------------------------------------------------------------------

- (int)getTextureTag:(NSString *)textureName spriteName:(NSString *)spriteName
{
    CCSpineTexture *texture = [self getSpineTexture:textureName spriteName:spriteName];
    if (!texture) return(CCSpineTextureInvalidTag);
    return(texture.tag);
}

// ----------------------------------------------------------------------------------------------

- (CCSpineTexture *)getSpineTexture:(NSString *)textureName spriteName:(NSString *)spriteName
{
    NSArray* textureList  = [_spriteList objectForKey:spriteName];
    if ((textureList == nil) || (textureList.count == 0)) return(nil);
    for (CCSpineTexture* texture in textureList)
    {
        if ([textureName isEqualToString:texture.name] == YES) return(texture);
    }
    return(nil);
}

// ----------------------------------------------------------------------------------------------

@end


















































