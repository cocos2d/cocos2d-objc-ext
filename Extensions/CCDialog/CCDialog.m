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

#import "CCDialog.h"

// -----------------------------------------------------------------

@implementation CCAlertAction

@end

// -----------------------------------------------------------------

@implementation CCDialog
{
    UIAlertController *_dialog;
    SEL _selectorDialogClosing;
    __weak id _targetDialogClosing;
}

// -----------------------------------------------------------------

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message buttons:(NSString *)button, ... NS_REQUIRES_NIL_TERMINATION;
{
    self = [super init];

    // create the basic view
    _dialog = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // loop through the buttons provided
    va_list args;
    va_start(args, button);
    NSInteger index = 0;
    for (NSString *arg = button; arg != nil; arg = va_arg(args, NSString *))
    {
        CCAlertAction* action = [CCAlertAction
                                 actionWithTitle:arg
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     // Button was pressed, call user code
                                     [self runSelectorOnTarget:_targetDialogClosing selector:_selectorDialogClosing object:action];
                                     // Exit dialog
                                     [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
                                 }];
        action.exitCode = index;
        index ++;
        [_dialog addAction:action];
    }
    va_end(args);
    
    return self;
}

// -----------------------------------------------------------------

- (void)showModal
{
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:_dialog animated:YES completion:nil];
}

// -----------------------------------------------------------------
// Helper function which supresses warnings when calling performSelector

- (void)runSelectorOnTarget:(id)target selector:(SEL)selector object:(id)object
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [target performSelector:selector withObject:object];
#pragma clang diagnostic pop
}

// -----------------------------------------------------------------

- (void)onDialogClosing:(id)target selector:(SEL)selector
{
    NSAssert([target respondsToSelector:selector], @"%@ not found in %@", NSStringFromSelector(selector), [target class]);
    _targetDialogClosing = target;
    _selectorDialogClosing = selector;
}

// -----------------------------------------------------------------

@end





