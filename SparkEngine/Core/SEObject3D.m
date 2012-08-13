//
//  SE3DObject.m
//  SparkEngine
//
//  Created by Diego Marcos on 6/14/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SEObject3D.h"

@interface SEObject3D()
-(void) updateMatrix;
@end

@implementation SEObject3D

@synthesize position = _position;
@synthesize rotation = _rotation;
@synthesize up = _up;
@synthesize matrix = _matrix;
@synthesize visible = _visible;

-(id) init
{
    self = [super init];
    if(self) {
        self->_position = GLKVector3Make(0,0,0);
        self->_rotation = GLKVector3Make(0,0,0);
        self->_up = GLKVector3Make(0,1,0);
        self->_matrix = GLKMatrix4Identity;
        self->_visible = YES;
    }
    return self;
}

-(void) updateMatrix
{
    GLKMatrix4 newMatrix = GLKMatrix4TranslateWithVector3(GLKMatrix4Identity, self->_position);
    newMatrix = GLKMatrix4RotateX(newMatrix, GLKMathDegreesToRadians(self->_rotation.x));
    newMatrix = GLKMatrix4RotateY(newMatrix, GLKMathDegreesToRadians(self->_rotation.y));
    newMatrix = GLKMatrix4RotateZ(newMatrix, GLKMathDegreesToRadians(self->_rotation.z));
    self.matrix = newMatrix;
}

-(void) setPosition:(GLKVector3)position
{
    self->_position = position;
    [self updateMatrix];
}

-(void) setRotation:(GLKVector3)rotation
{
    self->_rotation = rotation;
    [self updateMatrix];
}

@end