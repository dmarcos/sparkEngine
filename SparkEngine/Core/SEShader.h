//
//  SEShader.h
//  SparkEngine
//
//  Created by Diego Marcos on 6/29/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEShader : NSObject

+(SEShader*) defaultShader;

-(id) initWithVertexShaderSource: (const char **) vertexShaderSource fragmentShaderSource: (const char **) fragmentShaderSource; 

-(id) initWithVertexShaderFileName: (NSString*) vertexShaderFileName fragmentShaderFileName: (NSString*) fragmentShaderFileName;

@property (readonly) NSDictionary* attributes;
@property (readonly) NSDictionary* uniforms;

@property GLuint programId;

// Uniforms
@property GLuint u_mvpMatrix;
@property GLuint u_map;

// Attributes
@property GLuint a_vertex;
@property GLuint a_texCoord;
@property GLuint a_vertexColor;

@end
