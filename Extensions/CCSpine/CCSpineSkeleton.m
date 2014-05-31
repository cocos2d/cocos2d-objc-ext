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

#import "CCSpineSkeleton.h"
#import "CCSpineBone.h"
#import "CCSpineSprite.h"
#import "CCSpineSkin.h"
#import "CCSpineAnimation.h"
#import "CCSpineTimeline.h"
#import "CCNodeTag.h"

// ----------------------------------------------------------------------------------------------

const NSString *CCSpineSkeletonDefaultSkin      = @"default";               // default skin loaded
const NSString *CCSpineSkeletonDefaultAnimation = @"idle";
const NSInteger CCSpineSkeletonBoneZInterval    = 10;

// ----------------------------------------------------------------------------------------------

@implementation CCSpineSkeleton
{
    NSString*                                   _json;
    NSMutableArray*                             _boneList;
    NSMutableDictionary*                        _spriteList;                // iterate sprites, by iterating spriteParent.children
    NSMutableDictionary*                        _skinList;
    NSMutableDictionary*                        _animationList;
    CCSpineAnimationControl*                    _animationControl;
    CCSpineSkin*                                _defaultSkin;               // default of skin section
    CCSpineSkin*                                _currentSkin;
    CCNode*                                     _spriteParent;              // CCSpineSprite nodes are added here
    float                                       _animationSpeed;
}

// ----------------------------------------------------------------------------------------------

+ (instancetype)skeletonWithJsonFile:(NSString *)file andSpriteSheet:(NSString *)spriteSheet
{
    return([[CCSpineSkeleton alloc] initWithJsonFile:file andSpriteSheet:spriteSheet]);
}

// ----------------------------------------------------------------------------------------------

- (instancetype)initWithJsonFile:(NSString *)file andSpriteSheet:(NSString *)spriteSheet
{
    self                            = [super init];
    
    _json                           = [NSString stringWithString:file];
    
    // initialize
    _spriteParent                   = [CCNode node];
    [self addChild:_spriteParent];
    
    // load the frames
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:spriteSheet];

    _animationControl               = [CCSpineAnimationControl animationControl];


    NSData* data;
    NSString* path;
   // NSTimeInterval time = UTIL.runtime;
    
    path      = [[NSBundle mainBundle] pathForResource:[file stringByDeletingPathExtension] ofType:@"json"];
    data = [NSData dataWithContentsOfFile: path];

    //time = UTIL.runtime - time;
    //CCLOG(@"time :%.3f", time);

    
    NSDictionary* json              = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    // create lists
    _boneList                       = [NSMutableArray array];
    _spriteList                       = [NSMutableDictionary dictionary];
    _skinList                       = [NSMutableDictionary dictionary];
    _animationList                  = [NSMutableDictionary dictionary];
    
    // load bones
    NSArray* boneArray              = [json objectForKey:@"bones"];
    for (NSDictionary *boneDict in boneArray)
    {
        // create the bone and add it to list
        CCSpineBone *bone             = [CCSpineBone boneWithDictionary:boneDict];
        [_boneList addObject:bone];
    }

    // load sprites
    NSArray *spriteArray = [json objectForKey:@"slots"];
    for (NSDictionary *spriteDict in spriteArray)
    {
        // create the sprite
        CCSpineSprite *sprite = [CCSpineSprite spriteWithDictionary:spriteDict];
        // find its bone
        sprite.bone = [self getBoneByName:sprite.boneName];
        // add sprite
        sprite.zOrder = _spriteList.count * CCSpineSkeletonBoneZInterval;
        // add sprite to parent and to sprite list
        [_spriteParent addChild:sprite];
        [_spriteList setObject:sprite forKey:sprite.name];
    }
    
    // load skins
    NSDictionary* skinDict          = [json objectForKey:@"skins"];
    for (NSString* skinName in skinDict)
    {
        // create the skin
        CCSpineSkin* skin             = [CCSpineSkin skinWithDictionary:[skinDict objectForKey:skinName] andName:skinName];
        // create entry for skin
        [_skinList setObject:skin forKey:skinName];
    }
    
    // load animations
    NSDictionary* animationDict     = [json objectForKey:@"animations"];
    for (NSString* name in animationDict)
    {
        // create the animation
        CCSpineAnimation* animation   = [CCSpineAnimation animationWithDictionary:[animationDict objectForKey:name] andName:name];
        // create entry for animation
        [_animationList setObject:animation forKey:name];
    }
    
    // -------------------------------
    // set up pointers for fast access
    
    // set parent for CCSpineBone
    for (CCSpineBone* bone in _boneList)
    {
        bone.parentBone             = [self getBoneByName:bone.parentName];
    }

    // set bones for CCSpineTimeline
    for (NSString* name in _animationList)
    {
        CCSpineAnimation* animation   = [_animationList objectForKey:name];
        for (CCSpineTimeline* timeline in animation.timelineList)
        {
            timeline.bone           = [self getBoneByName:timeline.boneName];
        }
    }
    
    // ------------------------------
    
    // reset internal
    
    _animationSpeed                 = 1.0;
    _skeletonPaused                 = NO;
    _currentSkin                    = nil;
    _defaultSkin                    = [_skinList objectForKey:CCSpineSkeletonDefaultSkin];
    
    // done
    return(self);
}

