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

#import "CCDictionary.h"

//----------------------------------------------------------------------

const int CCDictionaryInvalidIndex              = 0xba5eba11;
const NSString *CCDictionaryNameKey             = @"_dictionary_name";

//----------------------------------------------------------------------

@implementation NSDictionary (CCDictionary)

//----------------------------------------------------------------------

+ (instancetype)dictionaryWithPlist:(NSString *)filename
{
    return([[self alloc] initWithPlist:filename key:nil]);
}

//----------------------------------------------------------------------

+ (instancetype)dictionaryWithPlist:(NSString *)filename key:(NSString *)key
{
    return([[self alloc] initWithPlist:filename key:key]);
}

//----------------------------------------------------------------------

+ (instancetype)dictionaryWithDictionary:(NSDictionary *)dict
{
    return([[self alloc] initWithDictionary:dict key:nil]);
}

//----------------------------------------------------------------------

+ (instancetype)dictionaryWithDictionary:(NSDictionary *)dict key:(NSString *)key
{
    return([[self alloc] initWithDictionary:dict key:key]);
}

//----------------------------------------------------------------------

- (instancetype)initWithPlist:(NSString *)filename key:(NSString *)key
{
    NSMutableDictionary* fullDict;

    @try
    {
        // initialize
        // load the full dictionary into fullDict
#if GAME_DEVELOPER_SUPPORT == 1
        NSString* fullFilename;
        NSString* documentsPath =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        fullFilename = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:filename];
        fullDict = [NSMutableDictionary dictionaryWithContentsOfFile:fullFilename];
        // check if file exists in documents folder
        // any entry present in the documents folder, should be added / overwritten
        fullFilename = [documentsPath stringByAppendingPathComponent:filename];
        [fullDict addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:fullFilename]];
#else
        fullDict = [NSMutableDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:filename]];
#endif
        // check if only a part of the dictionary should be loaded
        if (key != nil)
        {
            // if valid default, load defaults first
            NSMutableDictionary* tempDict = [NSMutableDictionary dictionary];
            NSString* defaultKey = [self defaultKey:key];
            if (defaultKey != nil) [tempDict addEntriesFromDictionary:[fullDict objectForKey:defaultKey]];
            [tempDict addEntriesFromDictionary:[fullDict objectForKey:key]];
            [tempDict setObject:key forKey:CCDictionaryNameKey];
            self = [self initWithDictionary:tempDict];
        }
        else
        {
            // full dictionary should be loaded
            self = [self initWithDictionary:fullDict];
        }
        // done
        return(self);
    }
    @catch (NSException* exception)
    {
        return(nil);
    }
}

//----------------------------------------------------------------------

- (instancetype)initWithDictionary:(NSDictionary *)dict key:(NSString *)key
{
    // initialize
    // check if only a part of the dictionary should be loaded
    @try
    {
        if (key != nil)
        {
            NSMutableDictionary* tempDict = [NSMutableDictionary dictionary];
            if ([self defaultKey:key] != nil) [tempDict addEntriesFromDictionary:[dict objectForKey:[self defaultKey:key]]];
            [tempDict addEntriesFromDictionary:[dict objectForKey:key]];
            [tempDict setObject:key forKey:CCDictionaryNameKey];
            self = [self initWithDictionary:tempDict];
        }
        else
        {
            // full dictionary should be loaded
            self = [self initWithDictionary:dict];
        }
        // done
        return(self);
    }
    @catch (NSException* exception)
    {
        return(nil);
    }
}

//----------------------------------------------------------------------

- (NSString *)defaultKey:(NSString *)key
{
    if (key == nil) return(nil);
    NSRange range = [key rangeOfString:@"."];
    if (range.location != NSNotFound)
    {
        return([[key substringToIndex:range.location] stringByAppendingString:@".default"]);
    }
    return(nil);
}

//----------------------------------------------------------------------

- (instancetype)subDictionary:(NSString *)key
{
    return([NSDictionary dictionaryWithDictionary:self key:key]);
}

//----------------------------------------------------------------------
// read methods
//----------------------------------------------------------------------

