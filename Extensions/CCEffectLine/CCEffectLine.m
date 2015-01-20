/*
 * cocos2d for iPhone: http://www.cocos2d-iphone.org
 *
 * Copyright (c) 2014-2015 Lars Birkemose
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

#import "CCEffectLine.h"
#import "CCEffectLineSegment.h"
#import "CCTexture_Private.h"

// -----------------------------------------------------------------------
// some defaults

const float CCEffectLineWidthStart = 32.0f;
const float CCEffectLineWidthEnd = 32.0f;
const float CCEffectLineSpeedDivider = 1000.0f;
const float CCEffectLineSpeedInterpolation = 0.25f;
const float CCEffectLineGranularity = 1.0f;
const float CCEffectLineBezierSegments = 1.0f;
const float CCEffectLineLifeDefault = 1.0f;
const NSUInteger CCEffectLineTextureCount = 8;

// -----------------------------------------------------------------------

GLKVector4 GLKVector4FromString(NSString *data)
{

    NSArray* array;
    float result[4] = {1.0f, 1.0f, 1.0, 1.0};
    
    data = [data stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{ }"]];
    array = [data componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
    
    for (int index = 0; index < 4; index++)
    {
        if (array.count > index)
        {
            NSString *component = [NSString stringWithString:[array objectAtIndex:index]];
            if (![component isEqualToString:@""]) result[index] = [component floatValue];
        }
    }
    // done
    return (GLKVector4){result[0], result[1], result[2], result[3]};
}

// -----------------------------------------------------------------------

@implementation CCEffectLine
{    
    // list of line points
    NSMutableArray *_pointList;             // list of points created
    BOOL _temporarySegment;                 // last segment is temporary
    CGPoint _startPosition;                 // line startposition
    CGPoint _lastPosition;                  // internally used last position
    CGPoint _endPosition;                   // line endposition
    CGPoint _lastDirection;
    
    NSTimeInterval _lastTime;

    NSMutableArray *_textureList;           // textures to blend through
    NSUInteger _textureIndex;               // current texture index in list
    NSUInteger _texture1;
    NSUInteger _texture2;                   // two current textures
    float _textureOffset;
    float _textureTime;
    BOOL _widthCheck;                       // line width should be checked
    BOOL _lineLocked;                       // line can not age
    float _speedWidth;
    
    // debug draw node
    CCDrawNode *_debugDraw;
}

// -----------------------------------------------------------------------

+ (instancetype)lineWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

// -----------------------------------------------------------------------

+ (instancetype)lineWithImageNamed:(NSString *)imageName
{
    return [[self alloc] initWithImageNamed:imageName];
}

// -----------------------------------------------------------------------

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [self initWithImageNamed:[dict objectForKey:@"image"]];
    
    // load setup from dictionary
    id data;
    
    data = [dict objectForKey:@"name"];
    if (data) self.name = data;
    
    data = [dict objectForKey:@"lineMode"];
    if (data) self.lineMode = [data integerValue];
    
    data = [dict objectForKey:@"widthMode"];
    if (data) self.widthMode = [data integerValue];
    
    data = [dict objectForKey:@"textureList"];
    if (data) [self addTextures:data];

    data = [dict objectForKey:@"textureMix"];
    if (data) self.textureMix = [data integerValue];

    data = [dict objectForKey:@"textureAnimation"];
    if (data) self.textureAnimation = [data integerValue];

    data = [dict objectForKey:@"textureScroll"];
    if (data) self.textureScroll = [data floatValue];

    data = [dict objectForKey:@"textureMixTime"];
    if (data) self.textureMixTime = [data floatValue];
    
    data = [dict objectForKey:@"textureCount"];
    if (data) self.textureCount = [data integerValue];
    
    data = [dict objectForKey:@"textureIndex"];
    if (data) self.textureIndex = [data integerValue];
    
    data = [dict objectForKey:@"textureScale"];
    if (data) self.textureScale = [data floatValue];

    data = [dict objectForKey:@"life"];
    if (data) self.life = [data floatValue];
    
    data = [dict objectForKey:@"autoRemove"];
    if (data) self.autoRemove = [data integerValue];
    
    data = [dict objectForKey:@"smooth"];
    if (data) self.smooth = [data integerValue];
    
    data = [dict objectForKey:@"speedMultiplyer"];
    if (data) self.speedMultiplyer = [data floatValue];
    
    data = [dict objectForKey:@"granularity"];
    if (data) self.granularity = [data floatValue];
    
    data = [dict objectForKey:@"drawLineStart"];
    if (data) self.drawLineStart = [data integerValue];
    
    data = [dict objectForKey:@"locked"];
    if (data) self.locked = [data integerValue];
    
    data = [dict objectForKey:@"drawLineEnd"];
    if (data) self.drawLineEnd = [data integerValue];
    
    data = [dict objectForKey:@"widthStart"];
    if (data) self.widthStart = [data floatValue];
    
    data = [dict objectForKey:@"widthEnd"];
    if (data) self.widthEnd = [data floatValue];
    
    data = [dict objectForKey:@"width"];
    if (data)
    {
        self.widthStart = [data floatValue];
        self.widthEnd = [data floatValue];
    }
    
    data = [dict objectForKey:@"wind"];
    if (data) _wind = CGPointFromString(data);

    data = [dict objectForKey:@"gravity"];
    if (data) _gravity = CGPointFromString(data);

    data = [dict objectForKey:@"colorStart"];
    if (data) _colorStart = GLKVector4FromString(data);

    data = [dict objectForKey:@"colorEnd"];
    if (data) _colorEnd = GLKVector4FromString(data);

    // done
    return self;
}

// -----------------------------------------------------------------------

- (instancetype)initWithImageNamed:(NSString *)imageName
{
    self = [super initWithImageNamed:imageName];
    self.anchorPoint = CGPointZero;
    
    // create point list
    _pointList = [NSMutableArray array];
    
    // reset properties to defaults
    _life = CCEffectLineLifeDefault;
    _autoRemove = NO;
    _smooth = NO;
    _speedMultiplyer = 1.0f;
    _granularity = CCEffectLineGranularity;
    _lineMode = CCEffectLineModePointToPoint;
    _widthMode = CCEffectLineWidthSimple;
    _drawLineStart = YES;
    _drawLineEnd = YES;
    _widthStart = CCEffectLineWidthStart;
    _widthEnd = CCEffectLineWidthEnd;
    _lineLocked = NO;
    _debugMode = CCEffectLineDebugNone;
    _colorStart = (GLKVector4){1.0, 1.0, 1.0, 1.0};
    _colorEnd = (GLKVector4){1.0, 1.0, 1.0, 0.0};
    _wind = CGPointZero;
    _gravity = CGPointZero;
    _locked = NO;
    
    // texture properties
    _textureList = [NSMutableArray array];
    [self clearTextures];
    _textureIndex = 0;
    _textureCount = CCEffectLineTextureCount;
    _textureScale = 1.0f;
    _textureScroll = 1.0f;
    _textureOffset = 0.0f;
    _textureMixTime = 1.0f;

    // reset helper properties
    _lastTime = 0;
    _lastPosition = CGPointZero;
    _contentScale = [CCDirector sharedDirector].contentScaleFactor;
    _textureGain = 1.0f / [CCDirector sharedDirector].viewSize.width;
    _expired = NO;
    _widthCheck = NO;
    _drawSpeed = 0;
    _speedWidth = CCEffectLineWidthStart;
    
    // Not currently added to Cocos2D
    self.blendMode = [CCBlendMode blendModeWithOptions:
                      @{
                        CCBlendFuncSrcColor: @(GL_SRC_ALPHA),
                        CCBlendFuncDstColor: @(GL_ONE),
                        }];

    // used for debug draw
    _debugDraw = [CCDrawNode node];
    [self addChild:_debugDraw];
    
    // load custom shader
    NSString *vertexPath = [[CCFileUtils sharedFileUtils] fullPathForFilename:@"CCEffectLine.vert"];
    NSString *vertexSource = [NSString stringWithContentsOfFile:vertexPath encoding:NSUTF8StringEncoding error:nil];

    NSString *fragmentPath = [[CCFileUtils sharedFileUtils] fullPathForFilename:@"CCEffectLine.frag"];
    NSString *fragmentSource = [NSString stringWithContentsOfFile:fragmentPath encoding:NSUTF8StringEncoding error:nil];
    
    self.shader = [[CCShader alloc] initWithVertexShaderSource:vertexSource fragmentShaderSource:fragmentSource];
    
    // done
    return self;
}

// -----------------------------------------------------------------------

- (void)addEffectLineSegmentWithDictionary:(CGPoint)pos
                                 direction:(CGPoint)direction
                             textureOffset:(float)offset
                                  startAge:(float)startAge
{
    float widthStart;
    float widthEnd;

    // adjust direction of last point, according to new point
    if (_pointList.count > 1)
    {
        CCEffectLineSegment *p0 = [_pointList objectAtIndex:_pointList.count - 2];
        CCEffectLineSegment *p1 = [_pointList objectAtIndex:_pointList.count - 1];
        
        CGPoint d0 = ccpNormalize(ccpSub(p1.position, p0.position));
        CGPoint d1 = ccpNormalize(ccpSub(pos, p1.position));
        
        p1.direction = ccpAdd(d0, d1);
    }
    
    // check for speed mode
    if (_widthMode == CCEffectLineWidthSpeed)
    {
        // calculate new speed width
        float newWidth = _widthStart + ((_widthEnd - _widthStart) * _drawSpeed / 10.0);
        _speedWidth += ((newWidth - _speedWidth) * 0.01);
        if (_widthEnd > _widthStart)
        {
            _speedWidth = clampf(_speedWidth, _widthStart, _widthEnd);
        }
        else
        {
            _speedWidth = clampf(_speedWidth, _widthEnd, _widthStart);
        
        }
        
        widthStart = _speedWidth;
        widthEnd = widthStart;
    }
    else
    {
        widthStart = _widthStart;
        widthEnd = _widthEnd;
    }

    // if line is locked, no age information
    // create the point
    [_pointList addObject:[CCEffectLineSegment segmentWithDictionary:
                           @{
                             // basic setups
                             @"position"            : [NSValue valueWithCGPoint:pos],
                             @"direction"           : [NSValue valueWithCGPoint:direction],
                             @"wind"                : [NSValue valueWithCGPoint:_wind],
                             @"gravity"             : [NSValue valueWithCGPoint:_gravity],
                             @"life"                : @(_life),
                             @"startAge"            : @(startAge),
                             @"textureOffset"       : @(offset),
                             @"widthStart"          : @(widthStart),
                             @"widthEnd"            : @(widthEnd),
                             @"colorStart"          : [NSValue valueWithGLKVector4:_colorStart],
                             @"colorEnd"            : [NSValue valueWithGLKVector4:_colorEnd],
                             }]];
}

- (void)addEffectLineSegment:(CGPoint)pos
                 direction:(CGPoint)direction
             textureOffset:(float)offset
                  startAge:(float)startAge
{
    
    CCEffectLineSegment *lastPoint = [_pointList lastObject];
    if ((_textureAnimation == CCEffectLineAnimationClamped) && (lastPoint) && (lastPoint.textureOffset >= 1.0))
        return;
    
    // if only one segment added previously
    if (_pointList.count == 1)
    {
        // make sure first point points towards second
        lastPoint.direction = ccpNormalize(ccpSub(pos, lastPoint.position));
        
        // if smooth line start, check if next point is too far away
        if ((_drawLineStart) && (_lineMode != CCEffectLineModeFreeHand))
        {
            float distance = ccpDistance(lastPoint.position, pos);
            if (distance > _widthStart * 1.2)
            {
                // add new point
                CGPoint pos = ccpAdd(lastPoint.position, ccpMult(lastPoint.direction, _widthStart));
                [self addEffectLineSegmentWithDictionary:pos direction:direction textureOffset:offset startAge:startAge];
            }
        }
    }
    
    // add new point
    [self addEffectLineSegmentWithDictionary:pos direction:direction textureOffset:offset startAge:startAge];
    
    _widthCheck = YES;
}

// -----------------------------------------------------------------------

- (void)start:(CGPoint)pos timestamp:(NSTimeInterval)timestamp
{
    // check if line has already been started
    NSAssert(_pointList.count == 0, @"Line already started");
    
    // start line
    _startPosition = pos;
    _lastPosition = pos;
    _lastTime = timestamp;
    _temporarySegment = NO;
    _textureTime = 0.0f;
    _lineLocked = _locked;
    _speedWidth = _widthStart;
}

// -----------------------------------------------------------------------

- (BOOL)add:(CGPoint)pos timestamp:(NSTimeInterval)timestamp
{
    NSAssert(_lastTime != 0, @"Line has not been started");
    
    // calculate speed
    float newSpeed = ccpDistance(pos, _lastPosition) / (timestamp - _lastTime) / CCEffectLineSpeedDivider;
    _drawSpeed += (newSpeed - _drawSpeed) * CCEffectLineSpeedInterpolation;
    
    if (_lineMode == CCEffectLineModeStraight)
    {
        // calculate a new line from start to end
        [self calculateStraightLine:_startPosition end:pos];
        return YES;
    }
    
    // line, following the points added
    // some pre-calculations
    CGPoint direction = ccpSub(pos, _lastPosition);
    float distance = ccpDistance(_lastPosition, pos);
    
    // if no point has been previously added, create start point, and create a last direction identical to the current
    if (_pointList.count == 0)
    {
        float textureStart = (_textureAnimation == CCEffectLineAnimationClamped) ? 0 : CCRANDOM_0_1();
        // create line
        [self addEffectLineSegment:_lastPosition
                       direction:direction
                   textureOffset:textureStart
                        startAge:0];
        _lastDirection = direction;
    }

    // test if temporary end segment, and remove it
    if ((_lineMode == CCEffectLineModeFreeHand) && _temporarySegment)
    {
        // remove temporary segment
        [_pointList removeLastObject];
        _temporarySegment = NO;
    }

    // get start and end pos of smooth line
    CCEffectLineSegment *lastPoint = [_pointList lastObject];
    CGPoint lastPos = lastPoint.position;
    float textureOffset = lastPoint.textureOffset;
    
    // check if criterias for creating a line segment is met
    if (distance <= (1.0f / _granularity * _widthStart / _contentScale))
    {
        if (_lineMode == CCEffectLineModeFreeHand)
        {
            // create a temporary line segment
            float distance = ccpDistance(lastPos, pos);
            textureOffset += distance * _textureGain / _textureScale;
            
            // add a simple straight line segment
            [self addEffectLineSegment:pos
                           direction:direction
                       textureOffset:textureOffset
                            startAge:0];
            _temporarySegment = YES;
        }
        return NO;
    }
    
    // calculate number of segments
    NSInteger numberOfSegments = 1 + (distance / ((1.0f / _granularity) * _widthStart / (float)CCEffectLineBezierSegments));
    
    // check if smooth
    if ((_smooth) && (numberOfSegments > 1) && (_pointList.count >= 2))
    {
        // add a smooth piece of line segment
        float step = 1.0 / (float)numberOfSegments;
        float progress = step;
        
        CGPoint startPos = lastPos;
        CGPoint endPos = ccpMidpoint(_lastPosition, pos);
        
        // current start end endpos
        CGPoint currentStart = startPos;
        CGPoint currentEnd;
        
        // time interval for each segment
        // used to add a sleep timing, so that it appears like the segments are created liniear, and not in one chunk
        float timeInterval = (timestamp - _lastTime) / numberOfSegments;
        
        for (NSInteger count = 0; count < numberOfSegments; count ++)
        {
            // inverse progress
            float invProgress = 1.0 - progress;
            
            // calculate new end position
            CGPoint p0 = ccpMult(startPos, invProgress * invProgress);
            CGPoint p1 = ccpMult(_lastPosition, 2.0f * progress * invProgress);
            CGPoint p2 = ccpMult(endPos, progress * progress);
            currentEnd = ccpAdd(ccpAdd(p0, p1), p2);
            
            // calculate new texture offset
            CGPoint newPos = ccpMidpoint(currentStart, currentEnd);
            float distance = ccpDistance(lastPos, newPos);
            textureOffset +=  distance * _textureGain / _textureScale;

            // create line
            // NOTE
            // the age of the last line is used as offset, because touch timing and line update might be out of sync.
            // As the timings are very accurate, an extra call update before the touch is handled, will result in inaccurate decay of the line
            [self addEffectLineSegment:newPos
                           direction:ccpSub(currentEnd, currentStart)
                       textureOffset:textureOffset
                            startAge:lastPoint.age - (timeInterval * count)];

            // update
            lastPos = newPos;
            currentStart = currentEnd;
            progress += step;
        }
    }
    else
    {
        // TODO calculate new texture offset
        float distance = ccpDistance(lastPoint.position, ccpMidpoint(_lastPosition, pos));
        textureOffset = lastPoint.textureOffset + (distance * _textureGain / _textureScale);

        // add a simple straight line segment
        [self addEffectLineSegment:ccpMidpoint(_lastPosition, pos)
                       direction:direction
                   textureOffset:textureOffset
                        startAge:lastPoint.age];
    }
    
    // update last data
    _lastPosition = pos;
    _lastDirection = direction;
    _lastTime = timestamp;

    // done
    return YES;
}

// -----------------------------------------------------------------------

- (void)end:(CGPoint)pos timestamp:(NSTimeInterval)timestamp
{
    NSAssert(_lastTime != 0, @"Line has not been started");
    
    _lineLocked = NO;
    
    // straight lines just expire when ended
    if (_lineMode == CCEffectLineModeStraight) return;
    
    if ((_lineMode == CCEffectLineModeFreeHand) && _temporarySegment)
    {
        // remove temporary segment
        [_pointList removeLastObject];
        _temporarySegment = NO;
    }

    // get start and end pos of smooth line
    CCEffectLineSegment *lastPoint = [_pointList lastObject];

    // TODO calculate new texture offset
    float distance = ccpDistance(lastPoint.position, pos);
    float textureOffset = lastPoint.textureOffset;
    
    // check line end
    if ((_drawLineEnd) && (distance > lastPoint.width * 1.2))
    {
        CGPoint direction = ccpNormalize(ccpSub(pos, lastPoint.position));
        float length = distance - lastPoint.width;
        textureOffset += length * _textureGain / _textureScale;
        // add new point
        [self addEffectLineSegment:ccpAdd(lastPoint.position, ccpMult(direction, length))
                       direction:direction
                   textureOffset:textureOffset
                        startAge:lastPoint.age];
    }
    
    // add final line segment
    [self addEffectLineSegment:pos
                   direction:ccpSub(pos, lastPoint.position)
               textureOffset:textureOffset + (ccpDistance(lastPoint.position, pos) * _textureGain / _textureScale)
                    startAge:lastPoint.age];
}

// -----------------------------------------------------------------------

- (void)clear
{
    [_pointList removeAllObjects];
    _expired = YES;
}

// -----------------------------------------------------------------------

- (void)calculateStraightLine:(CGPoint)start end:(CGPoint)end
{
    // clear list
    [_pointList removeAllObjects];
    
    // preset some stuff
    float distance = ccpDistance(start, end);
    CGPoint direction = ccpSub(end, start);
    NSInteger segments = 1 + (distance / _widthStart * _granularity);
    direction = ccpMult(direction, 1.0f / (float)segments);
    float textureOffset = 0;
    distance = ccpLength(direction);
    _widthCheck = YES;
    
    for (NSInteger count = 0; count <= segments; count ++)
    {
        // create the line
        [ self addEffectLineSegmentWithDictionary:start direction:direction textureOffset:textureOffset startAge:0];
        // update data for next segment
        textureOffset += (distance * _textureGain / _textureScale);
        start = ccpAdd(start, direction);
        
    }
}

// -----------------------------------------------------------------------
// check various inconsistens states regarding points

- (void)validatePoints:(CCTime)dt
{
    // only two or more points can be checked
    if (_pointList.count <= 2) return;
    
    // check that no points are crossing other points
    for (NSInteger index = 0; index < _pointList.count - 1; index ++)
    {
        float s, t;
        CCEffectLineSegment *p0 = [_pointList objectAtIndex:index];
        CCEffectLineSegment *p1 = [_pointList objectAtIndex:index + 1];
        
        CGPoint pos;
        
        if (ccpLineIntersect(p0.posA, p0.posB, p1.posA, p1.posB, &s, &t) && (s > 0) && (s < 1))
        {
            if (s < 0.5)
            {
                pos = ccpMidpoint(p0.posA, p1.posA);
                [p0 setPosA:pos];
                [p1 setPosA:pos];
            }
            else
            {
                pos = ccpMidpoint(p0.posB, p1.posB);
                [p0 setPosB:pos];
                [p1 setPosB:pos];
            }
        }
    }
    
    // check for barrel line
    if ((_widthMode == CCEffectLineWidthBarrel) && (_widthCheck))
    {
        float lineLength = self.length;
        float currentLength = 0;
        CCEffectLineSegment *last = [_pointList firstObject];
        for (CCEffectLineSegment *point in _pointList)
        {
            currentLength += ccpDistance(point.position, last.position);
            last = point;
            float progress = currentLength / lineLength;
            point.width = _widthStart + (sinf(progress * M_PI) * (_widthEnd - _widthStart));
        }
        _widthCheck = NO;
    }
    
    // other checks ?





}

// -----------------------------------------------------------------------

- (void)clearTextures
{
    [_textureList removeAllObjects];
    _texture1 = 0;
    _texture2 = 0;
}

// -----------------------------------------------------------------------

- (void)addTextures:(NSArray *)list
{
    [_textureList addObjectsFromArray:list];
}

- (void)setTextureCount:(NSUInteger)textureCount
{
    NSAssert(textureCount > 0, @"Texture count must be greater than 0");
    _textureCount = textureCount;
    _textureIndex = _textureIndex % _textureCount;
    for (NSNumber *number in _textureList)
    {
        NSInteger texture = [number integerValue];
        NSAssert((texture >= 0) && (texture < _textureCount), @"Invalid texture");
    }
}

- (void)setGranularity:(float)granularity
{
    _granularity = clampf(granularity, 0.1f, 2.0f);
}

- (void)setTextureScale:(float)textureScale
{
    _textureScale = clampf(textureScale, 0.01f, 100.0f);
}

- (void)setLineMode:(CCEffectLineMode)lineMode
{
    NSAssert((lineMode >= CCEffectLineModePointToPoint) && (lineMode <= CCEffectLineModeStraight), @"Invalid line type");
    _lineMode = lineMode;
}

- (void)setWidthMode:(CCEffectLineWidth)widthMode
{
    NSAssert((widthMode >= CCEffectLineWidthSimple) && (widthMode <= CCEffectLineWidthBarrel), @"Invalid width type");
    _widthMode = widthMode;
}

- (float)length
{
    float result = 0;
    
    CCEffectLineSegment *last = nil;
    for (CCEffectLineSegment *next in _pointList)
    {
        if (last)
        {
            result += ccpDistance(last.position, next.position);
        }
        last = next;
    }
    return result;
}

// -----------------------------------------------------------------------

- (void)update:(CCTime)dt
{
    // Update all line segments
    // TODO: implement different lines modes ... 
    dt *= _speedMultiplyer;

    // set up texture mixing
    // if not enough textures, force mix mode none (maintain mix mode setting)
    CCEffectLineTexture mixMode = _textureMix;
    if (_textureList.count < 2) mixMode = CCEffectLineTextureSimple;
    // some default values and calculations
    float mix = 1.0f;
    _textureTime += dt;
    // set mode
    switch (mixMode) {
        case CCEffectLineTextureSimple:
            _texture1 = _textureIndex;
            _texture2 = _textureIndex;
            break;
            
        case CCEffectLineTextureBlendSinus:
        case CCEffectLineTextureBlendLinear:
            if (_textureTime >= _textureMixTime)
            {
                _textureIndex = (_textureIndex + 1) % _textureList.count;
                _textureTime -= _textureMixTime;
            }
            _texture1 = [[_textureList objectAtIndex:_textureIndex] integerValue];
            _texture2 = [[_textureList objectAtIndex:(_textureIndex + 1) % _textureList.count] integerValue];
            float mixProgress = clampf(_textureTime / _textureMixTime, 0.0f, 1.0f);
            if (_textureMix == CCEffectLineTextureBlendSinus) mix = (sinf(M_PI_2 + (M_PI * mixProgress)) + 1.0) * 0.5;
            else if (_textureMix == CCEffectLineTextureBlendLinear) mix = 1.0 - mixProgress;
            break;
            
        case CCEffectLineTextureRandom:
            if (_textureTime >= _textureMixTime)
            {
                _textureTime -= _textureMixTime;
                _texture1 = [[_textureList objectAtIndex:arc4random() % _textureList.count] integerValue];
                _texture2 = _texture1;
            }
            break;
    }
    // set the texture uniforms
    self.shaderUniforms[@"u_textureMix"] = [NSNumber numberWithFloat:mix];
    self.shaderUniforms[@"u_textureMixEnabled"] = [NSNumber numberWithBool:_texture1 != _texture2];
    
    // set texture scrolling
    _textureOffset -= (_textureScroll * dt);
    
    // textures done
    
    // update point segment and remove when expires
    for (NSInteger index = _pointList.count - 1; index >= 0; index --)
    {
        CCEffectLineSegment *point = [_pointList objectAtIndex:index];
        [point update:(_lineLocked) ? 0.0f : dt];
        
        // if (point.hasChanged) changed = YES;
        if (point.expired)
        {
            [_pointList removeObjectAtIndex:index];
            _expired = (_pointList.count == 0);
        }
    }
    // check if any points has changed
    /* if (changed) */ [self validatePoints:dt];
    //
    if (_expired && _autoRemove)
    {
        [self removeFromParentAndCleanup:YES];
    }
}

