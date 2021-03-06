//
//  SEMaterial.h
//  SparkEngine
//
//  Created by Diego Marcos on 7/17/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKMath.h>
#import "SETexture.h"

@interface SEMaterial : NSObject

typedef enum {
    Triangles,
    PointCloud,
    WireFrame
} SERenderStyle;

@property (nonatomic, strong) SETexture* texture; 
@property (nonatomic) GLKVector4* verticesColors;
@property (nonatomic) GLKVector4 color;

@property (nonatomic) SERenderStyle renderStyle;

@end