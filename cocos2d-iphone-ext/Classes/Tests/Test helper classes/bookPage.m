//
//  IntroScene.m
//  Line
//
//  Created by Lars Birkemose on 14/08/14.
//  Copyright Private 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "bookPage.h"

@implementation bookPage
{
    BOOL _isCurling;
}

// -----------------------------------------------------------------------

- (id)initWithTexture:(CCTexture *)texture rect:(CGRect)rect rotated:(BOOL)rotated
{
    // Apple recommend assigning self with supers return value
    self = [super initWithTexture:texture rect:rect rotated:rotated];

    _isCurling = NO;
    self.userInteractionEnabled = YES;
    
    // done
	return self;
}

- (void)update:(CCTime)delta
{
}

// -----------------------------------------------------------------------

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    [self curlStart:touch.locationInWorld];
    _isCurling = YES;
    
    
    
    /*
    if ([_curl hitTestWithWorldPos:touch.locationInWorld])
    {
        [_curl curlStart:touch.locationInWorld];
        _isCurling = YES;
    }
    */
}

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    if (!_isCurling) return;
    [self curlTo:touch.locationInWorld];
    /*
    if (!_isCurling) return;
    [_curl curlTo:touch.locationInWorld];
    */
}

- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    _isCurling = NO;
    [self curlCancel:1];
    /*
    _isCurling = NO;
    [_curl curlCancel:1];
    */
}

// -----------------------------------------------------------------------

@end
