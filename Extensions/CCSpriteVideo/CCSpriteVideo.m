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

#import "CCSpriteVideo.h"
#import "CCTexture_Private.h"

#define VIDEO_TIME_RESOLUTION 100

// -----------------------------------------------------------------------

@implementation CCSpriteVideo
{
    AVAsset *_asset;
    AVAssetTrack *_track;
    AVAssetReader *_reader;
    AVAssetReaderTrackOutput *_output;
    CGPoint _videoScale;
    BOOL _loop;
}

// -----------------------------------------------------------------------

+ (instancetype)spriteWithVideoNamed:(NSString *)videoName
{
    return [[self alloc] initWithVideoNamed:videoName];
}

// -----------------------------------------------------------------------

- (instancetype)initWithVideoNamed:(NSString *)videoName
{
    // create a white texture to use as background
    char textureData[4];
    memset(textureData, 255, 4);
    CCTexture *texture = [[CCTexture alloc] initWithData:textureData
                                             pixelFormat:CCTexturePixelFormat_RGBA8888
                                              pixelsWide:1
                                              pixelsHigh:1
                                     contentSizeInPixels:(CGSize){1, 1}
                                            contentScale:1];
    self = [super initWithTexture:texture];
    
    // check if file exists, otherwise try bundle
    if (![[NSFileManager defaultManager] fileExistsAtPath:videoName])
        videoName = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:videoName];
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:videoName], @"File: %@ Not Found", [videoName lastPathComponent]);

    // load video asset
    _asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:videoName]];
    // get video track
    _track = [[_asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    // set internal data
    _videoSize = _track.naturalSize;
    self.scale = 1.0;
    _videoLength = CMTimeGetSeconds(_track.timeRange.duration);
    _videoFrameRate = _track.nominalFrameRate;

    // default paused
    _isPlaying = NO;

    return self;
}

// -----------------------------------------------------------------------
// override scale functionality
// since the original sprite is 1*1 pixel, scale is equal to width*height

- (float)scale {
    NSAssert(_videoScale.x == _videoScale.y, @"No idea what scale to return");
    return _videoScale.x;
}

- (void)setScale:(float)scale
{
    _videoScale.x = scale;
    _videoScale.y = scale;
    super.scaleX = _videoSize.width * _videoScale.x;
    super.scaleY = -_videoSize.height * _videoScale.y;
}

- (float)scaleX { return _videoScale.x; }

- (void)setScaleX:(float)scaleX
{
    _videoScale.x = scaleX;
    super.scaleX = _videoSize.width * _videoScale.x;
}

- (float)scaleY { return _videoScale.y; }

- (void)setScaleY:(float)scaleY
{
    _videoScale.y = scaleY;
    super.scaleY = -_videoSize.height * _videoScale.y;
}

- (void)setVideoSize:(CGSize)videoSize
{
    _videoSize = videoSize;
    super.scaleX = _videoSize.width * _videoScale.x;
    super.scaleY = -_videoSize.height * _videoScale.y;
}

// -----------------------------------------------------------------------

- (void)playFromTime:(NSTimeInterval)time loop:(BOOL)loop
{
    // if already playing, stop
    if (_isPlaying) [self stop];
    
    // create reader
    _reader = [AVAssetReader assetReaderWithAsset:_asset error:nil];
    // create output
    NSDictionary *settings = @{
                               (NSString *)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA),
                               // (NSString *)AVVideoQualityKey:@(0.6),
                               (NSString *)kCVPixelBufferWidthKey: @(_videoSize.width),
                               (NSString *)kCVPixelBufferHeightKey: @(_videoSize.height),
                               };
    _output = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:_track outputSettings:settings];
    [_reader addOutput:_output];
    
    // start the player at requested time
    _reader.timeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(time, VIDEO_TIME_RESOLUTION), CMTimeMakeWithSeconds(_videoLength - time, VIDEO_TIME_RESOLUTION));
    [_reader startReading];
    
    //
    _loop = loop;
    _isPlaying = YES;
    [self schedule:@selector(nextFrame:) interval:1.0 / _videoFrameRate];
    // greb first frame immediately
    [self nextFrame:0];
}

// -----------------------------------------------------------------------

- (void)stop
{
    if (!_isPlaying) return;
    
    // stop the player
    _isPlaying = NO;
    _reader = nil;
    [self unschedule:@selector(nextFrame:)];
}

// -----------------------------------------------------------------------

- (void)nextFrame:(NSTimeInterval)dt
{
    // the approach for grabbing images from a camera, is similar to this
    // in stead of starting a reader, and using copyNextSampleBuffer,
    //   nextFrame would be a callback, and image would be grabbed with CMSampleBufferGetImageBuffer

    // try to get a buffer
    CMSampleBufferRef buffer = [_output copyNextSampleBuffer];

    // if no buffer available, and looping, try restarting the player
    if (!buffer && _loop)
    {
        [self playFromTime:0 loop:YES];
        return;
    }
    
    // *******************
    // new frame available
    // *******************
    
    // get image
    CVImageBufferRef image = CMSampleBufferGetImageBuffer(buffer);

    // lock image buffer
    // this gives access to the raw BGRA data
    CVPixelBufferLockBaseAddress(image, 0);
    
    // bind the texture
    glBindTexture(GL_TEXTURE_2D, self.texture.name);
    
    // create texture
    void* data = CVPixelBufferGetBaseAddress(image);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)_videoSize.width, (GLsizei)_videoSize.height, 0, GL_BGRA, GL_UNSIGNED_BYTE, data);
    
    // unlock image buffer
    CVPixelBufferUnlockBaseAddress(image,0);

    // release original sample buffer
    CFRelease(buffer);
}

// -----------------------------------------------------------------------

@end


































