//
//  SEShader.m
//  SparkEngine
//
//  Created by Diego Marcos on 6/29/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "SEShader.h"
#import <OpenGLES/ES2/gl.h>

@interface SEShader()

-(GLuint) initShaderWithType: (GLenum) type withSource: (const char **) source;
-(GLuint) compileProgramWithVertexShader: (GLuint) vertexShader withFragmentShader: (GLuint) fragmentShader;

@end

@implementation SEShader

@synthesize programId = _programId;

@synthesize attributes = _attributes;
@synthesize uniforms = _uniforms;

// Uniforms
@synthesize u_mvpMatrix = _u_mvpMatrix;
@synthesize u_map = _u_map;

// Attributes
@synthesize a_vertex = _a_vertex;
@synthesize a_texCoord = _a_texCoord;
@synthesize a_vertexColor = _a_vertexColor;

-(id) initWithVertexShaderSource: (const char **) vertexShaderSource fragmentShaderSource: (const char **)fragmentShaderSource
{
    self = [super init];
    if(self){
        GLuint vertexShaderId = [self initShaderWithType: GL_VERTEX_SHADER withSource: vertexShaderSource];
        GLuint fragmentShaderId = [self initShaderWithType: GL_FRAGMENT_SHADER withSource: fragmentShaderSource];
        self->_programId = [self compileProgramWithVertexShader: vertexShaderId withFragmentShader: fragmentShaderId];
        // Clears the shaders objects.
        // The OpenGL stores a copy of them into the program object.
        glDeleteShader(vertexShaderId);
        glDeleteShader(fragmentShaderId);
        // Gets the uniforms locations.
        self->_u_mvpMatrix = glGetUniformLocation(self->_programId, "u_mvpMatrix");
        self->_u_map = glGetUniformLocation(self->_programId, "u_map");
        
        // Gets the attributes locations.
        self->_a_vertex = glGetAttribLocation(self->_programId, "a_vertex");
        self->_a_texCoord = glGetAttribLocation(self->_programId, "a_texCoord");
        self->_a_vertexColor = glGetAttribLocation(self->_programId, "a_vertexColor");
        
        // As we'll use only those pair of shaders, let's enable the dynamic attributes to they once.
        glEnableVertexAttribArray(self->_a_vertex);
        glEnableVertexAttribArray(self->_a_texCoord);
        glEnableVertexAttribArray(self->_a_vertexColor);
    }
    return self;  
};

-(GLuint) initShaderWithType: (GLenum) type withSource: (const char **) source
{
	GLuint name = glCreateShader(type);
	
	// Uploads the source to the Shader Object.
	glShaderSource(name, 1, source, NULL);
	
	// Compiles the Shader Object.
	glCompileShader(name);
	
	// If are running in debug mode, query for info log.
	// DEBUG is a pre-processing Macro defined to the compiler.
	// Some languages could not has a similar to it.
#if defined(DEBUG)
	
	GLint logLength;
	
	// Instead use GL_INFO_LOG_LENGTH we could use COMPILE_STATUS.
	// I prefer to take the info log length, because it'll be 0 if the
	// shader was successful compiled. If we use COMPILE_STATUS
	// we will need to take info log length in case of a fail anyway.
	glGetShaderiv(name, GL_INFO_LOG_LENGTH, &logLength);
	
	if (logLength > 0)
	{
		// Allocates the necessary memory to retrieve the message.
		GLchar *log = (GLchar *)malloc(logLength);
		
		// Get the info log message.
		glGetShaderInfoLog(name, logLength, &logLength, log);
		
		// Shows the message in console.
		printf("Error in Shader Creation:\n%s\n",log);
		
		// Frees the allocated memory.
		free(log);
	}
#endif
	
	return name;
}

- (GLuint) compileProgramWithVertexShader: (GLuint) vertexShader withFragmentShader: (GLuint) fragmentShader
{
    // Creates the program name/index.
	GLuint name = glCreateProgram();
	
	// Will attach the fragment and vertex shaders to the program object.
	glAttachShader(name, vertexShader);
	glAttachShader(name, fragmentShader);
	
	// Will link the program into OpenGL core.
	glLinkProgram(name);
    
	GLint logLength;
	
	// Instead use GL_INFO_LOG_LENGTH we could use COMPILE_STATUS.
	// I prefer to take the info log length, because it'll be 0 if the
	// shader was successful compiled. If we use COMPILE_STATUS
	// we will need to take info log length in case of a fail anyway.
	glGetProgramiv(name, GL_INFO_LOG_LENGTH, &logLength);
	
	if (logLength > 0)
	{
		// Allocates the necessary memory to retrieve the message.
		GLchar *log = (GLchar *)malloc(logLength);
		
		// Get the info log message.
		glGetProgramInfoLog(name, logLength, &logLength, log);
		
		// Shows the message in console.
		NSLog(@"Error in Program Creation:\n%s\n",log);
		
		// Frees the allocated memory.
		free(log);
	}
	
	return name;
}

-(void) dealloc
{
    // Delete Programs, remember which the shaders was already deleted before.
    glDeleteProgram(self->_programId);
    
    // Disable the previously enabled attributes to work with dynamic values.
    glDisableVertexAttribArray(self->_a_vertex);
    glDisableVertexAttribArray(self->_a_texCoord);
    glDisableVertexAttribArray(self->_a_vertexColor);
}


@end
