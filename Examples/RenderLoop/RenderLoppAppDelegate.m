//
//  AppDelegate.m
//  RenderLoop
//
//  Created by Diego Marcos Segura on 8/1/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "RenderLoppAppDelegate.h"
#import <SparkEngine/SERendererController.h>
#import <SparkEngine/SEPerspectiveCamera.h>
#import <SparkEngine/SEShaderMaterial.h>
#import <SparkEngine/SEShader.h>
#import <SparkEngine/SETriangle.h>

@interface RenderLoppAppDelegate(){
    SERendererController* _rendererController;
}
@end

@implementation RenderLoppAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CGRect appFrame = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:appFrame];
        
    // Renderer Controller Setup
    self->_rendererController = [[SERendererController alloc] init];

    // GLKView setup
    EAGLContext * context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    GLKView *view = [[GLKView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.context = context;
    view.delegate = self->_rendererController;
        
    // Camera setup
    self->_rendererController.camera = [[SEPerspectiveCamera alloc] initWithFov:GLKMathDegreesToRadians(45.0) aspect: appFrame.size.width / appFrame.size.height near: 0.1 far:100.0];
    
    // Objects Setup
    SEShaderMaterial* material = [[SEShaderMaterial alloc] init];
    material.shader = [[SEShader alloc] initWithVertexShaderFileName:@"default.vsh" fragmentShaderFileName:@"plainColor.fsh"];
    SETriangle* triangle = [[SETriangle alloc] initWithMaterial: material];
    
    // Scene Setup
    [self->_rendererController.scene.objects addObject:triangle];
    self->_rendererController.scene.position = GLKVector3Make(0.0, 0.0,-4.0);
    
    // GLKViewController Setup
    GLKViewController * viewController = [[GLKViewController alloc] initWithNibName:nil bundle:nil]; 
    viewController.view = view;
    viewController.delegate = self; 
    viewController.preferredFramesPerSecond = 60; 
    self.window.rootViewController = viewController; 
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)glkViewControllerUpdate:(GLKViewController *)controller {
}

@end
