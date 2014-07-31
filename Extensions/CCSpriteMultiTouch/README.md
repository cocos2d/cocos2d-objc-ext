CCSpriteMultiTouch
==================

Type of class  : Descendant of CCSprite
Uses extension : [NONE]

A sprite, capable of handling multitouch. The sprite can calculate movement, rotation and scale.

To enable drag, scale and rotation, set the properties touchCountForDrag, touchCountForScale and touchCountForRotate, to something different than zero. Override the methods touchDrag, touchScale and touchRotate, to perform custom operations.  

Remember to set multitouchEnabled for the node, otherwise only first touch will be accepted.

The #define CCSpriteMultiTouchMaxTouches, defines the maximum number of touches, accepted on the sprite (default 3)

OBS!!
=====  
Dragging for now only supports CCPositionTypePoints