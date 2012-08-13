//
//  SECamera.h
//  SparkEngine
//
//  Created by Diego Marcos on 6/25/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SEObject3D.h"

@interface SECamera : SEObject3D

-(id) initWithFov:(float)fov aspect:(float)aspect near:(float)near far:(float)far;
-(id) initWithLeft:(float)left right:(float)right bottom:(float)bottom top:(float)top near:(float)near far:(float)far;

@property (nonatomic) GLKMatrix4 projectionMatrix;

@property (nonatomic) float fov;
@property (nonatomic) float aspect;
@property (nonatomic) float near;
@property (nonatomic) float far;

@property (nonatomic, readonly) float left;
@property (nonatomic, readonly) float right;
@property (nonatomic, readonly) float bottom;
@property (nonatomic, readonly) float top;

@end
