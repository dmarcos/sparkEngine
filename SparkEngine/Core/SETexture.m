//
//  SETexture.m
//  SparkEngine
//
//  Created by Diego Marcos on 6/11/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import "SETexture.h"
#import <UIKit/UIGraphics.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface SETexture(){
    CGImageRef _image;
}
 
-(GLuint) createGLTextureWithData:(void*)data width:(int)width height:(int)height;

@end

@implementation SETexture

@synthesize glTextureName = _glTextureName;

-(id) initWithImage:(UIImage*)image
{
    self->_image = [image CGImage];
    CGImageRetain(self->_image);
    
    // Extracts the pixel informations and place it into the data.
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int imageHeight = CGImageGetHeight(self->_image);
    int imageWidth = CGImageGetWidth(self->_image);
    void* pixelData = malloc(imageWidth * imageHeight * 4);
    CGContextRef context = CGBitmapContextCreate(pixelData, imageWidth, imageHeight, 8, 4 *imageWidth, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGColorSpaceRelease(colorSpace);
    
    // Clears and ReDraw the image into the context.
    CGContextClearRect(context, CGRectMake(0, 0, imageWidth, imageHeight));
    UIGraphicsBeginImageContextWithOptions([image size], NO, 0);
    
    // Flip the image to fix Cocoa and CoreGraphics disagreement on which corner corresponds to the first pixel of the image. 
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, imageHeight);
    CGContextConcatCTM(context, flipVertical);
    
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), self->_image);
    UIGraphicsEndImageContext();
    // Releases the context.
    CGContextRelease(context);
    
    self->_glTextureName = [self createGLTextureWithData:pixelData width:imageWidth height:imageHeight];
    
    return self;
}

-(GLuint) createGLTextureWithData:(void*)data width:(int)width height:(int)height
{
	GLuint newTextureName;
	
	// Generates a new texture name/id.
	glGenTextures(1, &newTextureName);
	
	// Binds the new name/id to really create the texture and hold it to set its properties.
	glBindTexture(GL_TEXTURE_2D, newTextureName);
	
	// Uploads the pixel data to the bound texture.
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
	
	// Defines the Minification and Magnification filters to the bound texture.
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	
	// Generates a full MipMap chain to the current bound texture.
	glGenerateMipmap(GL_TEXTURE_2D);
	
	return newTextureName;
}

-(void) dealloc
{
	CGImageRelease(self->_image);	
}

@end