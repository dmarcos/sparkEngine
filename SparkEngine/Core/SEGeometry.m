//
//  SEGeometry.m
//  SparkEngine
//
//  Created by Diego Marcos on 6/19/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "SEGeometry.h"

@interface SEGeometry(){
    NSMutableData* _verticesData;
    NSMutableData* _facesIndicesData;
}
@end

@implementation SEGeometry 

@synthesize vertices = _vertices;
@synthesize numVertices = _numVertices;
@synthesize facesIndices = _facesIndices;
@synthesize numFaces = _numFaces;

-(id) initWithNumberOfVertices: (int) numVertices numberOfFaces: (int) numFaces{
    self = [self init];
    if (self) {
        self->_numVertices = numVertices;
        self->_numFaces = numFaces;
    }
    return self;
}

-(int)numVertices {
    return self->_numVertices;
}

-(int)numFaces {
    return self->_numFaces;
}

-(void) setVertices: (SEVertex*) vertices 
{
    for (int i =0; i < self->_numVertices; ++i) {
        self.vertices[i] = vertices[i];
    }
}

-(SEVertex*) vertices {
    if (self->_vertices == nil) {
        self->_verticesData = [NSMutableData dataWithLength:sizeof(SEVertex)*self.numVertices];
        self->_vertices = [self->_verticesData mutableBytes];
    }
    return self->_vertices;
}

-(void) setFacesIndices: (SEFaceIndices*) facesIndices
{
    for (int i =0; i < self->_numFaces; ++i) {
        self.facesIndices[i] = facesIndices[i];
    }
}

-(SEFaceIndices*) facesIndices 
{
    if (self->_facesIndicesData == nil) {
        self->_facesIndicesData = [NSMutableData dataWithLength:sizeof(SEFaceIndices)*self.numFaces];
        self->_facesIndices = [self->_facesIndicesData mutableBytes];
    }
    return self->_facesIndices;
}

@end