// -----------------------------------------------------------------------

- (void)draw:(CCRenderer *)renderer transform:(const GLKMatrix4 *)transform
{
    [_debugDraw clear];

    if (_debugMode != CCEffectLineDebugNone)
    {
        // show line segments with lines representing width
        
        // draw line
        for (CCEffectLineSegment *point in _pointList)
        {
            CGPoint p = ccpLerp(point.posA, point.posB, 0.25);
            [_debugDraw drawSegmentFrom:point.posA to:p radius:1 color:[CCColor redColor]];
            [_debugDraw drawSegmentFrom:p to:point.posB radius:1 color:[CCColor whiteColor]];
        }
    }

    if (_debugMode == CCEffectLineDebugSegments) return;
    if (_pointList.count < 2) return;
    
    // set texture parameters to repeat texture
    ccTexParams params = {GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT};
    if (_textureAnimation == CCEffectLineAnimationClamped) params = (ccTexParams){GL_LINEAR, GL_LINEAR, GL_CLAMP_TO_EDGE, GL_CLAMP_TO_EDGE};
    [self.texture setTexParameters:&params];

    // calculate vertice- and triangle count
    NSUInteger triangleCount = 2 * (_pointList.count - 1);
    NSUInteger vertexCount = 2 * _pointList.count;
    
    CCRenderBuffer buffer = [renderer enqueueTriangles:triangleCount andVertexes:vertexCount withState:self.renderState globalSortOrder:0];
    CCVertex vertex;
    
    CCEffectLineSegment *lastSegment = nil;
    CCEffectLineSegment *currentSegment = nil;
    int vertexIndex = 0;
    int triangleIndex = 0;
    
    float interval = 1.0f / (float)_textureCount;
    CGPoint offset1 = ccp(0, interval * (float)_texture1);
    CGPoint offset2 = ccp(0, interval * (float)_texture2);
    
    // set texture animation
    switch (_textureAnimation) {
        case CCEffectLineAnimationNone:
        default:
            break;
            
        case CCEffectLineAnimationRandom:
            offset1.x = CCRANDOM_0_1();
            offset2.x = CCRANDOM_0_1();
            break;
            
        case CCEffectLineAnimationScroll:
            offset1.x = _textureOffset;
            offset2.x = _textureOffset;
            break;
    }
    
    // create line
    // TODO remove empty triangles
    for (NSInteger index = 0; index < _pointList.count; index ++)
    {
        currentSegment = [_pointList objectAtIndex:index];
        GLKVector4 color = currentSegment.color;
        
        if ((index == 0) && (_drawLineStart)) color.a = 0.0;
        if ((index == _pointList.count - 1) && (_drawLineEnd)) color.a = 0.0;
        
        vertex.position = (GLKVector4){currentSegment.posA.x, currentSegment.posA.y, 0, 1};
        vertex.color = color;
        
        //
        vertex.texCoord1 = (GLKVector2){currentSegment.textureOffset + offset1.x, offset1.y};
        vertex.texCoord2 = (GLKVector2){currentSegment.textureOffset + offset2.x, offset2.y};
        
        CCRenderBufferSetVertex(buffer, vertexIndex, CCVertexApplyTransform(vertex, transform));
        vertexIndex ++;

        vertex.position = (GLKVector4){currentSegment.posB.x, currentSegment.posB.y, 0, 1};
        vertex.color = color;
        //
        vertex.texCoord1 = (GLKVector2){currentSegment.textureOffset + offset1.x, offset1.y + interval};
        vertex.texCoord2 = (GLKVector2){currentSegment.textureOffset + offset2.x, offset2.y + interval};
        
        CCRenderBufferSetVertex(buffer, vertexIndex, CCVertexApplyTransform(vertex, transform));
        vertexIndex ++;
        
        if (lastSegment != nil)
        {
            CCRenderBufferSetTriangle(buffer, triangleIndex, vertexIndex - 3, vertexIndex - 4, vertexIndex - 2);
            triangleIndex ++;
            CCRenderBufferSetTriangle(buffer, triangleIndex, vertexIndex - 3, vertexIndex - 2, vertexIndex - 1);
            triangleIndex ++;
        }
        
        lastSegment = currentSegment;
    }
    
}

// -----------------------------------------------------------------------

@end
