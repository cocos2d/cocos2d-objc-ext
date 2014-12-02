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

#import "CCCropNode.h"

//----------------------------------------------------------------------

@implementation CCCropNode
{
    CCNode *_cropNode;
}

//----------------------------------------------------------------------

+ (instancetype)cropNode
{
    return([[self alloc] init]);
}

- (instancetype)init
{
    self = [super init];
    self.contentSize = [CCDirector sharedDirector].viewSize;
    self.mode = CCCropModeGraphics;
    _cropNode = nil;
    // done
    return(self);
}

//----------------------------------------------------------------------

- (BOOL)hitTestWithWorldPos:(CGPoint)pos
{
    return(YES);
}

//----------------------------------------------------------------------

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    // we only get here if cropping touches is enabled
    CCNode *node = nil;
    if (self.children.count) node = [self.children objectAtIndex:0];

    // if there is a child node, and the touch is outsire, kill the touch
    if (node && ![node hitTestWithWorldPos:touch.locationInWorld]) return;
    [super touchBegan:touch withEvent:event];
}

//----------------------------------------------------------------------

- (void)visit:(CCRenderer *)renderer parentTransform:(const GLKMatrix4 *)parentTransform
{
    // check if there is defined a node to crop
    // otherwise get first child (if any)
    CCNode *node = _cropNode;
    if ((node == nil) && (self.children.count)) node = [self.children objectAtIndex:0];
    
    if (node && ((_mode == CCCropModeGraphics) || (_mode == CCCropModeGraphicsAndTouches)))
    {
        // enable scissors
        CGPoint pos;
        CGSize size;
        float scale = [CCDirector sharedDirector].contentScaleFactor;
        
        size = node.contentSize;
        pos = [node convertToWorldSpace:node.position];
        
        [renderer enqueueBlock:^{
            glScissor(pos.x * scale, pos.y * scale, size.width * scale, size.height * scale);
            glEnable(GL_SCISSOR_TEST);
        } globalSortOrder:0 debugLabel:nil threadSafe:NO];
    }
    
    // render children
    [super visit:renderer parentTransform:parentTransform];

    if (node && ((_mode == CCCropModeGraphics) || (_mode == CCCropModeGraphicsAndTouches)))
    {
        // disable scissors
        [renderer enqueueBlock:^{
            glDisable(GL_SCISSOR_TEST);
        } globalSortOrder:0 debugLabel:nil threadSafe:NO];
    }
}

//----------------------------------------------------------------------

- (void)setMode:(CCCropMode)mode
{
    NSAssert(mode <= CCCropModeGraphicsAndTouches, @"Invalid crop mode");
    self.userInteractionEnabled = ((mode == CCCropModeTouches) || (mode == CCCropModeGraphicsAndTouches));
    _mode = mode;
}

//----------------------------------------------------------------------

- (void)setCropNode:(CCNode *)node
{
    _cropNode = node;
}

//----------------------------------------------------------------------

- (NSString *)debugString
{
    BOOL graphics = ((_mode == CCCropModeGraphics) || (_mode == CCCropModeGraphicsAndTouches));
    BOOL touches = ((_mode == CCCropModeTouches) || (_mode == CCCropModeGraphicsAndTouches));
    return([NSString stringWithFormat:@"Crop graphics:%@ touch:%@", graphics ? @"YES" : @" NO", touches ? @"YES" : @" NO"]);
}

//----------------------------------------------------------------------

@end
