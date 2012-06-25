//
//  SE3DObject.m
//  SparkEngine
//
//  Created by Diego Marcos on 6/14/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "SEObject3D.h"

@implementation SEObject3D

@synthesize position = _position;
@synthesize rotation = _rotation;
@synthesize up = _up;
@synthesize matrix = _matrix;

-(id) init
{
    self = [super init];
    if(self) {
        self->_position = GLKVector3Make(0,0,0);
        self->_rotation = GLKVector3Make(0,0,0);
        self->_up = GLKVector3Make(0,1,0);
        self->_matrix = GLKMatrix4Identity;
    }
    return self;
}

@end
