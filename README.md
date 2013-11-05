iOS7LockScreenCameraLikeTransition
==================================

Project in which I am trying to copy the iOS7  LockScreen -> Camera transition

So far I pretty much done it, the way I want. However there are some problems in animating :

1) Container view in which animation happens does not support orientation from the box, so had to do switch(orientation) in dynamics related code

2) Also there is an issue I didn't quite understood yet, when adding UICollision behaviour to container view outside of it's visible part coordinates are shifted without known reason.

Any improvements are welcome, hope those issues are just a problem of UIDynamics being a bit raw at this point.

