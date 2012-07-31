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
@synthesize linesIndicesBuffer = _linesIndicesBuffer;

@synthesize material = _material;

-(id) initWithGeometry: (SEGeometry*) geometry material: (SEShaderMaterial*) material;
{
    self = [super init];
    if (self) {
        self->_vertexBuffer = -1;
        self->_facesIndicesBuffer = -1;
        self->_linesIndicesBuffer = -1;
        self->_geometry = geometry;
        if(material) {
            self.material = material;
        }
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

-(void) setMaterial: (SEShaderMaterial*) material
{
    if(material.verticesColors){
        for(int i = 0; i < self->_geometry.numVertices;++i){
            self->_geometry.vertices[i].color = material.verticesColors[i];
        }
    }
    self->_material = material;
}

@end