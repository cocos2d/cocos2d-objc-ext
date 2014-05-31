//
//  CCSpriteTag.m
//  Spine
//
//  Created by Lars Birkemose on 31/05/14.
//  Copyright 2014 Lars Birkemose. All rights reserved.
//

#import "CCNodeTag.h"

//----------------------------------------------------------------------

static void *nodeTagKey = &nodeTagKey;

//----------------------------------------------------------------------

@implementation CCNode (CCNodeTag)

//----------------------------------------------------------------------

- (void)addChild:(CCNode *)node z:(NSInteger)z tag:(NSInteger)tag
{
    self.tag = tag;
    [self addChild:node z:z];
}

//----------------------------------------------------------------------

- (void)removeChildByTag:(NSInteger)tag
{
    CCNode *node = [self getChildByTag:tag];
    if (!node)
        ;
    else
        [self removeChild:node];
}

//----------------------------------------------------------------------

- (void)removeChildByTag:(NSInteger)tag cleanup:(BOOL)cleanup
{
    CCNode *node = [self getChildByTag:tag];
    if (!node)
        ;
    else
        [self removeChild:node cleanup:cleanup];
}

//----------------------------------------------------------------------

- (CCNode *)getChildByTag:(NSInteger)tag
{
    for (CCNode *node in self.children)
    {
        if (node.tag == tag) return(node);
    }
    return(nil);
}

//----------------------------------------------------------------------
// tag property implementation

// OBS!
// As long as tag hasn't been set, the associated object will be nil, and intergetValue will return 0 (zero), which is well defined behaviour

- (NSInteger)tag
{
    NSNumber *number = objc_getAssociatedObject(self, nodeTagKey);
    return([number integerValue]);
}

- (void)setTag:(NSInteger)tag
{
    objc_setAssociatedObject(self, nodeTagKey, [NSNumber numberWithInteger:tag], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//----------------------------------------------------------------------

@end
