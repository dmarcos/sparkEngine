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
#import <CoreMotion/CMMotionManager.h>

#import "SEBubbleView.h"
#import "SERenderer.h"

@interface SEBubbleView(){
    UIWindow		*window;
    EAGLContext		*glContext;
    
    BOOL firstTouch;
    BOOL doubleTouchBegun;  
    CGPoint previousSingleTouchPosition;
    float rotationX;
    float rotationY;
    float zoom;
    float fov;
    
    SERenderer* renderer;
    
    CMMotionManager* _motionManager;
    CMAttitude* _referenceAttitude;
}

-(void) loadTextures;
-(void) enableGyro;

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
		
        self->zoom = 1.0;
        self->fov = 45.0;
        self->rotationX = 0.0;
        self->rotationY = 0.0;
    }
	
    return self;
}

- (void) renderFrame
{
    [self->renderer renderWithRotationX:self->rotationX withRotationY:self->rotationY withFov:self->fov withZoom:self->zoom];
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
    
	// Initializes the OpenGL in the CubeExample.mm
    [self loadTextures];    
    [self renderFrame];
    
    //self->_motionManager = [[CMMotionManager alloc] init];
    //self->_referenceAttitude = nil;
    //[self enableGyro];
    
}

-(void) loadTextures
{
    self->panorama = [[SETexture alloc] initWithImage:[UIImage imageNamed:@"mars.jpg"]];
    [self->renderer setTexture:self->panorama];
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
        }
        [self renderFrame];
    }
    

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
    
    const float viewportWidthOver = 0.5f * self.bounds.size.height * 0.5;
    const float focalLength = viewportWidthOver / tanf(0.5f * self->fov);
     
    CGPoint currentLocation = [touch locationInView: view];
    float dx = currentLocation.x - self->previousSingleTouchPosition.x;
    float dy = currentLocation.y - self->previousSingleTouchPosition.y;
    if (self->zoom <= 0.28) {
        self->rotationY = self->rotationY - dx;
        self->rotationX = self->rotationX - dy;
    } else {
        self->rotationY = self->rotationY + dx;
        self->rotationX = self->rotationX + dy;
    }
        
        self->previousSingleTouchPosition = currentLocation;
    [self renderFrame];    
}

-(void) enableGyro{
    CMDeviceMotion *deviceMotion = self->_motionManager.deviceMotion;      
    self->_referenceAttitude = deviceMotion.attitude;
    self->_motionManager.gyroUpdateInterval = 1.0/60.0;
    //[self->_motionManager startGyroUpdates];
    //[self->_motionManager startDeviceMotionUpdates];
    [self->_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        NSLog(@"CCACACACACACACA");
    }];

    [self->_motionManager startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData *gyroData, NSError *error) {
        
        CMDeviceMotion *deviceMotion = self->_motionManager.deviceMotion;     
        CMAttitude *attitude = deviceMotion.attitude;
//        float rateX = self->_motionManager.gyroData.rotationRate.x;
//        float rateY = self->_motionManager.gyroData.rotationRate.y;
//        if (fabs(rateX) > .01) {
//         //   float directionX = rateX > 0 ? 1 : -1;
//            self->rotationX += rateX * M_PI/90.0;
//        } 
//        if (fabs(rateY) > .01) {
//          //  float directionY = rateY > 0 ? 1 : -1;
//            self->rotationY += rateY * M_PI/90.0;
//        }
        [self renderFrame];
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)dealloc
{
	NSLog(@"YEAH BABY");
}

@end