//
//  SEShader.h
//  SparkEngine
//
//  Created by Diego Marcos on 6/29/12.
//  Copyright (c) 2012. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEShader : NSObject

-(id) initWithVertexShaderSource: (NSString*) vertexShaderSource fragmentShaderSource: (NSString*) fragmentShaderSource; 

@property (readonly) NSDictionary* attributes;
@property (readonly) NSDictionary* uniforms;

@end
