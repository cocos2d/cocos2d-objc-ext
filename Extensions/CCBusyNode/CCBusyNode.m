/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2012-2015 Lars Birkemose
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

#import "CCBusyNode.h"

// -----------------------------------------------------------------------

@implementation CCBusyNode
{
    UIActivityIndicatorView *_indicator;
}

// -----------------------------------------------------------------------

- (instancetype)init
{
    self = [super init];
    
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicator.hidesWhenStopped = YES;
    _indicator.frame = CGRectMake(0, 0, 0, 0);
    // show indicator
    self.visible = YES;
    
    return self;
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    self.visible = NO;
}

// -----------------------------------------------------------------------

- (void)setVisible:(BOOL)visible
{
    [super setVisible:visible];
    if (self.visible)
    {
        [[CCDirector sharedDirector].view addSubview:_indicator];
        [_indicator startAnimating];
    }
    else
    {
        [_indicator stopAnimating];
        [_indicator removeFromSuperview];
    }
}

// -----------------------------------------------------------------------

- (void)setScaleX:(float)scaleX
{
    [super setScaleX:scaleX];
    _indicator.transform = CGAffineTransformMakeScale(_scaleX, _scaleY);
}

- (void)setScaleY:(float)scaleY
{
    [super setScaleY:scaleY];
    _indicator.transform = CGAffineTransformMakeScale(_scaleX, _scaleY);
}

- (void)setScale:(float)scale
{
    [super setScale:scale];
    _indicator.transform = CGAffineTransformMakeScale(_scaleX, _scaleY);
}

// -----------------------------------------------------------------------

- (void)setColor:(CCColor *)color
{
    [super setColor:color];
    _indicator.color = color.UIColor;
}

// -----------------------------------------------------------------------

- (void)draw:(CCRenderer *)renderer transform:(const GLKMatrix4 *)transform
{
    // convert position to openGL coordinates and position indicator
    CGPoint pos = [self positionInPoints];
    pos = [[CCDirector sharedDirector] convertToGL:pos];
    _indicator.frame = CGRectMake(pos.x, pos.y, 0, 0);
    //
    [super draw:renderer transform:transform];
}

// -----------------------------------------------------------------------

@end

































