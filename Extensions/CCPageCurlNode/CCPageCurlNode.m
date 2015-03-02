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

#import "CCPageCurlNode.h"
#import "CCCurlCylinder.h"

// -----------------------------------------------------------------------

#define CURL_DIAMETER_SHOW 0

#define CURL_RESOLUTION 80
#define CURL_DIAMETER 400

// -----------------------------------------------------------------------

@implementation CCPageCurlNode
{
    CCCurlCylinder *_curl;
    CGPoint _curlStart;
#if CURL_DIAMETER_SHOW != 0
    CCDrawNode *_draw;
#endif
}

// -----------------------------------------------------------------------

- (instancetype)initWithTexture:(CCTexture *)texture rect:(CGRect)rect rotated:(BOOL)rotated
{
    self = [super initWithTexture:texture rect:rect rotated:rotated];
    
    _pageMode = CCPageModeCurlFree;
    self.curlResolution = CURL_RESOLUTION;
#if CURL_DIAMETER_SHOW != 0
    _draw = [CCDrawNode new];
    [self addChild:_draw];
#endif
    
    // done
    return self;
}

// -----------------------------------------------------------------------

- (void)curlStart:(CGPoint)position
{

    switch (_pageMode) {
        case CCPageModeCurlLeft:
            // the page curl is locked to the left side
            _curl = [CCCurlCylinder cylinderWithDiameter:CURL_DIAMETER pageDefinition:(CCPageDefinition){self.contentSizeInPoints, CCPageAnchorLeft}];
            _curlStart = ccp(self.contentSizeInPoints.width, 0);
            break;

        case CCPageModeCurlRight:
            // the page curl is locked to the right side
            _curl = [CCCurlCylinder cylinderWithDiameter:CURL_DIAMETER pageDefinition:(CCPageDefinition){self.contentSizeInPoints, CCPageAnchorRight}];
            _curlStart = ccp(0, 0);
            break;

        case CCPageModeCurlFree:
        {
            // the page curl is free
            // grab corner closest to start
            CGPoint pagePosition = [self convertToNodeSpace:position];
            if (pagePosition.x < self.contentSizeInPoints.width * 0.5)
            {
                _curl = [CCCurlCylinder cylinderWithDiameter:CURL_DIAMETER pageDefinition:(CCPageDefinition){self.contentSizeInPoints, CCPageAnchorRight}];
                _curlStart = ccp(0, 0);
            }
            else
            {
                _curl = [CCCurlCylinder cylinderWithDiameter:CURL_DIAMETER pageDefinition:(CCPageDefinition){self.contentSizeInPoints, CCPageAnchorLeft}];
                _curlStart = ccp(self.contentSizeInPoints.width, 0);
            }
            break;
        }
    }
    //
    [_curl begin:[self convertToNodeSpace:position]];
}

// -----------------------------------------------------------------------

- (void)curlTo:(CGPoint)position
{
    [_curl update:[self convertToNodeSpace:position]];
    
    // the (touch) position is not the same as the curl position
    
    [self setCurlPosition:[self convertToNodeSpace:position]];
}

// -----------------------------------------------------------------------

- (void)curlCancel:(float)normalizedReturnTime
{
    [_curl end:CGPointZero];
    
    
    // reset the grid
    [self resetGrid];
#if CURL_DIAMETER_SHOW != 0
    [_draw clear];
#endif
}

// -----------------------------------------------------------------------

- (void)curlComplete:(float)normalizedCompletionTime
{
    [_curl end:CGPointZero];
    
    
    
    
    // reset the grid
    [self resetGrid];
#if CURL_DIAMETER_SHOW != 0
    [_draw clear];
#endif
}

// -----------------------------------------------------------------------

- (void)setCurlPosition:(CGPoint)curlPosition
{
#if CURL_DIAMETER_SHOW != 0
    [_draw clear];
#endif
    
    // reset the grid
    [self resetGrid];
    
    // adjust all vertices
    // the curl axis, is a line going perpendicular to the curl vector
    for (NSInteger index = 0; index < self.vertexCount; index ++)
    {
        // CGPoint pos = [self vertexPosition:index];

        [_curl curl:&self.vertex[index].position];
        // when working on a vertex directly, set dirty manually
        [self markAsDirty];
        
        // [self setVertex:index position:pos];

    }
    
#if CURL_DIAMETER_SHOW != 0
    CGPoint pos = ccpAdd(_curl.anchorPosition, _curl.anchorVector);
    
    [_draw drawSegmentFrom:_curl.anchorPosition to:pos radius:2 color:[CCColor blueColor]];
    [_draw drawSegmentFrom:_curl.anchorPosition to:ccpAdd(_curl.anchorPosition, _curl.pageVector) radius:2 color:[CCColor blueColor]];
    [_draw drawSegmentFrom:pos to:ccpAdd(pos, _curl.pageVector) radius:2 color:[CCColor blueColor]];
    
    [_draw drawSegmentFrom:_curl.startPosition to:_curl.position radius:2 color:[CCColor yellowColor]];

    // draw curl cylinder
    CGPoint perp = ccpNormalize(ccpPerp(ccpSub(_curl.endPositionB, _curl.endPositionA)));
    CGPoint perpA = ccpMult(perp, _curl.radiusA);
    CGPoint perpB = ccpMult(perp, _curl.radiusB);
    
    [_draw drawSegmentFrom:ccpAdd(_curl.endPositionA, perpA) to:ccpAdd(_curl.endPositionB, perpB) radius:2 color:[CCColor yellowColor]];
    [_draw drawSegmentFrom:ccpSub(_curl.endPositionA, perpA) to:ccpSub(_curl.endPositionB, perpB) radius:2 color:[CCColor yellowColor]];
#endif
}

- (void)setCurlResolution:(NSUInteger)curlResolution
{
    _curlResolution = curlResolution;
    [self setGridWidth:curlResolution andHeight:curlResolution];
}

- (void)draw:(CCRenderer *)renderer transform:(const GLKMatrix4 *)transform
{
    // TODO: re-enable for correct Z behaviour
    [renderer enqueueBlock:^{
        glEnable(GL_DEPTH_TEST);
        glDepthRangef(0, 1);
    } globalSortOrder:0 debugLabel:nil threadSafe:NO];
    [super draw:renderer transform:transform];
    [renderer enqueueBlock:^{
        glDisable(GL_DEPTH_TEST);
    } globalSortOrder:0 debugLabel:nil threadSafe:NO];
}

// -----------------------------------------------------------------------

@end





