// ----------------------------------------------------------------------------------------------

- (void)update:(CCTime)dt {
    BOOL animationUpdated = NO;
    
    if ((_skeletonPaused == YES) && (dt != 0)) return;
    
    // adjust time for animation speed
    dt *= _animationSpeed;

    // update animation control
    [_animationControl tick:dt];
    
    // scan through any running animation
    for (CCSpineAnimation* animation in _animationControl.animationList) {
        [animation tick:dt];
    
        switch (animation.state) {
                
            case CCSpineAnimationStateStart:
            case CCSpineAnimationStateBlend:
            case CCSpineAnimationStateRun:
            case CCSpineAnimationStateExpired:
                // add animations to bones
                for (CCSpineTimeline* timeline in animation.timelineList) {
                    
                    CCSpineBoneData data = [timeline getSpineDataAt:animation.runTime strength:animation.strength];
                    [timeline.bone addAnimation:data];
                    
                }
                // apply texture animations to sprite
                // TODO add color and opacity animation
                for (CCSpineSprite* sprite in _spriteParent.children) {
                    if ([animation hasTextureAnimation:sprite.name] == YES) {
                        CCSpineTextureFrame* textureFrame           = [animation getTextureFrameAt:animation.runTime forName:sprite.name];
                        [sprite showTextureForTag:textureFrame.tag];
                    } else {
                        [sprite showTexture:sprite.texture];
                    }
                }
                animationUpdated = YES;
                break;
                
            default:
                break;
                
        }
        
        
    }

    if (animationUpdated == NO)
        CCLOG(@"Warning! No amination was updated");
    
    // update bone positions
    for (CCSpineBone* bone in _boneList)
    {
        [bone updateWorldTransform];
    }
    
    // update sprite positions
    for (CCSpineSprite* sprite in _spriteParent.children)
    {
        [sprite updateWorldTransform];
    }
    
}

// ----------------------------------------------------------------------------------------------

- (CCSpineBone *)getBoneByName:(NSString *)name
{
    for (CCSpineBone* bone in _boneList)
    {
        if ([bone.name isEqualToString:name] == YES) return(bone);
    }
    if (name != nil) CCLOG(@"Warning ! Bone %@ not found", name);
    return(nil);
}

// ----------------------------------------------------------------------------------------------
// assigns a complete skin to skeleton
// all previous skin parts are removed

- (void)assignSkinByName:(NSString *)skinName
{
    CCSpineSkin* skin                     = nil;
    if (skinName != nil) skin         = [_skinList objectForKey:skinName];
    if (skin == nil)
    {
        skin                            = [_skinList objectForKey:CCSpineSkeletonDefaultSkin];
        if (skin == nil) skin         = [_skinList objectForKey:[_skinList.allKeys objectAtIndex:0]];
        CCLOG(@"Warning ! skin %@ not found, using %@", skinName, skin.name);
    }
    [self assignSkin:skin];
}

