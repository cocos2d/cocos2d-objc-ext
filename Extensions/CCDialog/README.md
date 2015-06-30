CCDialog
========

Type of class  : Descendant of NSObject  
Uses extension : [NONE]  
Requirements   : iOS8

A class, capable of showing a default UI-Kit dialog box.

Example
=======

```
    // In some other function
    
    CCDialog *dialog = [[CCDialog alloc] initWithTitle:@"Cocos2D-ObjC" 
                                               message:@"Hello World" 
                                               buttons:@"Cancel", @"Ok", nil];
    [dialog onDialogClosing:self selector:@selector(dialogClose:)];
    [dialog showModal];
}

- (void)dialogClose:(id)sender
{
    CCLOG(@"Dialog closed with exit code %d", [(CCAlertAction *)sender exitCode]);
}
```  


