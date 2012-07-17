//
//  SEVertex.h
//  SparkEngine
//
//  Created by Diego Marcos on 6/25/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import <GLKit/GLKMath.h>

struct SEVertex
{
    //vertices
    GLKVector3 position;
    
    //texture coordinates
    GLKVector2 texture;
    
    //normals
    GLKVector3 normal;
    
    //color
    GLKVector4 color;
    
};
typedef struct SEVertex SEVertex;

struct SEFaceIndices
{
    //vertex indices
    GLushort a;
    GLushort b;
    GLushort c;
};
typedef struct SEFaceIndices SEFaceIndices;