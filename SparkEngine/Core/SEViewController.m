//
//  SEViewController.m
//  SparkEngine
//
//  Created by Diego Marcos on 7/18/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SEViewController.h"

@implementation SEViewController

@synthesize renderView = _renderView;

-(id) init
{   self = [super init];
    if (self) {
        // Starts a UIWindow with the size of the device's screen.
        CGRect rect = [[UIScreen mainScreen] bounds];	
        self.renderView = [[SEView alloc] initWithFrame: rect];
    }
    return self;
}

-(id) initWithScene: (SEScene*) scene camera: (SECamera*) camera
{
    self = [super init];
    if (self) {
//        self->_renderView = [[SEView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
//        self->_renderView.scene = scene;
//        self->_renderView.camera = camera;
//        self.view = self->_renderView;
    }
    return self;
}

-(void) setRenderView: (SEView*) view
{
    self.view = view;
    self->_renderView = view;
}

-(void) renderFrame
{
    [self->_renderView renderFrame];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
