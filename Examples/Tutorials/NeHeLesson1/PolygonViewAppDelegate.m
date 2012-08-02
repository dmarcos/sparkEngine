//
//  PolygonViewAppDelegate.m
//  SparkEngine
//
//  Created by Diego Marcos Segura on 7/30/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "PolygonViewAppDelegate.h"
#import "PoligonViewController.h"

@implementation PolygonViewAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CGRect appFrame = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame: appFrame];
    
    PoligonViewController* polygonViewController = [[PoligonViewController alloc] init];
    polygonViewController.viewFrame = appFrame;
    
    self.window.rootViewController = polygonViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end