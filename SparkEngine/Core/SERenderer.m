//
//  SERenderer.m
//  SparkEngine
//
//  Created by Diego Marcos on 6/17/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
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
    CAEAGLLayer* _eaglLayer;

    // Frame and Render buffer names/ids.
    GLuint		_framebuffer;
    GLuint		_colorbuffer;
    GLuint		_depthbuffer;

    NSMutableArray* _bufferObjectIndices;
}

-(void) clearOpenGL;

-(void) initRenderBuffers;
-(void) deleteRenderBuffers;
-(void) clearRenderBuffers;
-(void) showRenderBuffers;

-(void) drawScene:(SEScene*)scene camera:(SECamera*)camera;

-(void) updateBufferObjectsInScene:(SEScene*)scene;
-(GLuint) initBufferObjectWithType:(GLenum)type size:(GLsizeiptr)size data:(const GLvoid*)data;
-(void) updateBufferObject:(GLuint)bufferId type:(GLenum)type size:(GLsizeiptr)size data:(const GLvoid*)data;
-(void) deleteBufferObject:(GLuint)bufferId;

@end

@implementation SERenderer

@synthesize glContext = _glContext;
@synthesize delegate = _delegate;
@synthesize viewport = _viewport;

- (id) initWithGLContext: (EAGLContext*) glContext withEAGLLayer: (CAEAGLLayer*) eaglLayer;
{
    if (eaglLayer && glContext) { // Provided EAGL layer and OpenGL context trigger manual initialization of OpenGL.
        self->_glContext = glContext;
        self->_eaglLayer = eaglLayer;
        self->_framebuffer = -1;
        self->_colorbuffer = -1;
        self->_depthbuffer = -1;
        self->_viewport = eaglLayer.bounds;
        [EAGLContext setCurrentContext: self->_glContext];
        [self initRenderBuffers];
    }
    return self;
}

-(void) setViewport:(CGRect)viewport
{
    self->_viewport = viewport;
    if (self->_glContext) {
        [EAGLContext setCurrentContext: self->_glContext];
    }
    [self deleteRenderBuffers];
    [self initRenderBuffers];
}

-(void) preRenderScene
{
    // Actions before rendering the scene
    if(self->_delegate && [self->_delegate respondsToSelector:@selector(preRenderScene)]) {
        [self->_delegate preRenderScene];
    }
}

-(void) postRenderScene
{
    // Actions after rendering the scene
    if(self->_delegate && [self->_delegate respondsToSelector:@selector(postRenderScene)]) {
        [self->_delegate postRenderScene];
    }
}

-(void) renderScene:(SEScene*)scene camera:(SECamera*)camera viewport:(CGRect) viewport
{
    self->_viewport = viewport;
    if (self->_glContext) {
        [EAGLContext setCurrentContext: self->_glContext];
        glViewport(0, 0, self->_viewport.size.width, self->_viewport.size.height);
    }
	[self clearRenderBuffers];
    [self preRenderScene];
    [self updateBufferObjectsInScene: scene];
	[self drawScene: scene camera: camera];
    [self postRenderScene];
	[self showRenderBuffers];
}

-(void) drawScene:(SEScene*)scene camera:(SEPerspectiveCamera*)camera
{    
    // Multiplies the Projection by the ModelView to create the ModelViewProjection matrix.
    GLKMatrix4 modelViewProjectionMatrix = GLKMatrix4Multiply(camera.projectionMatrix, scene.matrix);
    
    NSEnumerator *e = [scene.objects objectEnumerator];
    SEShader* currentShader;
    id currentMaterial;
    id object;
    while (object = [e nextObject]) {
        
        currentMaterial = [object material];
        if ([currentMaterial isKindOfClass:[SEShaderMaterial class]]) {
            currentShader = [currentMaterial shader];
        }
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
        
        if ([object isKindOfClass:[SEMesh class]]) {
            if ([object respondsToSelector:@selector(material)]) {
                glBindTexture(GL_TEXTURE_2D, [[[object material] texture] glTextureName]);
            }
        }
        
        // Sets the uniform to the desired Texture Unit.
        // As the Texture Unit used is 7, let's set this value to 7.
        glUniform1i(currentShader.u_map, 7);
        
        // Sets the dynamic attributes in the current shaders. Each attribute will start in a different
        // index of the ABO.
        glBindBuffer(GL_ARRAY_BUFFER, [object vertexBuffer]);
        
        glEnableVertexAttribArray(currentShader.a_vertex);
        glEnableVertexAttribArray(currentShader.a_texCoord);
        glEnableVertexAttribArray(currentShader.a_vertexColor);
        
        glVertexAttribPointer(currentShader.a_vertex, 3, GL_FLOAT, GL_FALSE, sizeof(SEVertex), (void *) 0);    
        glVertexAttribPointer(currentShader.a_texCoord, 2, GL_FLOAT, GL_FALSE, sizeof(SEVertex), (void *) (sizeof(GLKVector3)));
        glVertexAttribPointer(currentShader.a_vertexColor, 4, GL_FLOAT, GL_FALSE, sizeof(SEVertex), (void *) (sizeof(GLKVector3)*2 + sizeof(GLKVector2)));

        // Draw primitives
        if ([currentMaterial wireframe]) {
            // Draws the triangles, starting by the index 0 in the IBO.
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, [object linesIndicesBuffer]);
            glDrawElements(GL_LINES, [[object geometry] numLines] * 2, GL_UNSIGNED_SHORT, (void *) 0);
        } else if ([currentMaterial pointCloud]) {
            glDrawArrays(GL_POINTS, 0, [[object geometry] numVertices]);
        } else {
            glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, [object facesIndicesBuffer]);
            glDrawElements(GL_TRIANGLES, [[object geometry] numFaces] * 3, GL_UNSIGNED_SHORT, (void *) 0);
        }
        
        glDisableVertexAttribArray(currentShader.a_vertex);
        glDisableVertexAttribArray(currentShader.a_texCoord);
        glDisableVertexAttribArray(currentShader.a_vertexColor);
        
    }
    
    // Unbid all the Buffer Objects currently in use. In this application this doesn't change anything.
    // But in a application with multiple Buffer Objects, this will be crucial.
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
}

