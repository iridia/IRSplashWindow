#	IRSplashWindow

IRSplashWindow is an `UIWindow` subclass that allows developers to create splashed applications easily.  It provides a transition between your app’s splash image and the actual app.

By default, IRSplashWindow uses your default launch image.  To provide a custom image, include the name of the desired image in your app’s `info.plist` as key `IRSplashWindowImage`.  The custom value takes precedence.

The transition duration defaults to 0.8 seconds and is exposed as a property (`splashAnimationDuration`).

IRSplashWindow relies on [iridia / CGGeometry-IRFittingAdditions](git://github.com/iridia/CGGeometry-IRFittingAdditions.git).





##	Todo

*	Support launch images for all four orientations.
*	Support `IRSplashWindow.showSplashWithAnimation`.





##	Delegate protocol

Set the delegate, and implement this optional protocol to do additional work:

	- (void) splashWillPrepare:(IRSplashWindow *)sender;
	- (void) splashDidPrepare:(IRSplashWindow *)sender;
	- (void) splashWillRetreat:(IRSplashWindow *)sender;
	- (void) splashDidRetreat:(IRSplashWindow *)sender;





##	Comments welcomed

Evadne Wu at Iridia Productions, 2010.  `ev@iridia.tw`




