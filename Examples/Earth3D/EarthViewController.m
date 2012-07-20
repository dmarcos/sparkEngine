//
//  EarthViewController.m
//  SparkEngine
//
//  Created by Diego Marcos on 7/18/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "EarthViewController.h"
#import "SEPerspectiveCamera.h"
#import "SESphere.h"

@implementation EarthViewController

@synthesize window;

- (id)init
{
    self = [super init];
    if (self) {
        // Starts a UIWindow with the size of the device's screen.
        CGRect rect = [[UIScreen mainScreen] bounds];	
        self.window = [[UIWindow alloc] initWithFrame:rect];        
        // Makes that UIWindow the key window. Additionaly add the renderView UIView to it.
        [self.window addSubview: self.renderView];
    }
    return self;
}

- (void) applicationDidFinishLaunching:(UIApplication *)application
{    
    // Camera Setup
    SEPerspectiveCamera* camera = [[SEPerspectiveCamera alloc] initWithFov:GLKMathDegreesToRadians(45.0) aspect: self.renderView.bounds.size.width / self.renderView.bounds.size.height near: 0.1 far:100.0];
    
    // Scene Setup
    SEScene* scene = [[SEScene alloc] init]; 
    scene.rotation = GLKVector3Make(0.0, 0.0, 0.0);
    scene.position = GLKVector3Make(0.0, 0.0,-4.0);
    
    // Objects Setup
    SESphere* sphere = [[SESphere alloc] initWithRadius:1.0 withSteps:36];
    sphere.material.texture = [[SETexture alloc] initWithImage:[UIImage imageNamed:@"blueMarble.jpg"]];;
    [scene.objects addObject:sphere];
        
    // Attaches scene and camera and renders one frame
    self.renderView.scene = scene;
    self.renderView.camera = camera;
    self.renderView.multipleTouchEnabled = YES;
    [self renderFrame];

    // Shows the window.
    [self.window makeKeyAndVisible];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self renderFrame];
}

@end
