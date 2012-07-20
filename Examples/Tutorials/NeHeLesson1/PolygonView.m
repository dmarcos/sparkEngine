//
//  SEBubbleView.m
//  SparkEngine
//
//  Created by Diego Marcos on 6/11/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <CoreMotion/CMMotionManager.h>

#import "PolygonView.h"
#import "SERenderer.h"
#import "SEScene.h"
#import "SESphere.h"
#import "SETriangle.h"
#import "SEPerspectiveCamera.h"
#import "SEShader.h"

@interface PolygonView(){
    UIWindow		*window;
    EAGLContext		*glContext;
    
    BOOL firstTouch;
    BOOL doubleTouchBegun;  
    CGPoint previousSingleTouchPosition;
    float zoom;
    float fov;
    
    SERenderer* renderer;
    SEScene* scene;
    SEPerspectiveCamera* camera;
    
    CMMotionManager* _motionManager;
    CMAttitude* _referenceAttitude;
}

@end

@implementation PolygonView

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
    
    self->zoom = 1.0;
    self->fov = 45.0;
    self->camera = [[SEPerspectiveCamera alloc] initWithFov:GLKMathDegreesToRadians(45.0) aspect: self.bounds.size.width / self.bounds.size.height near: 0.1 far:100.0];
    
    self->scene = [[SEScene alloc] init]; 
    self->scene.rotation = GLKVector3Make(0.0, 0.0, 0.0);
    self->scene.position = GLKVector3Make(0.0, 0.0, -4.0);
    
    GLKVector4 colors[4] = {GLKVector4Make(1.0, 0.0, 0.0, 1.0),
        GLKVector4Make(0.0, 1.0, 0.0, 1.0),
        GLKVector4Make(0.0, 0.0, 1.0, 1.0)};
    SEShaderMaterial* material = [[SEShaderMaterial alloc] init];
    material.shader = [[SEShader alloc] initWithVertexShaderFileName:@"default.vsh" fragmentShaderFileName:@"plainColor.fsh"];
    SETriangle* triangle = [[SETriangle alloc] initWithVerticesColor: colors material: material];
    [self->scene.objects addObject:triangle];
    
    [self renderFrame];
}

+ (Class) layerClass
{
	// This is mandatory to work with CAEAGLLayer in Cocoa Framework.
    return [CAEAGLLayer class];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self->firstTouch = true;
    self->doubleTouchBegun = false;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSInteger touchCount = [touches count];
    if(touchCount == 2)
    {
        [self doubleTouchMoved:touches onView:self];
    }
    else
    {
        [self singleTouchMoved:touches onView:self];
    }
}

-(void) doubleTouchMoved:(NSSet*)touches onView:(UIView*)view
{
    self->doubleTouchBegun = true;
    
    NSArray* touchArray = [touches allObjects];
    UITouch* touch0 = [touchArray objectAtIndex: 0];
    CGPoint currentLocation0 = [touch0 locationInView: view];
    CGPoint previousLocation0 = [touch0 previousLocationInView: view];
    UITouch* touch1 = [touchArray objectAtIndex: 01];
    CGPoint currentLocation1 = [touch1 locationInView: view];
    CGPoint previousLocation1 = [touch1 previousLocationInView: view];
    
    float dxPrevious = previousLocation1.x - previousLocation0.x;
    float dyPrevious = previousLocation1.y - previousLocation0.y;
    float previousDistance = sqrt(dxPrevious * dxPrevious + dyPrevious * dyPrevious);
    
    float dxCurrent = currentLocation1.x - currentLocation0.x;
    float dyCurrent = currentLocation1.y - currentLocation0.y;
    float currentDistance = sqrt(dxCurrent * dxCurrent + dyCurrent * dyCurrent);
    float deltaInDistances = (currentDistance - previousDistance) / 150.0f;

    self->zoom -= deltaInDistances;
    if (self->zoom < 0.025) {
        self->zoom = 0.025;
    }
    else if(self->zoom > 1.0) {
        self->zoom = 1.0;
    } else {
        float newFov = self->fov + 10*deltaInDistances;
        if(newFov >= 45.0 || newFov < 90) {
            self->fov = newFov;
            self->camera.fov = GLKMathDegreesToRadians(newFov);
        }
        [self renderFrame];
    }
    self->scene.position = GLKVector3Make(0.0, 0.0, -4.0*self->zoom);
}

-(void) singleTouchMoved:(NSSet*)touches onView:(UIView*)view
{
    if(self->doubleTouchBegun)
    {
        return;
    }
        
    UITouch* touch = [touches anyObject];
    if(self->firstTouch)
    {
        self->firstTouch = false;
        self->previousSingleTouchPosition = [touch locationInView: view];        
    }
         
    CGPoint currentLocation = [touch locationInView: view];
    float dx = currentLocation.x - self->previousSingleTouchPosition.x;
    float dy = currentLocation.y - self->previousSingleTouchPosition.y;
    GLKVector3 newRotation = scene.rotation;
    if (self->zoom <= 0.28) {
        newRotation.y = newRotation.y - dx;
        newRotation.x = newRotation.x - dy;
    } else {
        newRotation.y = newRotation.y + dx;
        newRotation.x = newRotation.x + dy;
    }
    scene.rotation = newRotation;
    self->previousSingleTouchPosition = currentLocation;
    [self renderFrame];    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

@end