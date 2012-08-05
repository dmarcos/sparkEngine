//
//  SEPerspectiveCamera.m
//  SparkEngine
//
//  Created by Diego Marcos on 6/25/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SEPerspectiveCamera.h"

@interface SEPerspectiveCamera()

-(void) updateProjectionMatrix;

@end

@implementation SEPerspectiveCamera

@synthesize fov = _fov;
@synthesize aspect = _aspect;
@synthesize near = _near;
@synthesize far = _far;

-(id) initWithFov:(float)fov aspect:(float)aspect near:(float)near far:(float)far
{
    self = [super init];
    if(self) {
        self->_fov = fov;
        self->_aspect = aspect;
        self->_near = near;
        self->_far = far;
        [self updateProjectionMatrix];
    }
    return self;
}

-(void) updateProjectionMatrix
{
    self.projectionMatrix = GLKMatrix4MakePerspective(self->_fov, self->_aspect, self->_near, self->_far);
}

-(void) setFov:(float)fov
{
    self->_fov = fov;
    [self updateProjectionMatrix];
}

-(void) setAspect:(float)aspect
{
    self->_aspect = aspect;
    [self updateProjectionMatrix];
}

-(void) setNear:(float)near
{
    self->_near = near;
    [self updateProjectionMatrix];
}

-(void) setFar:(float)far
{
    self->_far = far;
    [self updateProjectionMatrix];
}

@end