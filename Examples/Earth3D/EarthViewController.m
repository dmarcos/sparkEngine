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
    SEPerspectiveCamera* camera = [[SEPerspectiveCamera alloc] initWithFov:GLKMathDegreesToRadians(45.0) aspect: self.view.bounds.size.width / self.view.bounds.size.width near: 0.1 far:100.0];

    // Scene Setup
    SEScene* scene = [[SEScene alloc] init]; 
    scene.rotation = GLKVector3Make(0.0, 0.0, 0.0);
    scene.position = GLKVector3Make(0.0, 0.0,-4.0);
    
    // Objects Setup
    SESphere* sphere = [[SESphere alloc] initWithRadius:1.0 withSteps:36];
    sphere.material.texture = [[SETexture alloc] initWithImage:[UIImage imageNamed:@"blueMarble.jpg"]];;
    [scene.objects addObject:sphere];
    
	self = [super initWithScene:scene camera:camera];
    camera.aspect = self.view.bounds.size.width / self.view.bounds.size.height;
    return self;
}

- (void) applicationDidFinishLaunching:(UIApplication *)application
{
    // Starts a UIWindow with the size of the device's screen.
	CGRect rect = [[UIScreen mainScreen] bounds];	
	window = [[UIWindow alloc] initWithFrame:rect];
    self.view.backgroundColor = [UIColor redColor];

	// Makes that UIWindow the key window and show it. Additionaly add this UIView to it.
	[window addSubview: self.view];
    [self renderFrame];
    [window makeKeyAndVisible];
}

@end
