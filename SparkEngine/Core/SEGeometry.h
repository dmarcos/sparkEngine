//
//  SEGeometry.h
//  SparkEngine
//
//  Created by Diego Marcos on 6/15/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SEVertex.h"

@interface SEGeometry : NSObject

-(id) initWithNumberOfVertices: (int) numVertices numberOfFaces: (int) numFaces vertices: (GLfloat*) vertices facesIndices: (GLushort*) facesIndices;
    
@property (nonatomic) SEVertex* vertices;
@property (nonatomic, readonly) int numVertices;
@property (nonatomic) SEFaceIndices* facesIndices;
@property (nonatomic, readonly) int numFaces;

@end