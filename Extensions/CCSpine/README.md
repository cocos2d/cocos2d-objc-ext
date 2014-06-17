CCSpine
=======

Type of class  : Library

Uses extension : CCNodeTag, CCDictionary

CCSpine is a complete library, supporting Spine from Esoteric Software (http://esotericsoftware.com/)

Normally it takes 3 files to create an animated skeleton.

1) A JSON file exported from Spine  
2) A PLIST file containing sprite sheet frames  
3) A PNG file containing images.  

The basic node is a CCSpineSkeleton.   
The skeleton is based on a CCNode, so anything which works on a node, will work on the skeleton.   
The tasks to go through, creating a skeleton  

1) Create the skeleton using skeletonWithJsonFile  
2) Position and add the skeleton to a parent  
3) Select a skin using assignSkin  
4) Select a base animation using setBaseAnimation  

The skeleton animation can be controlled in the following way  
1)  
Setting the base animation  
This animation will loop, when no opther animation is active.  
2)  
Inserting animations.  
The first animation which is inserted, will immediately blend from the base animation to the inserted animation.  
Further animations inserted, will be executed when the previous inserted animation is completed.  
When all inserted animation has completed, animation will return to the base animation.  
3)   
Force an animation  
Forcing an animation, will clear any inserted animation, and make this the new base animation.  
Just setting a new base animation 1) will only not clear inserted animations.  
