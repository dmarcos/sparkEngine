//
//  SETexture.h
//  SparkEngine
//
//  Created by Diego Marcos on 6/11/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

@interface SETexture : NSObject

// Texture Object name/id.
@property (readonly) GLuint glTextureName;

- (id) initWithImage:(UIImage *) image;

@end
