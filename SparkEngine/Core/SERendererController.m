//
//  SERendererController.m
//  SparkEngine
//
//  Created by Diego Marcos Segura on 8/1/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SERendererController.h"
#import "SERenderer.h"

@interface SERendererController(){
    SERenderer* _renderer;
}
@end

@implementation SERendererController

@synthesize scene = _scene;
@synthesize camera = _camera;

-(id) init {
    self = [super init];
    if (self) {
        self->_renderer = [[SERenderer alloc] initWithGLContext: nil withEAGLLayer: nil];
        self->_scene = [[SEScene alloc] init];
    }
    return self;
}

-(void) glkView:(GLKView*)view drawInRect:(CGRect)rect {
    [self->_renderer renderScene:self.scene camera:self.camera viewport:rect];
}

@end
