CCNodeTag
=========

Type of class  : Category to CCNode

Uses extension : <NONE>

Adds tags to CCNode.

While the official replacement for tag in CCNode, is NSString *name, there are rare cases (especially when porting V2 apps), where tag is useful. To use tags for CCNode, simply include this category into your project.

CCNodeTag only supports the "old V2" commands, and not ex. the new recursive search functionality.
