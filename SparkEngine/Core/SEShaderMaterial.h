//
//  SEShaderMaterial.h
//  SparkEngine
//
//  Created by Diego Marcos on 7/17/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SEMaterial.h"

@class SEShader;

@interface SEShaderMaterial : SEMaterial

@property (strong, nonatomic) SEShader* shader;

@end
