//
//  AppDelegate.m
//  RenderLoop
//
//  Created by Diego Marcos Segura on 8/1/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "RenderLoppAppDelegate.h"
#import <SparkEngine/SERendererController.h>
#import <SparkEngine/SECamera.h>
#import <SparkEngine/SEShaderMaterial.h>
#import <SparkEngine/SEShader.h>
#import <SparkEngine/SESphere.h>
#include <stdlib.h>

@interface RenderLoppAppDelegate(){
    SERendererController* _rendererController;
    SEShaderMaterial* _material;
    SESphere* _sphere;
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
    self->_rendererController.camera = [[SECamera alloc] initWithFov:45.0 aspect: appFrame.size.width / appFrame.size.height near: 0.1 far:100.0];
    
    // Objects Setup
    SEShaderMaterial* material = [[SEShaderMaterial alloc] init];
    material.renderStyle = WireFrame;
    self->_material = material;
    self->_sphere = [[SESphere alloc] initWithRadius:1.0 withSteps:36];
    
    // Scene Setup
    self->_rendererController.scene.backgroundColor = GLKVector4Make(1.0, 1.0, 1.0, 1.0);
    [self->_rendererController.scene addObject:self->_sphere];
    self->_rendererController.scene.position = GLKVector3Make(0.0, 0.0,-4.0);
    
    // GLKViewController Setup
    GLKViewController * viewController = [[GLKViewController alloc] initWithNibName:nil bundle:nil]; 
    viewController.view = view;
    viewController.delegate = self; 
    viewController.preferredFramesPerSecond = 30;
    self.window.rootViewController = viewController; 
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)glkViewControllerUpdate:(GLKViewController *)controller {
    self->_material.color = GLKVector4Make((float) rand() / RAND_MAX, (float) rand() / (float) RAND_MAX, rand() / RAND_MAX, 1.0);
    [self->_rendererController.scene removeObject:self->_sphere];
    self->_sphere = [[SESphere alloc] initWithRadius:1.0 withSteps:rand()%36];
    self->_sphere.material = self->_material;
    [self->_rendererController.scene addObject:self->_sphere];
}

@end