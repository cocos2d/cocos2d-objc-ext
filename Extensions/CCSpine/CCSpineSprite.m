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

#import "CCSpineSprite.h"
#import "CCDictionary.h"
#import "CCNodeTag.h"

// ----------------------------------------------------------------------------------------------


// ----------------------------------------------------------------------------------------------

@implementation CCSpineSprite
{
    NSString*                       _boneName;
    NSString*                       _attachment;
}

// ----------------------------------------------------------------------------------------------

+ (instancetype)spriteWithDictionary:(NSDictionary *)dict
{
    return([[CCSpineSprite alloc] initWithDictionary:dict]);
}

// ----------------------------------------------------------------------------------------------

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self                        = [super init];

    // initialize sprite by reading dictionary
    
    _name                       = [dict readString:@"name" def:@"noname"];
    _boneName                   = [dict readString:@"bone" def:@""];
    _attachment                 = [[dict readString:@"attachment" def:nil] lastPathComponent];
    if (_attachment == nil) _attachment = _name;
    _bone                       = nil;
    _texture                    = nil;
    
    // done
    return(self);
}

// ----------------------------------------------------------------------------------------------

- (void)updateWorldTransform
{
    self.position           = _bone.position;
    self.rotation           = -_bone.rotation;
    self.scaleX             = _bone.scale.x;
    self.scaleY             = _bone.scale.y;
}

// ----------------------------------------------------------------------------------------------

- (void)showTexture:(CCSpineTexture *)texture
{
    int tag = (texture != nil) ? texture.tag : CCSpineTextureInvalidTag;
    [self showTextureForTag:tag];
}

// ----------------------------------------------------------------------------------------------

- (void)showTextureForTag:(int)tag
{
    for (CCSprite* sprite in self.children)
    {
        sprite.visible = (sprite.tag == tag);
    }
}

// ----------------------------------------------------------------------------------------------

- (void)addTexture:(CCSpineTexture *)texture
{
    // check if same sprite
    if ([self getChildByTag:texture.tag])
    {
        CCLOG(@"Warning ! Sprite %@ already added to sprite %@", texture.name, _name);
        return;
    }
    // add the sprite
    NSString* filename  = [texture.name stringByAppendingString:@".png"];
    if ([[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:filename] != nil)
    {
        
        // create new sprite
        CCSprite* image     = [CCSprite spriteWithImageNamed:filename];
        // set up the sprite
        image.position      = texture.position;
        image.rotation      = -texture.rotation;
        image.scaleX        = texture.scale.x * texture.size.width / image.contentSize.width;
        image.scaleY        = texture.scale.y * texture.size.height / image.contentSize.height;
        image.tag           = texture.tag;
        image.visible       = NO;
        // check for scaling
        // if ((image.scaleX > 1.2) || (image.scaleY > 1.2)) CCLOG(@"Warning ! Sprite %@ was scaled up more than 20%%", filename);
        [self addChild:image];
        self.parent.zOrder = self.zOrder;
                              
    }
    else
    {
        CCLOG(@"Warning ! Texture %@ was not found", filename);
    }
}

// ----------------------------------------------------------------------------------------------
// properties
// ----------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------

@end














































