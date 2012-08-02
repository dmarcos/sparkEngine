//
//  AppDelegate.h
//  RenderLoop
//
//  Created by Diego Marcos Segura on 8/1/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKViewController.h>

@interface RenderLoppAppDelegate : UIResponder <UIApplicationDelegate,GLKViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)glkViewControllerUpdate:(GLKViewController *)controller;

@end
