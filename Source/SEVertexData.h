//
//  SEVerticesData.h
//  SparkEngine
//
//  Created by Diego Marcos on 6/15/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <GLKit/GLKMath.h>

struct SEVertexData
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
typedef struct SEVertexData SEVertexData;

struct SEFaceIndices
{
    //vertex indices
    GLushort a;
    GLushort b;
    GLushort c;
};
typedef struct SEFaceIndices SEFaceIndices;

