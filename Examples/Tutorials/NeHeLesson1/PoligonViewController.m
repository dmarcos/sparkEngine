//
//  PoligonViewController.m
//  SparkEngine
//
//  Created by Diego Marcos Segura on 7/30/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "PoligonViewController.h"
#import <SparkEngine/SEView.h>
#import <SparkEngine/SECamera.h>
#import <SparkEngine/SEScene.h>
#import <SparkEngine/SETriangle.h>
#import <SparkEngine/SEShader.h>
#import <SparkEngine/SECameraVisualization.h>

@interface PoligonViewController(){
    SEView* _polygonView;
    SETriangle* _triangle;
}

- (void) dragging: (UIPanGestureRecognizer*) gestureRecognizer;

@end

@implementation PoligonViewController

@synthesize viewFrame = _viewFrame;

- (void) loadView {
    
    // UIView setup
	self->_polygonView = [[SEView alloc] initWithFrame: self->_viewFrame];
    self->_polygonView.multipleTouchEnabled = YES;
    
    // Camera setup
    self->_polygonView.camera = [[SECamera alloc] initWithFov:45.0 aspect: self->_viewFrame.size.width / self->_viewFrame.size.height near: 0.1 far:100.0];
    
    // Objects Setup
    GLKVector4* colors = (GLKVector4*) malloc(sizeof(GLKVector4)*5);
    colors[0] = GLKVector4Make(1.0, 0.0, 0.0, 1.0);
    colors[1] = GLKVector4Make(0.0, 1.0, 0.0, 1.0);
    colors[2] = GLKVector4Make(0.0, 0.0, 1.0, 1.0);
    colors[3] = GLKVector4Make(0.0, 1.0, 1.0, 1.0);
    colors[4] = GLKVector4Make(1.0, 0.0, 1.0, 1.0);

    SEShaderMaterial* material = [[SEShaderMaterial alloc] init];
    material.shader = [[SEShader alloc] initWithVertexShaderFileName:@"default.vsh" fragmentShaderFileName:@"plainColor.fsh"];
    material.verticesColors = colors;
    self->_triangle = [[SETriangle alloc] initWithMaterial: material];
    self->_triangle.position = GLKVector3Make(0.0, 0.0,-4.0);
    
    // Scene Setup
    [self->_polygonView.scene addObject:self->_triangle];

    SECameraVisualization* cameraViz = [[SECameraVisualization alloc] initWithCamera: self->_polygonView.camera];
    [self->_polygonView.scene addObject:cameraViz];
    
    UIPanGestureRecognizer* gestureRecognizer = [[ UIPanGestureRecognizer alloc] initWithTarget:self action:@ selector(dragging:)];
    [self->_polygonView addGestureRecognizer: gestureRecognizer];
    
    self.view = self->_polygonView;
}

- (void) dragging: (UIPanGestureRecognizer*) gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan ||
        gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        GLKVector3 newRotation = self->_polygonView.camera.rotation;
        CGPoint delta = [gestureRecognizer translationInView: self->_polygonView.superview];
        newRotation.x += delta.y;
        newRotation.y += delta.x;
        self->_polygonView.camera.rotation = newRotation;
        [gestureRecognizer setTranslation: CGPointZero inView: self->_polygonView.superview];
        [self->_polygonView renderFrame];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self->_polygonView renderFrame];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end