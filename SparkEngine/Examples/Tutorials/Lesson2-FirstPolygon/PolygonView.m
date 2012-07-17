//
//  SEBubbleView.m
//  SparkEngine
//
//  Created by Diego Marcos on 6/11/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#import "SEBubbleView.h"
#import "SERenderer.h"
#import "SEScene.h"
#import "SESphere.h"
#import "SETriangle.h"
#import "SEPerspectiveCamera.h"

@interface SEBubbleView(){
    UIWindow		*window;
    EAGLContext		*glContext;
    SERenderer* renderer;
    SEScene* scene;
    SEPerspectiveCamera* camera;
    
}

@end

@implementation SEBubbleView

@synthesize panorama;

- (id)init
{
	if ((self = [super init]))
	{
		CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
		
		// Set the properties to EAGL.
		// If the color format here is set to kEAGLColorFormatRGB565, you'll not be able
		// to use texture with alpha in this EAGLLayer.
        eaglLayer.opaque = YES;
		eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
										[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
										kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat,
										nil];
        self->camera = [[SEPerspectiveCamera alloc] initWithFov:GLKMathDegreesToRadians(45.0) aspect: self.bounds.size.width / self.bounds.size.width near: 0.1 far:100.0];
        self->scene = [[SEScene alloc] init]; 
        self->scene.rotation = GLKVector3Make(0.0, 0.0, 0.0);
        self->scene.position = GLKVector3Make(0.0, 0.0, -4.0);
        GLKVector4 colors[3] = {GLKVector4Make(1.0, 1.0, 1.0, 1.0),
                                GLKVector4Make(1.0, 1.0, 1.0, 1.0),
                                GLKVector4Make(1.0, 1.0, 1.0, 1.0)};
        SETriangle* triangle = [[SETriangle alloc] initWithVerticesColor: colors];
        [self->scene.objects addObject:triangle];
    }
	
    return self;
}

- (void) renderFrame
{
    [self->renderer renderScene: scene camera: camera];
}

+ (void) presentColorbuffer
{
	// Presents the currently bound Color Renderbuffer to to the EAGLContext in use.
	[[EAGLContext currentContext] presentRenderbuffer:GL_RENDERBUFFER];
}

- (void) applicationDidFinishLaunching:(UIApplication *)application
{
	// Starts a UIWindow with the size of the device's screen.
	CGRect rect = [[UIScreen mainScreen] bounds];	
	self->window = [[UIWindow alloc] initWithFrame:rect];
	
	if(![super initWithFrame:rect]) 
	{
		return;
	}
    
    self.multipleTouchEnabled = YES;
	
	// Makes that UIWindow the key window and show it. Additionaly add this UIView to it.
	[self->window makeKeyAndVisible];
	[self->window addSubview:self];
	
	// Creates the EAGLContext and set it as the current one.
	self->glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
	[EAGLContext setCurrentContext: self->glContext];
    self->renderer = [[SERenderer alloc] initWithViewport:self.bounds withGLContext: self->glContext withEAGLLayer: (CAEAGLLayer *) self.layer];
    self->camera.aspect = self.bounds.size.width / self.bounds.size.height;
	// Initializes the OpenGL in the CubeExample.mm
    [self renderFrame];
    
}

+ (Class) layerClass
{
	// This is mandatory to work with CAEAGLLayer in Cocoa Framework.
    return [CAEAGLLayer class];
}

@end