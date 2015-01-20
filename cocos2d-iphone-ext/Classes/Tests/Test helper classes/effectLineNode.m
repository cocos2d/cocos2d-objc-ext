/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2008-2010 Ricardo Quesada
 * Copyright (c) 2011 Zynga Inc.
 * Copyright (c) 2013-2015 Cocos2D Authors
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

#import "effectLineNode.h"
#import "CCEffectLineSegment.h"
#import "CCEffectLine.h"
#import "CCEffectLineFactory.h"

// -----------------------------------------------------------------

@implementation effectLineNode
{
    CCNode *_lineContainer;
    CCEffectLine *_currentLine;
    CCEffectLine *_extraLine; // for double line effects
    
    CCEffectLineFactory *_lineFactory;
    NSUInteger _lineIndex;
}

// -----------------------------------------------------------------

+ (instancetype)nodeWithLine:(NSUInteger)line
{
    return [[self alloc] initWithLine:line];
}

// -----------------------------------------------------------------

- (instancetype)initWithLine:(NSUInteger)line
{
    self = [super init];
    
    // initialise
    self.contentSize = [CCDirector sharedDirector].viewSize;
    self.userInteractionEnabled = YES;
    
    // line container
    _lineContainer = [CCNode node];
    [self addChild:_lineContainer];
    _currentLine = nil;
    _extraLine = nil;
    
    // line factory
    _lineFactory = [CCEffectLineFactory new];
    _lineIndex = line;
    
    // show line type
    CCLabelTTF *label = [CCLabelTTF labelWithString:[_lineFactory nameFromIndex:_lineIndex] fontName:@"Arial" fontSize:32];
    label.positionType = CCPositionTypeNormalized;
    label.position = ccp(0.5, 0.9);
    [self addChild:label];
    
    // done
    return self;
}

// -----------------------------------------------------------------

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    // start a new line
    NSDictionary *dict = [_lineFactory lineFromIndex:_lineIndex];
    
    // check for extra line
    // NOTE
    // the "extra" key is only added to the dictionaries, to allow for the demo app tp be able to create two simultaneous lines
    // the line itself, does not use this entry for anything
    if ([dict objectForKey:@"extra"])
        _extraLine = [CCEffectLine lineWithDictionary:[_lineFactory lineFromName:[dict objectForKey:@"extra"]]];
    
    _currentLine = [CCEffectLine lineWithDictionary:dict];
    
    [_lineContainer addChild:_currentLine];
    if (_extraLine) [_lineContainer addChild:_extraLine];
    
    // start the line
    [_currentLine start:touch.locationInWorld timestamp:touch.timestamp];
    if (_extraLine) [_extraLine start:touch.locationInWorld timestamp:touch.timestamp];
}

// -----------------------------------------------------------------

- (void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    [_currentLine add:touch.locationInWorld timestamp:touch.timestamp];
    if (_extraLine) [_extraLine add:touch.locationInWorld timestamp:touch.timestamp];
}

// -----------------------------------------------------------------

- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    [_currentLine end:touch.locationInWorld timestamp:touch.timestamp];
    if (_extraLine) [_extraLine end:touch.locationInWorld timestamp:touch.timestamp];
    
    _currentLine = nil;
    _extraLine = nil;
}

// -----------------------------------------------------------------

@end













