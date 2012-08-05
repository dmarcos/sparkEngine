//
//  Earth3DViewController.m
//  SparkEngine
//
//  Created by Diego Marcos Segura on 7/27/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "Earth3DViewController.h"
#import <SparkEngine/SEView.h>
#import <SparkEngine/SEPerspectiveCamera.h>
#import <SparkEngine/SEScene.h>
#import <SparkEngine/SESphere.h>

@interface Earth3DViewController (){
    SEView* _earth3dView;
}
- (void) dragging: (UIPanGestureRecognizer*) gestureRecognizer;
@end

@implementation Earth3DViewController

@synthesize viewFrame = _viewFrame;

- (void) loadView {
    
    // UIView setup
	self->_earth3dView = [[SEView alloc] initWithFrame: self->_viewFrame];
    self->_earth3dView.multipleTouchEnabled = YES;
    
    // Camera Setup
    self->_earth3dView.camera = [[SEPerspectiveCamera alloc] initWithFov:GLKMathDegreesToRadians(45.0) aspect: self->_viewFrame.size.width / self->_viewFrame.size.height near: 0.1 far:100.0];
        
    // Objects Setup
    SESphere* sphere = [[SESphere alloc] initWithRadius:1.0 withSteps:36];
    sphere.material.texture = [[SETexture alloc] initWithImage:[UIImage imageNamed:@"blueMarble.jpg"]];
    
    // Scene Setup
    [self->_earth3dView.scene addObject:sphere];
    self->_earth3dView.scene.position = GLKVector3Make(0.0, 0.0,-4.0);
    
    // Gesture recognizer setup
    UIPanGestureRecognizer* gestureRecognizer = [[ UIPanGestureRecognizer alloc] initWithTarget:self action:@ selector( dragging:)];
    [self->_earth3dView addGestureRecognizer: gestureRecognizer];
    
    self.view = self->_earth3dView;
}

- (void) dragging: (UIPanGestureRecognizer*) gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan ||
        gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        GLKVector3 newRotation = self->_earth3dView.scene.rotation;
        CGPoint delta = [gestureRecognizer translationInView: self->_earth3dView.superview];
        newRotation.x += delta.y;
        newRotation.y += delta.x;
        self->_earth3dView.scene.rotation = newRotation;
        [gestureRecognizer setTranslation: CGPointZero inView: self->_earth3dView.superview];
        [self->_earth3dView renderFrame];
    }
        
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self->_earth3dView renderFrame];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end