-(void) clearRenderBuffers
{
    // Clears the color and depth render buffer.
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	// Clears an amount of color in the color render buffer.
	glClearColor(0.0, 0.0, 0.0, 1.0);
}

-(void) showRenderBuffers
{
    // Binds the necessary frame buffer and its color render buffer.
	glBindFramebuffer(GL_FRAMEBUFFER, self->_framebuffer);
	glBindRenderbuffer(GL_RENDERBUFFER, self->_colorbuffer);
	// Call EAGL process to present the final image to the device's screen.
    [[EAGLContext currentContext] presentRenderbuffer:GL_RENDERBUFFER];
}

-(void) updateBufferObjectsInScene:(SEScene*)scene
{
    NSEnumerator *e = [scene.objects objectEnumerator];
    id object;
    while (object = [e nextObject]) {
        if ([[object geometry] numVertices] > 0 && [object vertexBufferNeedsUpdate]) {
            if ([object vertexBuffer] == -1){
                [object setVertexBuffer: [self initBufferObjectWithType:GL_ARRAY_BUFFER size:[[object geometry] numVertices]*sizeof(SEVertex) data:[[object geometry] vertices]]];
            } else {
                [self updateBufferObject:[object vertexBuffer] type:GL_ARRAY_BUFFER size:[[object geometry] numVertices]*sizeof(SEVertex) data:[[object geometry] vertices]];
                [object setVertexBufferNeedsUpdate: NO];
            }
        }
        if ([[object geometry] numFaces] > 0 && [object facesIndicesBuffer] == -1){
            [object setFacesIndicesBuffer: [self initBufferObjectWithType: GL_ELEMENT_ARRAY_BUFFER size:[[object geometry ] numFaces] * sizeof(SEFaceIndices) data:[[object geometry] facesIndices]]];
        }
        if ([[object geometry] numLines] > 0 && [object linesIndicesBuffer] == -1) {
            [object setLinesIndicesBuffer: [self initBufferObjectWithType: GL_ELEMENT_ARRAY_BUFFER size:[[object geometry ] numLines] * sizeof(SEFaceIndices) data:[[object geometry] linesIndices]]];
        }
    }
}

-(void) deleteBufferObject:(GLuint)bufferId
{
    glDeleteBuffers(1, &bufferId);
}

-(void) initRenderBuffers
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
	glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self->_viewport.size.width, self->_viewport.size.height);
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

-(void) deleteRenderBuffers
{
    // Delete the Frame and Render buffers.
    if (self->_colorbuffer != -1) {
        glDeleteRenderbuffers(1, &self->_colorbuffer);
    }
    if (self->_depthbuffer != -1) {
        glDeleteRenderbuffers(1, &self->_depthbuffer);
    }
    if (self->_framebuffer != -1) {
        glDeleteFramebuffers(1, &self->_framebuffer);
    }
}

- (GLuint) initBufferObjectWithType:(GLenum)type size:(GLsizeiptr)size data:(const GLvoid*)data
{
	GLuint bufferId;
	
	// Generates the vertex buffer object (VBO)
	glGenBuffers(1, &bufferId);
	
    [self->_bufferObjectIndices addObject: [[NSNumber alloc] initWithInt: bufferId]];
    
	// Bind the VBO so we can fill it with data
    [self updateBufferObject:(GLuint)bufferId type:type size:size data:data];
	
	return bufferId;
}

- (void) updateBufferObject:(GLuint)bufferId type:(GLenum)type size:(GLsizeiptr)size data:(const GLvoid*)data
{
    glBindBuffer(type, bufferId);
	glBufferData(type, size, data, GL_STATIC_DRAW);
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
    [self deleteRenderBuffers];
}

- (void) dealloc
{
    [self clearOpenGL];
}

@end