// ----------------------------------------------------------------------------------------------

- (void)clearSkin
{
    for (CCSpineSprite* sprite in _spriteParent.children) [sprite removeAllChildren];
}

// ----------------------------------------------------------------------------------------------

- (void)assignSubSkin:(CCSpineSkin *)skin
{
    // loop through sprites
    for (NSString* spriteName in skin.spriteList)
    {
        // get sprite 
        CCSpineSprite* sprite                   = [_spriteList objectForKey:spriteName];
        // get the spritelist for the sprite
        NSArray* textureList                = [skin.spriteList objectForKey:spriteName];
        // loop through list, and add sprite
        // show it if it is default attachment
        for (CCSpineTexture* texture in textureList)
        {
            [sprite addTexture:texture];
            if ([sprite.attachment isEqualToString:texture.attachment] == YES)
            {
                [sprite showTexture:texture];
                sprite.texture = texture;
                texture.frame = nil;
            }
        }
    }
    // tags for sprite frames must be set, as they are used to animate skins
    // loop through animations
    for (NSString* name in _animationList)
    {
        CCSpineAnimation* animation = [_animationList objectForKey:name];
        
        // set tags for CCSpineTextureFrame for current skin
        // this is done, so that sprites can be animated by their tags for better performance
        
        // get the sprites in the animation
        for (NSString* spriteName in animation.spriteFrameList)
        {
            // get the sprite frames attached to the sprite
            NSArray* textureFrameList = [animation.spriteFrameList objectForKey:spriteName];
            for (CCSpineTextureFrame* textureFrame in textureFrameList)
            {
                // check if there is a sprite list in the skin
                NSArray* textureList = [skin.spriteList objectForKey:spriteName];
                if (textureList != nil)
                {
                    // scan through the sprite list
                    // if the sprite frame name equals attachment, get the filename
                    // if the sprite frame name equals the filename, simply use it
                    for (CCSpineTexture* texture in textureList)
                    {
                        if ([texture.attachment isEqualToString:textureFrame.name])
                        {
                            textureFrame.tag = [skin getTextureTag:texture.name spriteName:spriteName];
                            texture.frame = textureFrame;
                        }
                        else if ([texture.name isEqualToString:textureFrame.name])
                        {
                            textureFrame.tag = [skin getTextureTag:textureFrame.name spriteName:spriteName];
                            texture.frame = textureFrame;
                        }
                        else
                        {
                            texture.frame = nil;
                        }
                    }
                }
                else
                {
                    // there was no sprite list in the skin
                    // check if frame name equals the sprite filename
                    int tag = [skin getTextureTag:textureFrame.name spriteName:spriteName];
                    if (tag >= CCSpineTextureAutoTag) textureFrame.tag = tag;
                }
            }
        }
    }
}

// ----------------------------------------------------------------------------------------------

- (void)assignSkin:(CCSpineSkin *)skin
{
    // check if same skin
    if (skin == _currentSkin) return;
    _currentSkin = skin;
    // clear old skin
    [self clearSkin];
    // load default section
    [self assignSubSkin:_defaultSkin];
    // load main skin
    [self assignSubSkin:skin];
}

// ----------------------------------------------------------------------------------------------

- (CCSpineTexture *)getSpineTextureByName:(NSString *)name
{
    for (NSString* skinName in _skinList)
    {
        CCSpineSkin* skin = [_skinList objectForKey:skinName];
        for (NSString* spriteName in skin.spriteList)
        {
            NSArray* textureList = [skin.spriteList objectForKey:spriteName];
            if (textureList != nil)
            {
                for (CCSpineTexture* texture in textureList)
                {
                    if ([name isEqualToString:texture.name]) return(texture);
                }
            }
        }
    }
    return(nil);
}

// ----------------------------------------------------------------------------------------------

