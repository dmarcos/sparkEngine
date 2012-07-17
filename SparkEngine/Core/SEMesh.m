//
//  SEMEsh.m
//  SparkEngine
//
//  Created by Diego Marcos on 6/19/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SEMesh.h"

@implementation SEMesh

@synthesize geometry = _geometry;

@synthesize vertexBuffer = _vertexBuffer;
@synthesize facesIndicesBuffer = _facesIndicesBuffer;

@synthesize material = _material;

-(id) initWithGeometry: (SEGeometry*) geometry material: (SEShaderMaterial*) material;
{
    self = [self init];
    if (self) {
        self->_geometry = geometry;
        if(material) {
            self->_material = material;
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

-(SEShaderMaterial*) material
{
    if(!self->_material){
        self->_material = [[SEShaderMaterial alloc] init];
    }
    return self->_material;
}

@end