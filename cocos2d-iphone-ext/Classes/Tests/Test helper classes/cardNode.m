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

#import "cardNode.h"

//----------------------------------------------------------------------

@implementation cardNode
{
    CCSprite *_front;
    CCSprite *_back;
}

//----------------------------------------------------------------------

+ (instancetype)cardWithName:(NSString *)name
{
    return([[self alloc] initWithName:name]);
}

//----------------------------------------------------------------------

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    
    // initialize front and backface
    // OBS! Resources must previously have been loaded
    _front = [CCSprite spriteWithImageNamed:name];
    [self addChild:_front];
    
    _back = [CCSprite spriteWithImageNamed:@"back.red.png"];
    _back.visible = NO;
    [self addChild:_back];
    
    // finally, set content size to match the content
    self.contentSize = _front.contentSize;
    // done
    return(self);
}

//----------------------------------------------------------------------

- (void)visit:(CCRenderer *)renderer parentTransform:(const GLKMatrix4 *)parentTransform
{
    _front.visible = !_backFacing;
    _back.visible = _backFacing;
    // 
    [super visit:renderer parentTransform:parentTransform];
}

//----------------------------------------------------------------------

@end
