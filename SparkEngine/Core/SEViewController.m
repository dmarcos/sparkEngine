//
//  SEViewController.m
//  SparkEngine
//
//  Created by Diego Marcos on 7/18/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SEViewController.h"

@interface SEViewController (){
    SEView* _renderView;
}

@end

@implementation SEViewController

- (id) initWithScene: (SEScene*) scene camera: (SECamera*) camera
{
    self = [super init];
    if (self) {
        self->_renderView = [[SEView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
        self->_renderView.scene = scene;
        self->_renderView.camera = camera;
        self.view = self->_renderView;
    }
    return self;
}

-(void) renderFrame
{
    [self->_renderView renderFrame];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