- (void)replaceTexture:(NSString *)oldTextureName newTextureName:(NSString *)newTextureName {
    CCSpineTexture* texture;
    
    // loop through sprites
    for (CCSpineSprite* spineSprite in _spriteParent.children)
    {
        int tag = [_currentSkin getTextureTag:oldTextureName spriteName:spineSprite.name];
        if (tag != CCSpineTextureInvalidTag)
        {
            // find new sprite
            texture = [self getSpineTextureByName:newTextureName];
            [texture assignNewTag:tag];
            if (texture != nil)
            {
                for (CCSprite* sprite in spineSprite.children)
                {
                    if (sprite.tag == tag)
                    {
                        [sprite removeChildByTag:tag cleanup:YES];
                        [spineSprite addTexture:texture];
                    }
                }
            }
            return;
        }
    }
}

// ----------------------------------------------------------------------------------------------

- (CCSpineAnimation *)animationByName:(NSString *)name
{
    CCSpineAnimation* result = [_animationList objectForKey:name];
    if (result == nil) CCLOG(@"Skeleton <%@> has no animation <%@>", _json, name);
    return(result);
}

// ----------------------------------------------------------------------------------------------

- (void)pauseAnimation
{
    _skeletonPaused = YES;
}

- (void)resumeAnimation
{
    _skeletonPaused = NO;
}

// ----------------------------------------------------------------------------------------------

- (void)pose
{
    [self update:0];
}

// ----------------------------------------------------------------------------------------------

- (void)clearAnimations
{
    [_animationControl reset];
}

// ----------------------------------------------------------------------------------------------

- (CCSpineAnimation *)setBaseAnimation:(NSString *)name
{
    return([self setBaseAnimation:name delegate:nil selector:nil]);
}

- (CCSpineAnimation *)setBaseAnimation:(NSString *)name delegate:(id)delegate selector:(SEL)selector
{
    CCSpineAnimation* animation = [self animationByName:name];
    [animation setCallback:delegate selector:selector];
    [_animationControl setBaseAnimation:animation];
    return(animation);
}

- (CCSpineAnimation *)insertAnimation:(NSString *)name
{
    return([self insertAnimation:name delegate:nil selector:nil]);
}

- (CCSpineAnimation *)insertAnimation:(NSString *)name delegate:(id)delegate selector:(SEL)selector
{
    CCSpineAnimation* animation = [self animationByName:name];
    [animation setCallback:delegate selector:selector];
    [_animationControl insertAnimation:animation];
    return(animation);
}

- (CCSpineAnimation *)forceAnimation:(NSString *)name
{
    return([self forceAnimation:name delegate:nil selector:nil]);
}

- (CCSpineAnimation *)forceAnimation:(NSString *)name delegate:(id)delegate selector:(SEL)selector
{
    CCSpineAnimation* animation = [self animationByName:name];
    [animation setCallback:delegate selector:selector];
    [_animationControl forceAnimation:animation];
    return(animation);
}

// ----------------------------------------------------------------------------------------------

- (void)addTimedCallback:(NSString *)name time:(float)time delegate:(id)delegate selector:(SEL)selector
{
    CCSpineAnimation* animation = [self animationByName:name];
    [animation addTimedCallback:time delegate:delegate selector:selector];
}

// ----------------------------------------------------------------------------------------------

- (void)logAnimations
{
    CCLOG(@"- Animation list ----------------------------------");
    CCLOG(@"Skeleton <%@>", _json);
    CCLOG(@"Animations:");
    int count = 1;
    for (NSString* key in [_animationList allKeys])
    {
        CCLOG(@"%3d) <%@>", count, key);
        count ++;
    }
    CCLOG(@"---------------------------------------------------");
}

// ----------------------------------------------------------------------------------------------

- (void)logSkins
{
    CCLOG(@"- Skin list ---------------------------------------");
    CCLOG(@"Skeleton <%@>", _json);
    CCLOG(@"Skins:");
    int count = 1;
    for (NSString* key in [_skinList allKeys])
    {
        CCLOG(@"%3d) <%@>", count, key);
        count ++;
    }
    CCLOG(@"---------------------------------------------------");
}

// ----------------------------------------------------------------------------------------------
// properties
// ----------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------

@end









































