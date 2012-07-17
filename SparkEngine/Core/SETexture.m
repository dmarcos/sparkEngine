//
//  SETexture.m
//  SparkEngine
//
//  Created by Diego Marcos on 6/11/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SETexture.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface SETexture(){
    GLuint textureName;
    CGImageRef image;
}

- (GLuint) createGLTextureWithData: (void*) data withWidth: (int) width withHeight: (int) height; 

@end

@implementation SETexture

@synthesize glTextureName;

- (id) initWithImage:(UIImage *)uiImage
{
    self->image = [uiImage CGImage];
    CGImageRetain(self->image);
    
    // Extracts the pixel informations and place it into the data.
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int imageHeight = CGImageGetHeight(image);
    int imageWidth = CGImageGetWidth(image);
    void* pixelData = malloc(imageWidth * imageHeight * 4);
    CGContextRef context = CGBitmapContextCreate(pixelData, imageWidth, imageHeight, 8, 4 *imageWidth, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    // Clears and ReDraw the image into the context.
    CGContextClearRect(context, CGRectMake(0, 0, imageWidth, imageHeight));
    UIGraphicsBeginImageContextWithOptions([uiImage size], NO, 0);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), self->image);
    UIGraphicsEndImageContext();
    // Releases the context.
    CGContextRelease(context);
    
    self->glTextureName = [self createGLTextureWithData:pixelData withWidth:imageWidth withHeight:imageHeight];
    
    return self;
}

- (GLuint) createGLTextureWithData: (void*) pixelData withWidth: (int) width withHeight: (int) height; 
{
	GLuint newTextureName;
	
	// Generates a new texture name/id.
	glGenTextures(1, &newTextureName);
	
	// Binds the new name/id to really create the texture and hold it to set its properties.
	glBindTexture(GL_TEXTURE_2D, newTextureName);
	
	// Uploads the pixel data to the bound texture.
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixelData);
	
	// Defines the Minification and Magnification filters to the bound texture.
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	
	// Generates a full MipMap chain to the current bound texture.
	glGenerateMipmap(GL_TEXTURE_2D);
	
	return newTextureName;
}

- (void) dealloc
{
	CGImageRelease(image);	
}

@end
