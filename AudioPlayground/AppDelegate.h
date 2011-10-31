//
//  AppDelegate.h
//  AudioPlayground
//
//  Created by Alan Price on 11-09-22.
//  Copyright Digido Interactive 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