- (id)readObject:(NSString *)key index:(int)index
{
    if (index == CCDictionaryInvalidIndex) return([self objectForKey:key]);
    return([self objectForKey:[key stringByAppendingFormat:@".%d", index]]);
}

- (id)readObject:(NSString *)key def:(id)def
{
    return([self readObject:key index:CCDictionaryInvalidIndex def:def]);
}

- (id)readObject:(NSString *)key index:(int)index def:(id)def
{
    // check for indexed object
    id result = [self objectForKey:[key stringByAppendingFormat:@".%d", index]];
    if (result == nil) return(def);
    
    return(result);
}

//----------------------------------------------------------------------

- (int)readInteger:(NSString *)key def:(int)def
{
    return([self readInteger:key index:CCDictionaryInvalidIndex def:def]);
}

- (int)readInteger:(NSString *)key index:(int)index def:(int)def
{
    id result = [self readObject:key index:index];
    if (result == nil) return(def);
    
    return([result intValue]);
}

// ----------------------------------------------------------

- (float)readFloat:(NSString  *)key def:(float)def
{
    return([self readFloat:key index:CCDictionaryInvalidIndex def:def]);
}

- (float)readFloat:(NSString *)key index:(int)index def:(float)def
{
    id result = [self objectForKey:key];
    if (result == nil) return(def);
    
 	return([result floatValue]);
}

// ----------------------------------------------------------

- (CGPoint)readPoint:(NSString *)key def:(CGPoint)def
{
    return([self readPoint:key index:CCDictionaryInvalidIndex def:def]);
}

- (CGPoint)readPoint:(NSString *)key index:(int)index def:(CGPoint)def
{
    id result = [self readObject:key index:index];
    if (result == nil) return(def);

    return(CGPointFromString(result));
}

// ----------------------------------------------------------

- (CGSize)readSize:(NSString *)key def:(CGSize)def
{
    return([self readSize:key index:CCDictionaryInvalidIndex def:def]);
}

- (CGSize)readSize:(NSString *)key index:(int)index def:(CGSize)def
{
    id result = [self readObject:key index:index];
    if (result == nil) return(def);

    return(CGSizeFromString(result));
}

// ----------------------------------------------------------

- (NSString *)readString:(NSString *)key def:(NSString *)def
{
    return([self readString:key index:CCDictionaryInvalidIndex def:def]);
}

- (NSString *)readString:(NSString *)key index:(int)index def:(NSString *)def
{
    NSString* result = [self readObject:key index:index];
    if (result == nil) return(def);
    if ([result isKindOfClass:[NSString class]] == NO) return(def);
    return(result);
}

// ----------------------------------------------------------

- (NSArray *)readArray:(NSString *)key def:(NSArray *)def
{
    return([self readArray:key index:CCDictionaryInvalidIndex def:def]);
}

- (NSArray *)readArray:(NSString *)key index:(int)index def:(NSArray *)def
{
    NSString* result = [self readObject:key index:index];
    if ((result == nil) || (result.length == 0)) return(def);
    return([[result stringByReplacingOccurrencesOfString:@" " withString:@""] componentsSeparatedByString:@";"]);
}

// ----------------------------------------------------------

- (CCColor *)readColor:(NSString *)key def:(CCColor *)def
{
    return([self readColor:key index:CCDictionaryInvalidIndex def:def]);
}

- (CCColor *)readColor:(NSString *)key index:(int)index def:(CCColor *)def
{
    NSString* result = [self readObject:key index:index];
    if (result == nil) return(def);

    NSArray* array;
    GLfloat color[4] = {def.red, def.green, def.blue, def.alpha};
    
    result = [result stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{ }"]];
    array = [result componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
    
    for (int index = 0; index < 4; index++)
    {
        if (array.count > index)
        {
            NSString *component = [NSString stringWithString:[array objectAtIndex:index]];
            if (![component isEqualToString:@""]) color[index] = [component floatValue];
        }
    }
    // done
    return([CCColor colorWithRed:color[0] green:color[1] blue:color[2] alpha:color[3]]);
}

// ----------------------------------------------------------

- (NSString *)readName
{
    return([self readString:(NSString *)CCDictionaryNameKey def:@"no_name"]);
}

// ----------------------------------------------------------

@end



































