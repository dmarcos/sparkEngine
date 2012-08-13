//
//  SECamera.m
//  SparkEngine
//
//  Created by Diego Marcos on 6/25/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SECamera.h"

@interface SECamera(){
    bool _projectionMatrixNeedsUpdate;
}

-(void) updateProjectionMatrix;
-(void) updatePlanes;

@end

@implementation SECamera

@synthesize projectionMatrix = _projectionMatrix;

@synthesize fov = _fov;
@synthesize aspect = _aspect;
@synthesize near = _near;
@synthesize far = _far;

@synthesize right = _right;
@synthesize left = _left;
@synthesize top = _top;
@synthesize bottom = _bottom;

-(id) initWithFov:(float)fov aspect:(float)aspect near:(float)near far:(float)far
{
    self = [super init];
    if(self) {
        self->_projectionMatrix = GLKMatrix4Identity;
        self->_fov = GLKMathDegreesToRadians(fov);
        self->_aspect = aspect;
        self->_near = near;
        self->_far = far;
        [self updatePlanes];
    }
    return self;
}

-(id) initWithLeft:(float)left right:(float)right bottom:(float)bottom top:(float)top near:(float)near far:(float)far{
    self = [super init];
    if (self) {
        self->_projectionMatrix = GLKMatrix4Identity;
        self->_top = top;
        self->_bottom = bottom;
        self->_right = right;
        self->_left = left;
        self->_near = near;
        self->_far = far;
        self->_aspect = self->_right / self->_top;
        self->_fov = atan(self->_top / self->_near) * 2;
        self->_projectionMatrixNeedsUpdate = YES;
    }
    return self;
}

-(GLKMatrix4) projectionMatrix
{
    if (self->_projectionMatrixNeedsUpdate) {
        [self updateProjectionMatrix];
    }
    return self->_projectionMatrix;
}

-(void) updateProjectionMatrix
{
    //GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(self->_fov, self->_aspect, self->_near, self->_far);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeFrustum(self->_left, self->_right, self->_bottom, self->_top, self->_near, self->_far);
    self->_projectionMatrix = GLKMatrix4Multiply(projectionMatrix, self.matrix);
    self->_projectionMatrixNeedsUpdate = NO;
}

-(void) updatePlanes
{
    self->_top = tan(self->_fov / 2) * self->_near;
    self->_bottom = -self->_top;
    self->_right = self->_top * self->_aspect;
    self->_left = -self->_right;
    self->_projectionMatrixNeedsUpdate = YES;
}

-(void) setFov:(float)fov
{
    self->_fov = GLKMathDegreesToRadians(fov);
    [self updatePlanes];
}

-(void) setAspect:(float)aspect
{
    self->_aspect = aspect;
    [self updatePlanes];
}

-(void) setNear:(float)near
{
    self->_near = near;
    [self updatePlanes];
}

-(void) setFar:(float)far
{
    self->_far = far;
    [self updatePlanes];
}

-(void) setMatrix:(GLKMatrix4)matrix
{
    self->_projectionMatrixNeedsUpdate = YES;
    [super setMatrix:matrix];
}

@end