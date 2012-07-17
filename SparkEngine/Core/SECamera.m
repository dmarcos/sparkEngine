//
//  SECamera.m
//  SparkEngine
//
//  Created by Diego Marcos on 6/25/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SECamera.h"

@implementation SECamera

@synthesize projectionMatrix = _projectionMatrix;

-(id) init
{
    self = [super init];
    if(self) {
        self->_projectionMatrix = GLKMatrix4Identity;
    }
    return self;
}

@end
