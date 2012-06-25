//
//  SEShape.m
//  SparkEngine
//
//  Created by Diego Marcos on 6/19/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "SEShape.h"

@interface SEShape(){
    NSMutableData* _verticesData;
    NSMutableData* _facesIndicesData;
}
@end

@implementation SEShape

@synthesize vertices = _vertices;
@synthesize numVertices = _numVertices;

@synthesize facesIndices = _facesIndices;
@synthesize numFacesIndices = _numFacesIndices;

@synthesize vertexBuffer = _vertexBuffer;
@synthesize facesIndicesBuffer = _facesIndicesBuffer;

-(id)init
{   self = [super init];
    if (self) {
        self->_vertexBuffer = -1;
        self->_facesIndicesBuffer = -1;
    }
    return self;
}

-(int)numVertices {
    return self->_numVertices;
}

-(int)numFacesIndices {
    return self->_numFacesIndices;
}

- (PSVertexData*) vertices {
    if (self->_verticesData == nil) {
        self->_verticesData = [NSMutableData dataWithLength:sizeof(PSVertexData)*self.numVertices];
        self->_vertices = [self->_verticesData mutableBytes];
    }
    return self->_vertices;
}

-(PSFaceIndices*) facesIndices {
    if (self->_facesIndicesData == nil) {
        self->_facesIndicesData = [NSMutableData dataWithLength:sizeof(PSFaceIndices)*self.numFacesIndices];
        self->_facesIndices = [self->_facesIndicesData mutableBytes];
    }
    return self->_facesIndices;
}


@end
