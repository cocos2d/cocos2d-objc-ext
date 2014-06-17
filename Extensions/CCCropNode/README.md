CCCropNode
==========

Type of class  : Descendant of CCNode

Uses extension : <NONE>

A node, capable of cropping graphics and/or touches, on a rectangular section of the screen. CCCropNode will crop any children added to it.

Has very little overhead, but will break any ongoing render batch.

The CCCropNode is simply added to the node hierarchy, and can  crop graphics or touches or both.
The CCCropNode will default use the child with the lowest Z value to crop by, but can manuelly be set to crop by any node.
The cropping area can only be a square, and can not be rotated.

Ex.

CCCropNode *crop = [CCCropNode node];  
crop.mode = CCCropModeTouchesAndGraphics;  
[parent addChild:crop];

Dialog *myDialog = [Dialog dialogWith....];
[crop addChild:myDialog z:1];
// at this point, the crop node will use myDialog to crop by.

DialogOutLine *myOutline = [DialogOutLine outlineWithDialog:myDialog];
[crop addChild:myOutline z:0];
// crop will use myOutline to crop by, as myOutline is the lowest placed node

DialogOverlay *myOverlay = [DialogOverlay overlayWithDialog:myDialog];
[crop addChild:myOverlay];
// crop will still use myOutline

[crop setCropNode:myOutline];
//crop will now use myOutline to crop by, regardless of z order

The node which is used to crop by, should not be rotated.

