//
//  SEPerspectiveCamera.h
//  SparkEngine
//
//  Created by Diego Marcos on 6/25/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SECamera.h"

@interface SEPerspectiveCamera : SECamera

-(id) initWithFov: (float) fov aspect: (float) aspect near: (float) near far: (float) far;

@property (nonatomic) float fov;
@property (nonatomic) float aspect;
@property (nonatomic) float near;
@property (nonatomic) float far;

@end
