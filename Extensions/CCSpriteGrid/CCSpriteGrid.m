/*
 * cocos2d for iPhone: http://www.cocos2d-swift.org
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

#import "CCSpriteGrid.h"

// -----------------------------------------------------------------------

#define CCSpriteGridLargeNumber 255

// -----------------------------------------------------------------------

@implementation CCSpriteGrid
{
    CCVertex *_originalVertex;
    BOOL *_vertexIsEdge;
    BOOL *_vertexIsLocked;
    CGPoint _textureOffset;
    CGSize _textureSize;
}

// -----------------------------------------------------------------------

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class CCSpriteGrid");
    // initialize
    
    _gridWidth = 1;
    _gridHeight = 1;
    _vertexCount = 0;
    _vertex = NULL;
    _originalVertex = NULL;
    _vertexIsEdge = NULL;
    _vertexIsLocked = NULL;
    _dirty = NO;
    
    // done
    return(self);
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    [self cleanUp];
}

// -----------------------------------------------------------------------

- (void)draw:(CCRenderer *)renderer transform:(const GLKMatrix4 *)transform
{
    if (_vertex == NULL)
    {
        [super draw:renderer transform:transform];
        return;
    }
    // a custom grid has been defined
    NSUInteger vertexCount = (_gridWidth + 1) * (_gridHeight + 1);
    NSUInteger triangleCount = 2 * _gridWidth * _gridHeight;
    
    // get a render buffer
    CCRenderBuffer buffer = [renderer enqueueTriangles:triangleCount
                                           andVertexes:vertexCount
                                             withState:self.renderState
                                       globalSortOrder:0];
    
    // transform vertices
    for (NSUInteger index = 0; index < vertexCount; index ++)
    {
        _vertex[index].color.a = self.opacity;
        CCRenderBufferSetVertex(buffer, (int)index, CCVertexApplyTransform(_vertex[index], transform));
    }
    
    // set up triangles
    NSUInteger triangleIndex = 0;
    for (NSUInteger height = 0; height < _gridHeight; height ++)
    {
        NSUInteger start = height * (_gridWidth + 1);

        for (NSUInteger width = 0; width < _gridWidth; width ++)
        {
            CCRenderBufferSetTriangle(buffer, (int)triangleIndex, start, start + 1, start + _gridWidth + 1);
            triangleIndex ++;
            CCRenderBufferSetTriangle(buffer, (int)triangleIndex, start + _gridWidth + 1, start + 1, start + _gridWidth + 2);
            triangleIndex ++;
            start ++;
        }
    }
}

// -----------------------------------------------------------------------

- (void)cleanUp
{
    free(_vertex);
    free(_originalVertex);
    free(_vertexIsEdge);
    free(_vertexIsLocked);
    _vertex = NULL;
    _originalVertex = NULL;
    _vertexIsEdge = NULL;
    _vertexCount = 0;
}

// -----------------------------------------------------------------------

- (void)setGridWidth:(NSUInteger)width andHeight:(NSUInteger)height
{
    NSAssert((width > 0) && (width <= CCSpriteGridLargeNumber), @"Invalid grid width");
    NSAssert((height > 0) && (height <= CCSpriteGridLargeNumber), @"Invalid grid height");

    // if grid previously defined, clear it
    if (_vertex != NULL)
    {
        [self cleanUp];
    }
    
    _gridWidth = width;
    _gridHeight = height;
    
    // if new grid defined, create it
    if ((width > 1) || (height > 1))
    {
        _vertexCount = (width + 1) * (height + 1);
        _vertex = malloc(_vertexCount * sizeof(CCVertex));
        _originalVertex = malloc(_vertexCount * sizeof(CCVertex));
        _vertexIsEdge = malloc(_vertexCount * sizeof(BOOL));
        _vertexIsLocked = malloc(_vertexCount * sizeof(BOOL));
        [self createGrid];
        [self resetGrid];
    }
}

// -----------------------------------------------------------------------

- (void)createGrid
{
    NSUInteger vertexIndex = 0;
    _textureOffset = (CGPoint)
    {
        self.vertexes->bl.texCoord1.v[0],
        self.vertexes->bl.texCoord1.v[1]
    };
    _textureSize = (CGSize)
    {
        self.vertexes->br.texCoord1.v[0] - self.vertexes->bl.texCoord1.v[0],
        self.vertexes->tl.texCoord1.v[1] - self.vertexes->bl.texCoord1.v[1]
    };
    
    for (NSUInteger height = 0; height <= _gridHeight; height ++)
    {
        for (NSUInteger width = 0; width <= _gridWidth; width ++)
        {
            float progressWidth = (float)width / (float)_gridWidth;
            float progressHeight = 1.0f - ((float)height / (float)_gridHeight);
            
            _originalVertex[vertexIndex].position = (GLKVector4)
            {
                self.contentSize.width * progressWidth,
                self.contentSize.height * progressHeight,
                0,
                1
            };
            _originalVertex[vertexIndex].color = (GLKVector4){
                1, 1, 1, 1
            };
            _originalVertex[vertexIndex].texCoord1 = (GLKVector2)
            {
                _textureOffset.x + (progressWidth * _textureSize.width),
                _textureOffset.y + (progressHeight * _textureSize.height)
            };
            
            _vertexIsEdge[vertexIndex] = (height == 0) || (height == _gridHeight) || (width == 0) || (width == _gridWidth);
            
            _vertexIsLocked[vertexIndex] = NO;
            
            vertexIndex ++;
        }
    }
    _dirty = YES;
}

// -----------------------------------------------------------------------

- (void)resetGrid
{
    if (!_dirty) return;
    for (NSUInteger index = 0; index < _vertexCount; index ++)
        _vertex[index] = _originalVertex[index];
    _dirty = NO;
}

// -----------------------------------------------------------------------

- (BOOL)isEdge:(NSUInteger)index
{
    NSAssert(index < _vertexCount, @"Invalid vertex index");
    return _vertexIsEdge[index];
}

// -----------------------------------------------------------------------
// getters

- (CGPoint)vertexPosition:(NSUInteger)index
{
    NSAssert(index < _vertexCount, @"Invalid vertex index");
    return (CGPoint){_vertex[index].position.x, _vertex[index].position.y};
}

- (CGPoint)textureCoordinate:(NSUInteger)index
{
    NSAssert(index < _vertexCount, @"Invalid vertex index");
    return (CGPoint){_vertex[index].texCoord1.v[0], _vertex[index].texCoord1.v[1]};
}

- (CCColor *)color:(NSUInteger)index
{
    NSAssert(index < _vertexCount, @"Invalid vertex index");
    GLKVector4 result = _vertex[index].color;
    return [CCColor colorWithRed:result.r green:result.g blue:result.b alpha:result.a];
}

// -----------------------------------------------------------------------
// setters

- (void)adjustVertex:(NSUInteger)index adjustment:(CGPoint)adjustment
{
    NSAssert(index < _vertexCount, @"Invalid vertex index");
    if (_vertexIsLocked[index]) return;
    _vertex[index].position.x = _vertex[index].position.x + adjustment.x;
    _vertex[index].position.y = _vertex[index].position.y + adjustment.y;
    _dirty = YES;
}

- (void)adjustTextureCoordinate:(NSUInteger)index adjustment:(CGPoint)adjustment
{
    NSAssert(index < _vertexCount, @"Invalid vertex index");
    if (_vertexIsLocked[index]) return;
    _vertex[index].texCoord1.v[0] = _vertex[index].texCoord1.v[0] + (adjustment.x / _textureSize.width);
    _vertex[index].texCoord1.v[1] = _vertex[index].texCoord1.v[1] + (adjustment.y / _textureSize.height);
    _dirty = YES;
}

- (void)adjustColor:(NSUInteger)index adjustment:(CCColor *)adjustment
{
    NSAssert(index < _vertexCount, @"Invalid vertex index");
    if (_vertexIsLocked[index]) return;
    _vertex[index].color.r += adjustment.red;
    _vertex[index].color.g += adjustment.green;
    _vertex[index].color.b += adjustment.blue;
    _dirty = YES;
}

// -----------------------------------------------------------------------
// resetters (haha)

- (void)resetVertex:(NSUInteger)index
{
    NSAssert(index < _vertexCount, @"Invalid vertex index");
    _vertex[index].position = _originalVertex[index].position;
}

- (void)resetTextureCoordinate:(NSUInteger)index
{
    NSAssert(index < _vertexCount, @"Invalid vertex index");
    _vertex[index].texCoord1 = _originalVertex[index].texCoord1;
}

- (void)resetColor:(NSUInteger)index
{
    NSAssert(index < _vertexCount, @"Invalid vertex index");
    _vertex[index].color = _originalVertex[index].color;
}

// -----------------------------------------------------------------------

- (float)vertexDistance:(NSUInteger)indexA indexB:(NSUInteger)indexB
{
    NSAssert(indexA < _vertexCount, @"Invalid vertex index");
    NSAssert(indexB < _vertexCount, @"Invalid vertex index");
    return ccpDistance((CGPoint){_vertex[indexA].position.x, _vertex[indexA].position.y},
                       (CGPoint){_vertex[indexB].position.x, _vertex[indexB].position.y});
}

// -----------------------------------------------------------------------

- (void)lock:(NSUInteger)index
{
    NSAssert(index < _vertexCount, @"Invalid vertex index");
    _vertexIsLocked[index] = YES;
}

// -----------------------------------------------------------------------

- (void)unLock:(NSUInteger)index
{
    NSAssert(index < _vertexCount, @"Invalid vertex index");
    _vertexIsLocked[index] = NO;
}

// -----------------------------------------------------------------------

- (BOOL)isLocked:(NSUInteger)index
{
    NSAssert(index < _vertexCount, @"Invalid vertex index");
    return _vertexIsLocked[index];
}

// -----------------------------------------------------------------------

@end
