//
//  SEOctaedron.m
//  SparkEngine
//
//  Created by Diego Marcos Segura on 7/30/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SEOctaedron.h"

@implementation SEOctaedron

-(id) initWithMaterial: (SEShaderMaterial*) material
{

    // 6 vertices x, y, z, u, v
    GLfloat octaedronVertices[] =
    {
        0.00,0.00,-1.00, -0.00, 0.00,
        1.00,0.00,0.00, 0.00, 0.50,
        0.00,-1.00,0.00, 0.25, 0.50,
        -1.00,0.00,0.00, 0.50, 0.50,
        0.00,1.00,0.00, 0.75, 0.50,
        0.00,0.00,1.00, 0.00, 1.00
    };
    
    // 8 faces
    GLushort octaedronIndices[] =
    {
        0,1,2,
        0,2,3,
        0,3,4,
        0,4,1,
        5,2,1,
        5,3,2,
        5,4,3,
        5,1,4
    };
            
    return [super initWithGeometry: [[SEGeometry alloc] initWithNumberOfVertices:6 vertices:octaedronVertices numFaces:8 facesIndices:octaedronIndices numLines: 24 linesIndices: nil] material: material];
}

@end
