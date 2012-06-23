//
//  SERenderer.m
//  SparkEngine
//
//  Created by Diego Marcos on 6/17/12.
//  Copyright (c) 2012. All rights reserved.
//

#import "SERenderer.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>
#import <GLKit/GLKMath.h>
#import <QuartzCore/QuartzCore.h>

#import "SESphere.h"

@interface SERenderer(){
    CGRect _viewport;
    EAGLContext* __weak _glContext;
    CAEAGLLayer* _eaglLayer;
    
    // Frame and Render buffer names/ids.
    GLuint		_framebuffer;
    GLuint		_colorbuffer;
    GLuint		_depthbuffer;
    
    // Program Object name/id.
    GLuint		_program;
    
    SESphere* sphere;
    
    // Texture Object name/id.
    GLuint		_texture;
    
    // Attributes and Uniforms locations.
    GLuint		_uniforms[2];
    GLuint		_attributes[2];
    
    // Buffer Objects names/ids.
    GLuint		_boVertices;
    GLuint		_boFacesIndices;
}

-(void) initOpenGL;
-(void) initFrameAndRenderbuffers;
-(void) initProgramAndShaders;
-(void) clearBuffers;
-(void) clearOpenGL;
-(void) showBuffers;
-(void) drawSceneWithRotationX: (float) rotationX withRotationY: (float) rotationY withFov: (float) fov withZoom: (float) zoom;
-(GLuint) initBufferObjectWithType: (GLenum) type withSize: (GLsizeiptr) size withData: (const GLvoid*) data;
-(GLuint) initShaderWithType: (GLenum) type withSource: (const char **) source;
-(GLuint) compileProgramWithVertexShader: (GLuint) vertexShader withFragmentShader: (GLuint) fragmentShader;

@end

@implementation SERenderer

@synthesize viewport = _viewport;
@synthesize glContext = _glContext;

-(id) initWithViewport:(CGRect)viewport withGLContext: (EAGLContext*) glContext withEAGLLayer: (CAEAGLLayer*) eaglLayer
{
    self->_viewport = viewport;
    self->_glContext = glContext;
    self->_eaglLayer = eaglLayer;
    self->sphere = [[SESphere alloc] initWithRadius:1.0 withSteps:36];
    
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
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, self->_boFacesIndices);
    // Sets the dynamic attributes in the current shaders. Each attribute will start in a different
    // index of the ABO.
    glBindBuffer(GL_ARRAY_BUFFER, self->_boVertices);
    
    glVertexAttribPointer(self->_attributes[0], 3, GL_FLOAT, GL_FALSE, sizeof(PSVertexData), (void *) 0);    
    glVertexAttribPointer(self->_attributes[1], 2, GL_FLOAT, GL_FALSE, sizeof(PSVertexData), (void *) (sizeof(GLKVector3)));
    
    // Draws the triangles, starting by the index 0 in the IBO.
    glDrawElements(GL_TRIANGLES, self->sphere.numFacesIndices * 3, GL_UNSIGNED_SHORT, (void *) 0);
    
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
    
    self->_boVertices = [self initBufferObjectWithType: GL_ARRAY_BUFFER withSize: sphere.numVertices * sizeof(PSVertexData) withData: sphere.vertices];
	self->_boFacesIndices = [self initBufferObjectWithType: GL_ELEMENT_ARRAY_BUFFER withSize: sphere.numFacesIndices * sizeof(PSFaceIndices) withData: sphere.facesIndices];
    
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
    glDeleteBuffers(1, &self->_boVertices);
    glDeleteBuffers(1, &self->_boFacesIndices);
    
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

