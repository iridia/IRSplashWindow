//
//  IRSplashWindow.h
//  Tarotie
//
//  Created by Evadne Wu on 6/6/10.
//  Copyright 2010 Iridia Productions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CGGeometry+IRFittingAdditions.h"





#define IRSplashWindowDefaultSplashAnimationDuration 0.8

#define IRSplashWindowDefaultSplashPresentingAnimationIdentifierValue @"Presenting"
#define IRSplashWindowDefaultSplashRetreatingAnimationIdentifierValue @"Retreating"
#define IRSplashWindowDefaultSplashAnimationIdentifierKey @"IRSplashWindowDefaultSplashAnimationIdentifier"





typedef enum {

	IRSplashWindowTransitionTypeFade
	
} IRSplashWindowTransitionType;





@class IRSplashWindow;
@protocol IRSplashWindowDelegate

@optional

- (void) splashWillPrepare:(IRSplashWindow *)sender;
- (void) splashDidPrepare:(IRSplashWindow *)sender;
- (void) splashWillRetreat:(IRSplashWindow *)sender;
- (void) splashDidRetreat:(IRSplashWindow *)sender;

@end





@interface IRSplashWindow : UIWindow {			//	Defaults:

	IRSplashWindowTransitionType transitionType;	//	IRSplashWindowTransitionTypeFade
	BOOL showSplashWithAnimation;			//	NO
	id<IRSplashWindowDelegate> delegate;		//	nil
	
	NSTimeInterval splashAnimationDuration;
	
	BOOL splashRetreated;				//	NO

	@private

		CALayer *splashLayer;
		UIImage *splashImage;
		
		CABasicAnimation *splashRetreatingAnimation;
		CABasicAnimation *splashPresentingAnimation;

}





- (void) retreatSplash;





@property (assign) id delegate;	//	Weak reference.
@property (assign) NSTimeInterval splashAnimationDuration;
@property (assign) BOOL showSplashWithAnimation;
@property (assign) BOOL splashRetreated;
@property (assign) IRSplashWindowTransitionType transitionType;





@end




