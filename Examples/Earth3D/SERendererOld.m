//
//  SERenderer.m
//  SparkEngine
//
//  Created by Diego Marcos on 6/11/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "SERendererOld.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>
#import <GLKit/GLKMath.h>
#import <QuartzCore/QuartzCore.h>

@interface SERendererOld(){
    CGRect _viewport;
    EAGLContext* __weak _glContext;
    CAEAGLLayer* _eaglLayer;
    
    // Frame and Render buffer names/ids.
    GLuint		_framebuffer;
    GLuint		_colorbuffer;
    GLuint		_depthbuffer;
    
    // Program Object name/id.
    GLuint		_program;
    
    // Informations about the mesh.
    int			_stride;
    int			_structureCount;
    int			_indicesCount;
    
    // Buffer Objects names/ids.
    GLuint		_boStructure;
    GLuint		_boIndices;
    
    // Texture Object name/id.
    GLuint		_texture;
    
    // Attributes and Uniforms locations.
    GLuint		_uniforms[2];
    GLuint		_attributes[2];
}

-(void) initOpenGL;
-(void) initFrameAndRenderbuffers;
-(void) initProgramAndShaders;
-(void) initMeshBuffers;
-(void) clearBuffers;
-(void) clearOpenGL;
-(void) showBuffers;
-(void) drawSceneWithRotationX: (float) rotationX withRotationY: (float) rotationY withFov: (float) fov withZoom: (float) zoom;
-(GLuint) initBufferObjectWithType: (GLenum) type withSize: (GLsizeiptr) size withData: (const GLvoid*) data;
-(GLuint) initShaderWithType: (GLenum) type withSource: (const char **) source;
-(GLuint) compileProgramWithVertexShader: (GLuint) vertexShader withFragmentShader: (GLuint) fragmentShader;

@end

@implementation SERendererOld

@synthesize viewport = _viewport;
@synthesize glContext = _glContext;

-(id) initWithViewport:(CGRect)viewport withGLContext: (EAGLContext*) glContext withEAGLLayer: (CAEAGLLayer*) eaglLayer
{
    self->_viewport = viewport;
    self->_glContext = glContext;
    self->_eaglLayer = eaglLayer;
    [self initOpenGL];
    return self;
}

-(void) renderWithRotationX: (float) rotationX withRotationY: (float) rotationY withFov: (float) fov withZoom: (float) zoom
{
    [EAGLContext setCurrentContext: self->_glContext];
	[self clearBuffers];
	[self drawSceneWithRotationX: rotationX withRotationY: rotationY withFov: fov withZoom: zoom];
	[self showBuffers];
}

-(void) drawSceneWithRotationX: (float) rotationX withRotationY: (float) rotationY withFov: (float) fov withZoom: (float) zoom
{
    
    // Creates matrix rotations to X and Y.
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0, 0.0, zoom*-4.0);
    modelViewMatrix = GLKMatrix4RotateX(modelViewMatrix, GLKMathDegreesToRadians(rotationX));
    modelViewMatrix = GLKMatrix4RotateY(modelViewMatrix, GLKMathDegreesToRadians(rotationY));
    GLKMatrix4 projectionMatrix;
    GLKMatrix4 modelViewProjectionMatrix;
     
    // Creates Projection Matrix.
    projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(fov), self->_viewport.size.width / self->_viewport.size.height, 0.1, 100.0);
     
    // Multiplies the Projection by the ModelView to create the ModelViewProjection matrix.
    modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    
     //***********************************************
     //  OpenGL Drawing Operations
     //***********************************************
     
     // Starts to use a specific program. In this application this doesn't change anything.
     // But if you have many drawings in your application, then you'll need to constantly change
     // the currently program in use.
     // All the code below will affect directly the Program which is currently in use.
     glUseProgram(self->_program);
     
     // Sets the uniform to MVP Matrix.
     glUniformMatrix4fv(self->_uniforms[0], 1, GL_FALSE, modelViewProjectionMatrix.m);
     
     // Bind the texture to an Texture Unit.
     // Just to illustration purposes, in this case let's use the Texture Unit 7.
     // Remember which OpenGL gives 32 Texture Units.
     glActiveTexture(GL_TEXTURE7);
     glBindTexture(GL_TEXTURE_2D, self->_texture);
     
     
     // Sets the uniform to the desired Texture Unit.
     // As the Texture Unit used is 7, let's set this value to 7.
     glUniform1i(self->_uniforms[1], 7);
     
     // Bind the Buffer Objects which we'll use now.
     glBindBuffer(GL_ARRAY_BUFFER, self->_boStructure);
     glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _boIndices);
     
     // Sets the dynamic attributes in the current shaders. Each attribute will start in a different
     // index of the ABO.
     glVertexAttribPointer(self->_attributes[0], 3, GL_FLOAT, GL_FALSE, _stride, (void *) 0);
     glVertexAttribPointer(self->_attributes[1], 2, GL_FLOAT, GL_FALSE, _stride, (void *) (3 * sizeof(GLfloat)));
     
     // Draws the triangles, starting by the index 0 in the IBO.
     glDrawElements(GL_TRIANGLES, self->_indicesCount, GL_UNSIGNED_SHORT, (void *) 0);
     
     // Unbid all the Buffer Objects currently in use. In this application this doesn't change anything.
     // But in a application with multiple Buffer Objects, this will be crucial.
     glBindBuffer(GL_ARRAY_BUFFER, 0);
     glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
}
     
