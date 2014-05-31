//
//  CCSpriteTag.h
//  Spine
//
//  Created by Lars Birkemose on 31/05/14.
//  Copyright 2014 Lars Birkemose. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

//----------------------------------------------------------------------

@interface CCNode (CCNodeTag)

//----------------------------------------------------------------------

@property (nonatomic, assign) NSInteger tag;

//----------------------------------------------------------------------

- (void)addChild:(CCNode *)node z:(NSInteger)z tag:(NSInteger)tag;
- (void)removeChildByTag:(NSInteger)tag;
- (void)removeChildByTag:(NSInteger)tag cleanup:(BOOL)cleanup;
- (CCNode *)getChildByTag:(NSInteger)tag;

//----------------------------------------------------------------------

@end

