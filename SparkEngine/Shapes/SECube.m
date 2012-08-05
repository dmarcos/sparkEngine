//
//  SECube.m
//  SparkEngine
//
//  Created by Diego Marcos Segura on 7/30/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SECube.h"

@implementation SECube

-(id) initWithMaterial:(SEShaderMaterial*)material
{
    // 20 vertices x, y, z, u, v
    GLfloat cubeVertices[] =
    {
        0.50, -0.50, -0.50, -0.00, 0.00,
        0.50, -0.50, 0.50, 0.33, 0.00,
        -0.50, -0.50, 0.50, 0.33, 0.33,
        -0.50, -0.50, -0.50, -0.00, 0.33,
        0.50, 0.50, -0.50, 0.67, 0.33,
        0.50, -0.50, -0.50, 0.33, 0.33,
        -0.50, -0.50, -0.50, 0.33, 0.00,
        -0.50, 0.50, -0.50, 0.67, 0.00,
        0.50, 0.50, 0.50, 0.67, 0.67,
        0.50, -0.50, 0.50, 0.33, 0.67,
        -0.50, 0.50, 0.50, 0.67, 1.00,
        -0.50, -0.50, 0.50, 0.33, 1.00,
        -0.50, 0.50, -0.50, 0.33, 1.00,
        -0.50, -0.50, -0.50, -0.00, 1.00,
        -0.50, -0.50, 0.50, -0.00, 0.67,
        -0.50, 0.50, 0.50, 0.33, 0.67,
        -0.50, 0.50, 0.50, -0.00, 0.67,
        0.50, 0.50, 0.50, -0.00, 0.33,
        0.50, 0.50, -0.50, 0.33, 0.33,
        -0.50, 0.50, -0.50, 0.33, 0.67,
    };
    
    // 12 faces
    GLushort cubeIndices[] =
    {
        0, 1, 2,
        2, 3, 0,
        4, 5, 6,
        6, 7, 4,
        8, 9, 5,
        5, 4, 8,
        10, 11, 9,
        9, 8, 10,
        12, 13, 14,
        14, 15, 12,
        16, 17, 18,
        18, 19, 16,
    };
    
    // 20 lines
    GLushort linesIndices[] =
    {
        0,1,0,2,1,2,
        2,3,2,0,3,0,
        4,5,4,6,5,6,
        6,7,6,4,7,4,
        8,9,8,5,9,5,
        5,4,5,8,4,8,
        10,11,10,9,11,9,
        9,8,9,10,8,10,
        12,13,12,14,13,14,
        14,15,14,12,15,12,
        16,17,16,18,17,18,
        18,19,18,16,19,16
    };
    
    return [super initWithGeometry: [[SEGeometry alloc] initWithNumberOfVertices:20 vertices:cubeVertices numFaces:12 facesIndices:cubeIndices numLines:36 linesIndices:linesIndices] material:material];
       
}

@end