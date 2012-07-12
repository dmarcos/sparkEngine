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

#import "SEScene.h"
#import "SEMesh.h"
#import "SEShader.h"
#import "SEPerspectiveCamera.h"

@interface SERenderer(){
    CGRect _viewport;
    EAGLContext* __weak _glContext;
    CAEAGLLayer* _eaglLayer;
    
    // Frame and Render buffer names/ids.
    GLuint		_framebuffer;
    GLuint		_colorbuffer;
    GLuint		_depthbuffer;

    // Texture Object name/id.
    GLuint		_texture;
    
    NSMutableArray* _bufferObjectIndices;
    
    bool _updateObjects;
}

-(void) initOpenGL;
-(void) initFrameAndRenderbuffers;
-(void) clearBuffers;
-(void) clearOpenGL;
-(void) showBuffers;
-(void) drawScene: (SEScene*) scene camera: (SEPerspectiveCamera*) camera;
-(void) updateBufferObjectsInScene: (SEScene*) scene;
-(GLuint) initBufferObjectWithType: (GLenum) type withSize: (GLsizeiptr) size withData: (const GLvoid*) data;

@end

@implementation SERenderer

@synthesize viewport = _viewport;
@synthesize glContext = _glContext;

-(id) initWithViewport:(CGRect)viewport withGLContext: (EAGLContext*) glContext withEAGLLayer: (CAEAGLLayer*) eaglLayer
{
    self->_viewport = viewport;
    self->_glContext = glContext;
    self->_eaglLayer = eaglLayer;
    self->_updateObjects = true;
    
    [self initOpenGL];
    return self;
}

-(void) renderScene: (SEScene*) scene camera: (SEPerspectiveCamera*) camera
{
    [EAGLContext setCurrentContext: self->_glContext];
	[self clearBuffers];
    if(self->_updateObjects){
        [self updateBufferObjectsInScene: scene];
        self->_updateObjects = false;
    }
	[self drawScene: scene camera: camera];
	[self showBuffers];
}

-(void) drawScene: (SEScene*) scene camera: (SEPerspectiveCamera*) camera
{    
    // Multiplies the Projection by the ModelView to create the ModelViewProjection matrix.
    GLKMatrix4 modelViewProjectionMatrix = GLKMatrix4Multiply(camera.projectionMatrix, scene.matrix);
    
    NSEnumerator *e = [scene.objects objectEnumerator];
    SEShader* currentShader;
    id object;
    while (object = [e nextObject]) {
        
        currentShader = [object shader];
        //***********************************************
        //  OpenGL Drawing Operations
        //***********************************************
        
        // Starts to use a specific program. In this application this doesn't change anything.
        // But if you have many drawings in your application, then you'll need to constantly change
        // the currently program in use.
        // All the code below will affect directly the Program which is currently in use.
        glUseProgram(currentShader.programId);
        
        // Sets the uniform to MVP Matrix.
        glUniformMatrix4fv(currentShader.u_mvpMatrix, 1, GL_FALSE, modelViewProjectionMatrix.m);
        
        // Bind the texture to an Texture Unit.
        // Just to illustration purposes, in this case let's use the Texture Unit 7.
        // Remember which OpenGL gives 32 Texture Units.
        glActiveTexture(GL_TEXTURE7);
        glBindTexture(GL_TEXTURE_2D, self->_texture);
        
        // Sets the uniform to the desired Texture Unit.
        // As the Texture Unit used is 7, let's set this value to 7.
        glUniform1i(currentShader.u_map, 7);
        
        // Bind the Buffer Objects which we'll use now.
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, [object facesIndicesBuffer]);
        // Sets the dynamic attributes in the current shaders. Each attribute will start in a different
        // index of the ABO.
        glBindBuffer(GL_ARRAY_BUFFER, [object vertexBuffer]);
        
        glVertexAttribPointer(currentShader.a_vertex, 3, GL_FLOAT, GL_FALSE, sizeof(SEVertex), (void *) 0);    
        glVertexAttribPointer(currentShader.a_texCoord, 2, GL_FLOAT, GL_FALSE, sizeof(SEVertex), (void *) (sizeof(GLKVector3)));
        glVertexAttribPointer(currentShader.a_vertexColor, 4, GL_FLOAT, GL_FALSE, sizeof(SEVertex), (void *) (sizeof(GLKVector3)*2 + sizeof(GLKVector2)));

        // Draws the triangles, starting by the index 0 in the IBO.
        glDrawElements(GL_TRIANGLES, [[object geometry] numFaces] * 3, GL_UNSIGNED_SHORT, (void *) 0);
        
    }
    
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
	glClearColor(0.0, 0.0, 0.0, 1.0);
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
    //[self setTexture: texture]
    [EAGLContext setCurrentContext: self.glContext];
	// Sets the size to OpenGL view.
	glViewport(0, 0, self.viewport.size.width, self.viewport.size.height);
}

-(void) updateBufferObjectsInScene: (SEScene*) scene
{
    NSEnumerator *e = [scene.objects objectEnumerator];
    id object;
    while (object = [e nextObject]) {
        [object setVertexBuffer: [self initBufferObjectWithType: GL_ARRAY_BUFFER withSize: [[object geometry] numVertices] * sizeof(SEVertex) withData: [[object geometry] vertices]]];
        [object setFacesIndicesBuffer: [self initBufferObjectWithType: GL_ELEMENT_ARRAY_BUFFER withSize: [[object geometry ] numFaces] * sizeof(SEFaceIndices) withData: [[object geometry] facesIndices]]];
    }
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
	
    [[EAGLContext currentContext] renderbufferStorage:GL_RENDERBUFFER
										 fromDrawable:(CAEAGLLayer *) self->_eaglLayer];
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

- (GLuint) initBufferObjectWithType: (GLenum) type withSize: (GLsizeiptr) size withData: (const GLvoid*) data
{
	GLuint buffer;
	
	// Generates the vertex buffer object (VBO)
	glGenBuffers(1, &buffer);
	
    [self->_bufferObjectIndices addObject: [[NSNumber alloc] initWithInt: buffer]];
    
	// Bind the VBO so we can fill it with data
	glBindBuffer(type, buffer);
	glBufferData(type, size, data, GL_STATIC_DRAW);
	
	return buffer;
}

- (void) clearOpenGL
{
    
    NSEnumerator *e = [self->_bufferObjectIndices objectEnumerator];
    id object;
    while (object = [e nextObject]) {
        // Delete Buffer Objects.
        GLuint bufferId = [object intValue];
        glDeleteBuffers(1, &bufferId);
    }

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