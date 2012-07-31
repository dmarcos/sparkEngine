//
//  Earth3DAppDelegate.m
//  SparkEngine
//
//  Created by Diego Marcos Segura on 7/27/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "Earth3DAppDelegate.h"
#import "Earth3DViewController.h"

@implementation Earth3DAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CGRect appFrame = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame: appFrame];
    
    Earth3DViewController* earth3DViewController = [[Earth3DViewController alloc] init];
    earth3DViewController.viewFrame = appFrame;
    
    self.window.rootViewController = earth3DViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
