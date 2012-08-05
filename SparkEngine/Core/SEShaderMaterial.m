//
//  SEShaderMaterial.m
//  SparkEngine
//
//  Created by Diego Marcos on 7/17/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SEShaderMaterial.h"
#import "SEShader.h"

@implementation SEShaderMaterial

@synthesize shader = _shader;

-(SEShader*) shader
{
    if(!self->_shader){
        self->_shader = [SEShader defaultShader];
    }
    return self->_shader;
}

@end