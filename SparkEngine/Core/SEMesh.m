//
//  SEMEsh.m
//  SparkEngine
//
//  Created by Diego Marcos on 6/19/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SEMesh.h"

@interface SEMesh(){
    bool _geometryNeedsUpdate;
}
-(void) updateGeometry;
@end

@implementation SEMesh

@synthesize geometry = _geometry;

@synthesize vertexBuffer = _vertexBuffer;
@synthesize vertexBufferNeedsUpdate = _vertexBufferNeedsUpdate;

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
        } else {
            self.material = [[SEShaderMaterial alloc] init]; // Default Material
        }
        self->_geometryNeedsUpdate = YES;
        self->_vertexBufferNeedsUpdate = YES;
    }
    return self;
}

-(void) setVertexBuffer:(GLuint)bufferId
{
    self->_vertexBuffer = bufferId;
}

-(SEShaderMaterial*) material
{
    if(!self->_material){
        self->_material = [[SEShaderMaterial alloc] init];
        self->_geometryNeedsUpdate = YES;
    }
    return self->_material;
}

-(void) setMaterial: (SEShaderMaterial*) material
{
    self->_material = material;
    self->_geometryNeedsUpdate = YES;
}

-(SEGeometry*) geometry
{
    [self updateGeometry];
    return self->_geometry;
}

-(void) updateGeometry
{
    if (self->_geometryNeedsUpdate) {
        if(self->_material.verticesColors){
            for(int i = 0; i < self->_geometry.numVertices;++i){
                self->_geometry.vertices[i].color = self->_material.verticesColors[i];
            }
        } else {
            for(int i = 0; i < self->_geometry.numVertices;++i){
                self->_geometry.vertices[i].color = self->_material.color;
            }
        }
        self->_geometryNeedsUpdate = NO;
        self->_vertexBufferNeedsUpdate = YES;
    }
}

@end