//
//  SEGeometry.h
//  SparkEngine
//
//  Created by Diego Marcos on 6/15/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SEVertex.h"

@interface SEGeometry : NSObject

-(id) initWithNumberOfVertices:(int)numVertices vertices:(GLfloat*)vertices
                      numFaces:(int)numFaces facesIndices:(GLushort*)facesIndices;

-(id) initWithNumberOfVertices:(int)numVertices vertices:(GLfloat*)vertices
                      numFaces:(int)numFaces facesIndices:(GLushort*)facesIndices
                      numLines:(int)numLines linesIndices:(GLushort*)linesIndices;
    
@property (nonatomic) SEVertex* vertices;
@property (nonatomic, readonly) int numVertices;
@property (nonatomic) SEFaceIndices* facesIndices;
@property (nonatomic, readonly) int numFaces;
@property (nonatomic) SELineIndices* linesIndices;
@property (nonatomic, readonly) int numLines;

@end