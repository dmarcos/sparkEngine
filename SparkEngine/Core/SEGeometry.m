//
//  SEGeometry.m
//  SparkEngine
//
//  Created by Diego Marcos on 6/19/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SEGeometry.h"

@interface SEGeometry(){
    NSMutableData* _verticesData;
    NSMutableData* _facesIndicesData;
    NSMutableData* _linesIndicesData;
}
@end

@implementation SEGeometry 

@synthesize vertices = _vertices;
@synthesize numVertices = _numVertices;
@synthesize facesIndices = _facesIndices;
@synthesize numFaces = _numFaces;
@synthesize linesIndices = _linesIndices;
@synthesize numLines = _numLines;


-(id) initWithNumberOfVertices: (int) numVertices vertices: (GLfloat*) vertices numFaces: (int) numFaces facesIndices: (GLushort*) facesIndices{
    self = [super init];
    if (self) {
        self->_numVertices = numVertices;
        self->_numFaces = numFaces;
        if(vertices && facesIndices) {
            for(int i = 0; i < numVertices; ++i) {
                self.vertices[i].position = GLKVector3Make(vertices[i*5], vertices[i*5+1], vertices[i*5+2]);
                self.vertices[i].texture = GLKVector2Make(vertices[i*5+3], vertices[i*5+4]);
            }
            for(int i = 0; i < numFaces; ++i) {
                self.facesIndices[i].a = facesIndices[i*3];
                self.facesIndices[i].b = facesIndices[i*3+1];
                self.facesIndices[i].c = facesIndices[i*3+2];
            }
        }
    }
    return self;
}

-(id) initWithNumberOfVertices: (int) numVertices vertices: (GLfloat*) vertices numFaces: (int) numFaces facesIndices: (GLushort*) facesIndices numLines: (int) numLines linesIndices: (GLushort*) linesIndices{
    self = [self initWithNumberOfVertices: (int) numVertices vertices: (GLfloat*) vertices numFaces: (int) numFaces facesIndices: (GLushort*) facesIndices];
    if (self) {
        self->_numLines = numLines;
        if(linesIndices){
            for(int i = 0; i < numLines; ++i){
                self.linesIndices[i].a = linesIndices[i*2];
                self.linesIndices[i].b = linesIndices[i*2+1];
            }
        }
    }
    return self;
}

-(int) numVertices {
    return self->_numVertices;
}

-(int) numFaces {
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
        for (int i = 0; i < self.numVertices; i++) {
            self->_vertices[i].color = GLKVector4Make(1.0, 0.0, 0.0, 1.0); // Default vertex color. RED. Totally arbitrary :)
        }
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


-(void) setLinesIndices: (SELineIndices*) linesIndices
{
    for (int i =0; i < self->_numLines; ++i) {
        self.linesIndices[i] = linesIndices[i];
    }
}

-(SELineIndices*) linesIndices
{
    if (self->_linesIndicesData == nil) {
        self->_linesIndicesData = [NSMutableData dataWithLength:sizeof(SELineIndices)*self.numLines];
        self->_linesIndices = [self->_linesIndicesData mutableBytes];
    }
    return self->_linesIndices;
}

@end