-(void) clearBuffers
{
    // Clears the color and depth render buffer.
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	// Clears an amount of color in the color render buffer.
	glClearColor(0.2, 0.3, 0.5, 1.0);
}
     
-(void) showBuffers
{
    // Binds the necessary frame buffer and its color render buffer.
	glBindFramebuffer(GL_FRAMEBUFFER, self->_framebuffer);
	glBindRenderbuffer(GL_RENDERBUFFER, self->_colorbuffer);
	
	// Call EAGL process to present the final image to the device's screen.
    [[EAGLContext currentContext] presentRenderbuffer:GL_RENDERBUFFER];
}

-(void) setTexture: (SETexture*) texture
{
    self->_texture = [texture glTextureName];
}

-(void) initOpenGL
{	
	// Creates all the OpenGL objects necessary to an application.
	[self initFrameAndRenderbuffers];
	[self initProgramAndShaders];
	[self initMeshBuffers];
    //[self setTexture: texture]
    [EAGLContext setCurrentContext: self.glContext];
	// Sets the size to OpenGL view.
	glViewport(0, 0, self.viewport.size.width, self.viewport.size.height);
}

-(void) initFrameAndRenderbuffers
{
	// Creates the Frame buffer.
	glGenFramebuffers(1, &self->_framebuffer);
	glBindFramebuffer(GL_FRAMEBUFFER, self->_framebuffer);
    
	// Creates the render buffer.
	// Here the EAGL compels us to change the default OpenGL behavior.
	// Instead to use glRenderbufferStorage(GL_RENDERBUFFER, GL_RGB565, _surfaceWidth, _surfaceHeight);
	// We need to use renderbufferStorage: defined here in the [EAGLView propertiesToCurrentColorbuffer];
	glGenRenderbuffers(1, &self->_colorbuffer);
	glBindRenderbuffer(GL_RENDERBUFFER, self->_colorbuffer);
    [[EAGLContext currentContext] renderbufferStorage:GL_RENDERBUFFER
										 fromDrawable:(CAEAGLLayer *) self->_eaglLayer];
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, self->_colorbuffer);
	
	// Creates the Depth render buffer.
	// Try to don't enable the GL_DEPTH_TEST to see what happens.
	// The render will not respect the Z Depth informations of the 3D objects.
	glGenRenderbuffers(1, &_depthbuffer);
	glBindRenderbuffer(GL_RENDERBUFFER, _depthbuffer);
	glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.viewport.size.width, self.viewport.size.height);
	glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthbuffer);
	glEnable(GL_DEPTH_TEST);
	
	// Checks for the errors in the DEBUG mode. Is very commom make some mistakes at the Frame and
	// Render buffer creation, so is important you make this check, at least while you are learning.
