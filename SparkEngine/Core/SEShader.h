//
//  SEShader.h
//  SparkEngine
//
//  Created by Diego Marcos on 6/29/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>

@interface SEShader : NSObject

+(SEShader*) defaultShader;
+(NSString*) defaultVertexShader;
+(NSString*) defaultFragmentShader;

+(NSString*) vertexShaderPrefix;
+(NSString*) fragmentShaderPrefix;

-(id) initWithVertexShaderSource:(NSString*)vertexShaderSource fragmentShaderSource:(NSString*)fragmentShaderSource;
-(id) initWithVertexShaderFileName:(NSString*)vertexShaderFileName fragmentShaderFileName:(NSString*)fragmentShaderFileName;

@property (readonly) NSDictionary* attributes;
@property (readonly) NSDictionary* uniforms;

@property (nonatomic, readonly) GLuint programId;

// Uniforms
@property (readonly) GLuint u_mvpMatrix;
@property (readonly) GLuint u_map;

// Attributes
@property (readonly) GLuint a_vertex;
@property (readonly) GLuint a_texCoord;
@property (readonly) GLuint a_vertexColor;

@end
