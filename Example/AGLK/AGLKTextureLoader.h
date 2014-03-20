//
//  AGLKTextureLoader.h
//  Example
//
//  Created by Liu Zhijin on 3/20/14.
//  Copyright (c) 2014 OnTheEasiestWay. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface AGLKTextureInfo : NSObject
@property (nonatomic, readonly) GLuint name;
@property (nonatomic, readonly) GLenum target;
@property (nonatomic, readonly) GLuint width;
@property (nonatomic, readonly) GLuint height;
@end

@interface AGLKTextureLoader : NSObject
+ (AGLKTextureInfo *)textureWithCGImage:(CGImageRef)cgImage options:(NSDictionary *)options error:(NSError *__autoreleasing *)outError;
@end
