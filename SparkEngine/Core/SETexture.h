//
//  SETexture.h
//  SparkEngine
//
//  Created by Diego Marcos on 6/11/12.
//  Copyright (c) 2012 codebeast.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SETexture : NSObject

@property (readonly) GLuint glTextureName;

- (id) initWithImage:(UIImage *) image;

@end