#if defined(DEBUG)
	switch (glCheckFramebufferStatus(GL_FRAMEBUFFER))
	{
		case GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT:
			NSLog(@"Error creating FrameBuffer: Incomplete Attachment.\n");
			break;
		case GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT:
			NSLog(@"Error creating FrameBuffer: Missing Attachment.\n");
			break;
		case GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS:
			NSLog(@"Error creating FrameBuffer: Incomplete Dimensions.\n");
			break;
		case GL_FRAMEBUFFER_UNSUPPORTED:
			NSLog(@"Error creating FrameBuffer: Unsupported Buffers.\n");
			break;
	}
#endif
}

-(void) initProgramAndShaders
{
    const char *vertexShaderSource = "\
	precision mediump float;\
	precision lowp int;\
	\
	uniform mat4			u_mvpMatrix;\
	\
	attribute highp vec4	a_vertex;\
	attribute vec2			a_texCoord;\
	\
	varying vec2			v_texCoord;\
	\
	void main(void)\
	{\
		v_texCoord = a_texCoord;\
        \
		gl_Position = u_mvpMatrix * a_vertex;\
	}";
	
	const char *fragmentShaderSource = "\
	precision mediump float;\
	precision lowp int;\
	\
	uniform sampler2D		u_map;\
	\
	varying vec2			v_texCoord;\
	\
	void main (void)\
	{\
		gl_FragColor = texture2D(u_map, v_texCoord);\
	}";
	
	GLuint vertexShader, fragmentShader;
	
	// Creates the pair of Shaders.
	vertexShader = [self initShaderWithType: GL_VERTEX_SHADER withSource: &vertexShaderSource];
	fragmentShader = [self initShaderWithType: GL_FRAGMENT_SHADER withSource: &fragmentShaderSource];
	
	// Creates the Program Object.
	self->_program = [self compileProgramWithVertexShader: vertexShader withFragmentShader: fragmentShader];
	
	// Clears the shaders objects.
	// In this case we can delete the shaders because we'll not use they anymore,
	// the OpenGL stores a copy of them into the program object.
	glDeleteShader(vertexShader);
	glDeleteShader(fragmentShader);
	
	// Gets the uniforms locations.
	self->_uniforms[0] = glGetUniformLocation(self->_program, "u_mvpMatrix");
	self->_uniforms[1] = glGetUniformLocation(self->_program, "u_map");
	
	// Gets the attributes locations.
	self->_attributes[0] = glGetAttribLocation(self->_program, "a_vertex");
	self->_attributes[1] = glGetAttribLocation(self->_program, "a_texCoord");
	
	// As we'll use only those pair of shaders, let's enable the dynamic attributes to they once.
	glEnableVertexAttribArray(self->_attributes[0]);
	glEnableVertexAttribArray(self->_attributes[1]);
    
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

- (void) initMeshBuffers
{
    
	// Cube structure. 100 floats.
	self->_structureCount = 100;
	GLfloat cubeStructure[] =
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
    
    int octaedronVerticesNumber = 6;
    GLfloat octaedronVertices[] = 
    {
        0.00,0.00,-1.00, -0.00, 0.00,
        1.00,0.00,0.00, 0.00, 0.50,
        0.00,-1.00,0.00, 0.25, 0.50,
        -1.00,0.00,0.00, 0.50, 0.50,
        0.00,1.00,0.00, 0.75, 0.50,
        0.00,0.00,1.00, 0.00, 1.00
    };
    
    self->_indicesCount = 24;
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
    
    GLfloat* sphereVertices;
    GLushort* sphereIndices;
    int sphereIndicesCount;
    int sphereVerticesCount; 
    [self makeSphereGeometryWithRadius: 1.0 withSteps:36 withVertices:&sphereVertices withVerticesCount:&sphereVerticesCount withIndices:& sphereIndices withIndicesCout:&sphereIndicesCount];
	self->_indicesCount = sphereIndicesCount;
    
	// Cube indices. 36 floats.
	//_indicesCount = 36;
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
	
	// Define the stride to the "cubeStructure".
	self->_stride = 5 * sizeof(GLfloat);
	
	// Creates the ABO and IBO.
    //_boStructure = newBufferObject(GL_ARRAY_BUFFER, 30 * sizeof(GLfloat), octaedronVertices);
	//_boIndices = newBufferObject(GL_ELEMENT_ARRAY_BUFFER, 24 * sizeof(GLushort), octaedronIndices);
    self->_boStructure = [self initBufferObjectWithType: GL_ARRAY_BUFFER withSize: sphereVerticesCount * sizeof(GLfloat) withData: sphereVertices];
	self->_boIndices = [self initBufferObjectWithType: GL_ELEMENT_ARRAY_BUFFER withSize: self->_indicesCount * sizeof(GLushort) withData: sphereIndices]; 
    
    //free(sphereVertices);
    //free(sphereIndices);
}

-(void) makeSphereGeometryWithRadius: (float) radius withSteps: (int) steps withVertices: (GLfloat**) vertices withVerticesCount: (int*) sphereVerticesCount withIndices: (GLushort**) indices withIndicesCout: (int*) sphereIndicesCount
{
    
    *vertices = (GLfloat*) malloc(sizeof(GLfloat) * 5 * steps * steps);
    *indices = (GLushort*) malloc(sizeof(GLushort) * 6 * steps * steps);
    *sphereVerticesCount = 0;
    
    for (int latNumber = 0; latNumber <= steps; latNumber++) {
        double theta = (double) latNumber * M_PI / steps;
        double sinTheta = sin(theta);
        double cosTheta = cos(theta);
        for (int longNumber = 0; longNumber <= steps; longNumber++) {
            double phi = (double) longNumber * 2.0 * M_PI / steps;
            double sinPhi = sin(phi);
            double cosPhi = cos(phi);
            
            double x = cosPhi * sinTheta;
            double y = cosTheta;
            double z = sinPhi * sinTheta;
            
            double u = 1 - (double) longNumber / steps;
            double v = (double) latNumber / steps;
            
            (*vertices)[latNumber*(steps+1)*5 + longNumber*5] = radius * x;
            (*vertices)[latNumber*(steps+1)*5 + longNumber*5 + 1] = radius * y;
            (*vertices)[latNumber*(steps+1)*5 + longNumber*5 + 2] = radius * z;
            
            (*vertices)[latNumber*(steps+1)*5 + longNumber*5 + 3] = u;
            (*vertices)[latNumber*(steps+1)*5 + longNumber*5 + 4] = v;
            
            *sphereVerticesCount+=5;
        }
    }
    
    *sphereIndicesCount = 0;
    for (int latNumber = 0; latNumber < steps; latNumber++) {
        for (int longNumber = 0; longNumber < steps; longNumber++) {
            int first = (latNumber * (steps + 1)) + longNumber;
            int second = first + steps + 1;
            
            (*indices)[latNumber*steps*6 + longNumber*6] = first;
            (*indices)[latNumber*steps*6 + longNumber*6 + 1] = second;
            (*indices)[latNumber*steps*6 + longNumber*6 + 2] = first+1;
            
            (*indices)[latNumber*steps*6 + longNumber*6 + 3] = second;
            (*indices)[latNumber*steps*6 + longNumber*6 + 4] = second+1;
            (*indices)[latNumber*steps*6 + longNumber*6 + 5] = first+1;
            
            *sphereIndicesCount+=6;
        }
    }
    
}

- (GLuint) initBufferObjectWithType: (GLenum) type withSize: (GLsizeiptr) size withData: (const GLvoid*) data
{
	GLuint buffer;
	
	// Generates the vertex buffer object (VBO)
	glGenBuffers(1, &buffer);
	
	// Bind the VBO so we can fill it with data
	glBindBuffer(type, buffer);
	glBufferData(type, size, data, GL_STATIC_DRAW);
	
	return buffer;
}

- (void) clearOpenGL
{

    // Delete Buffer Objects.
    glDeleteBuffers(1, &self->_boStructure);
    glDeleteBuffers(1, &self->_boIndices);

    // Delete Programs, remember which the shaders was already deleted before.
    glDeleteProgram(self->_program);

    // Disable the previously enabled attributes to work with dynamic values.
    glDisableVertexAttribArray(self->_attributes[0]);
    glDisableVertexAttribArray(self->_attributes[1]);

    // Delete the Frame and Render buffers.
    glDeleteRenderbuffers(1, &self->_colorbuffer);
    glDeleteRenderbuffers(1, &self->_depthbuffer);
    glDeleteFramebuffers(1, &self->_framebuffer);

}


- (void) dealloc
{
    [self clearOpenGL];
}


@end
