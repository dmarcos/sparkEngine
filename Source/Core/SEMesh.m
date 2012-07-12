//
//  SEMEsh.m
//  SparkEngine
//
//  Created by Diego Marcos on 6/19/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "SEMesh.h"

@implementation SEMesh

@synthesize geometry = _geometry;

@synthesize vertexBuffer = _vertexBuffer;
@synthesize facesIndicesBuffer = _facesIndicesBuffer;

@synthesize shader = _shader;

-(id) initWithGeometry: (SEGeometry*) geometry shader: (SEShader*) shader;
{
    self = [self init];
    if (self) {
        self->_geometry = geometry;
        if(shader) {
            self->_shader = shader;
        }
    }
    return self;
}

-(id)init
{   self = [super init];
    if (self) {
        self->_vertexBuffer = -1;
        self->_facesIndicesBuffer = -1;
    }
    return self;
}

-(SEShader*) shader
{
    if(!self->_shader){
        self->_shader = [SEShader defaultShader];
    }
    return self->_shader;
}

@end