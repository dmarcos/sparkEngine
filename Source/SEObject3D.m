//
//  SE3DObject.m
//  SparkEngine
//
//  Created by Diego Marcos on 6/14/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "SEObject3D.h"

@interface SEObject3D(){
    bool _dirtyMatrix;
}

-(void) updateMatrix;

@end

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
        self->_dirtyMatrix = FALSE;
    }
    return self;
}

-(void) updateMatrix
{
    GLKMatrix4 newMatrix = GLKMatrix4TranslateWithVector3(GLKMatrix4Identity, self->_position);
    newMatrix = GLKMatrix4RotateX(newMatrix, GLKMathDegreesToRadians(self->_rotation.x));
    newMatrix = GLKMatrix4RotateY(newMatrix, GLKMathDegreesToRadians(self->_rotation.y));
    newMatrix = GLKMatrix4RotateZ(newMatrix, GLKMathDegreesToRadians(self->_rotation.z));
    self->_matrix = newMatrix;
    self->_dirtyMatrix = FALSE;
}

-(void) setPosition: (GLKVector3) position
{
    self->_position = position;
    self->_dirtyMatrix = TRUE;
}

-(void) setRotation: (GLKVector3) rotation
{
    self->_rotation = rotation;
    self->_dirtyMatrix = TRUE;
}

-(GLKMatrix4) matrix
{
    if(self->_dirtyMatrix){
        [self updateMatrix];
    }
    return self->_matrix;
}
@end
