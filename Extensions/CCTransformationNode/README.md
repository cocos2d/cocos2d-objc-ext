CCTransformationNode
====================

Type of class  : Descendant of CCNode
Uses extension : <NONE>

A node, capable of adding 3D transformations to a scene.

Add the node to scene hierachy. All children added to the node, will be transformed according to the nodes transformation settings.

Note!

This node is NOT ment as a full fledged 3D component. It is ment as a simple way to add perspective to a sprite, so that you can give menu buttons perspective, or flip a sprite around.
It requires no other setup, or that you switch to 3D. You can either add this node as a parent to the node(s) you want to add perspective to, or you can make a decendant based on it.

Three properties have been implememnted.
1) Roll, which will roll the sprite around its Y axis
2) Pitch, which will roll the sprite around its X axis
3) Perspective, which will define the amount of perspective added (0=no perspective)

OBS!
While roll and pitch will work independantly (with any other transformation of the node), you can not currently both roll and pitch the node. While it will work 50% of the time, it will skew the wrong way, the other 50% of the time.
Currently I do not have the math skills to figure out what I missed.




