//
//  SEGeometry.h
//  SparkEngine
//
//  Created by Diego Marcos on 6/15/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "SEVertex.h"

@interface SEGeometry : NSObject

-(id) initWithNumberOfVertices: (int) numVertices numberOfFaces: (int) numFaces;
    
@property (nonatomic) SEVertex* vertices;
@property (nonatomic, readonly) int numVertices;
@property (nonatomic) SEFaceIndices* facesIndices;
@property (nonatomic, readonly) int numFaces;

@end