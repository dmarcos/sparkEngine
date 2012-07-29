//
//  SEView.m
//  SparkEngine
//
//  Created by Diego Marcos on 7/18/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SEView.h"
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@implementation SEView

@synthesize camera = _camera;
@synthesize scene = _scene;
@synthesize renderer = _renderer;
@synthesize glContext = _glContext;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;

		// Set the properties to EAGL.
		// If the color format here is set to kEAGLColorFormatRGB565, you'll not be able
		// to use texture with alpha in this EAGLLayer.
        eaglLayer.opaque = YES;
		eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
										[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
										kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
										nil];
        
        // Creates the EAGLContext and set it as the current one.
        self->_glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        [EAGLContext setCurrentContext: self->_glContext];
        self->_renderer = [[SERenderer alloc] initWithViewport:self.bounds withGLContext: self->_glContext withEAGLLayer: (CAEAGLLayer *) self.layer];
        self->_scene = [[SEScene alloc] init];
    }
    return self;
}

- (void)renderFrame
{
    [self->_renderer renderScene:self->_scene camera:self->_camera];
}

+ (Class) layerClass
{
	// This is mandatory to work with CAEAGLLayer in Cocoa Framework.
    return [CAEAGLLayer class];
}

@end
