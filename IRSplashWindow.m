//
//  IRSplashWindow.m
//  Tarotie
//
//  Created by Evadne Wu on 6/6/10.
//  Copyright 2010 Iridia Productions. All rights reserved.
//

#import "IRSplashWindow.h"










@interface IRSplashWindow ()

@property (retain) CALayer *splashLayer;
@property (retain) UIImage *splashImage;
@property (retain) CABasicAnimation *splashRetreatingAnimation;
@property (retain) CABasicAnimation *splashPresentingAnimation;

@end





@interface IRSplashWindow (Private)

- (BOOL) prepareDefaults;
- (void) prepareSplash;

@end










@implementation IRSplashWindow
@synthesize delegate, splashLayer, splashImage, splashPresentingAnimation, splashRetreatingAnimation, splashAnimationDuration, splashRetreated, showSplashWithAnimation, transitionType;





- (IRSplashWindow *) init {

	self = [super init];
	
	[self prepareSplash];

	return self;
	
}





- (id)initWithFrame:(CGRect)frame {

	if ((self = [super initWithFrame:frame])) {

		[self prepareSplash];

	}
	
	return self;

}





- (void) awakeFromNib {
	
	[self prepareSplash];
	
}





- (void) createAnimations {

	switch (self.transitionType) {

		case IRSplashWindowTransitionTypeFade:
		default:
		
			self.splashPresentingAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
			
			self.splashPresentingAnimation.fromValue = [NSNumber numberWithFloat:0.0];
			self.splashPresentingAnimation.toValue = [NSNumber numberWithFloat:1.0];
			
			self.splashRetreatingAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
			
			self.splashRetreatingAnimation.fromValue = [NSNumber numberWithFloat:1.0];
			self.splashRetreatingAnimation.toValue = [NSNumber numberWithFloat:0.0];
			
			break;

	}
	
	[self.splashPresentingAnimation setDelegate:self];
	self.splashPresentingAnimation.duration = self.splashAnimationDuration;
	self.splashPresentingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	self.splashPresentingAnimation.fillMode = kCAFillModeForwards;
	self.splashPresentingAnimation.removedOnCompletion = NO;
	[self.splashPresentingAnimation setValue:IRSplashWindowDefaultSplashPresentingAnimationIdentifierValue forKey:IRSplashWindowDefaultSplashAnimationIdentifierKey];
	
	
	[self.splashRetreatingAnimation setDelegate:self];
	self.splashRetreatingAnimation.duration = self.splashAnimationDuration;
	self.splashRetreatingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	self.splashRetreatingAnimation.fillMode = kCAFillModeForwards;
	self.splashRetreatingAnimation.removedOnCompletion = NO;
	[self.splashRetreatingAnimation setValue:IRSplashWindowDefaultSplashRetreatingAnimationIdentifierValue forKey:IRSplashWindowDefaultSplashAnimationIdentifierKey];
	
}





- (BOOL) prepareDefaults {
	
	if (self.splashAnimationDuration == 0)
	self.splashAnimationDuration = IRSplashWindowDefaultSplashAnimationDuration;

	self.splashImage = [UIImage imageNamed:(NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"IRSplashWindowImage"]];

	if (!self.splashImage) self.splashImage = [UIImage imageNamed:@"Default"];
	
	if (!self.splashImage) {
	
		NSLog(@"ERROR: IRSplashWindow requires the key IRSplashWindowImage be defined in the application’s info dictionary, or a fallback Default.png be used.  Neither is present so the window will show without splash.");
		
		return NO;
		
	}
	
	return YES;
	
}





- (void) prepareSplash {

	if (![self prepareDefaults]) return;
	
	if ([self.delegate respondsToSelector:@selector(splashWillPrepare:)])
	[(id <IRSplashWindowDelegate>)self.delegate splashWillPrepare:self];

	
	self.userInteractionEnabled = NO;
	
	[self createAnimations];
	
	self.splashLayer = [CALayer layer];
	self.splashLayer.bounds = self.frame;
	self.splashLayer.position = self.center;
	self.splashLayer.zPosition = 512;	//	Hard-coded default.
	
//	self.splashLayer.backgroundColor = [UIColor clearColor].CGColor;
	self.splashLayer.opaque = NO;
	self.splashLayer.contents = (id)[self.splashImage CGImage];
	
	self.splashRetreated = YES;
	
//	FIXME: provide mechanism that checks self.showSplashWithAnimation
	[self.layer addSublayer:self.splashLayer];

	
	if ([self.delegate respondsToSelector:@selector(splashDidPrepare:)])
	[(id <IRSplashWindowDelegate>)self.delegate splashDidPrepare:self];

}





- (void) retreatSplash {

//	NSLog(@"IRWindow retreating splash");
	
	if (!self.splashLayer) return;
	
	if ([self.delegate respondsToSelector:@selector(splashWillRetreat:)])
	[(id <IRSplashWindowDelegate>)self.delegate splashWillRetreat:self];
	
	[self.splashLayer addAnimation:self.splashRetreatingAnimation forKey:self.splashRetreatingAnimation.keyPath];
	
}





- (void) animationDidStop:(CABasicAnimation *)theAnimation finished:(BOOL)flag {
	
	NSString *animationIdentifier = (NSString *)[theAnimation valueForKey:IRSplashWindowDefaultSplashAnimationIdentifierKey];
	
	if ([animationIdentifier isEqualToString:IRSplashWindowDefaultSplashRetreatingAnimationIdentifierValue]) {

		self.userInteractionEnabled = YES;
		
		if ([self.delegate respondsToSelector:@selector(splashDidRetreat:)])
		[(id <IRSplashWindowDelegate>)self.delegate splashDidRetreat:self];
		
		self.splashRetreated = YES;
		
	}
	
	@synchronized (self) {
	
		[self.splashLayer removeAnimationForKey:[theAnimation keyPath]];
		[self.splashLayer setValue:[theAnimation toValue] forKeyPath:[theAnimation keyPath]];
		
	}

	[self.splashLayer removeFromSuperlayer];
	
}





- (void)dealloc {

	[splashLayer release];
	[splashImage release];
	
	[splashRetreatingAnimation release];
	[splashPresentingAnimation release];	
	[super dealloc];

}





@end




