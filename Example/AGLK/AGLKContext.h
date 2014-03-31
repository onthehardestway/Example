//
//  AGLKContext.h
//  Example
//
//  Created by Liu Zhijin on 3/19/14.
//  Copyright (c) 2014 OnTheEasiestWay. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface AGLKContext : EAGLContext
@property (nonatomic, assign) GLKVector4 clearColor;
- (void)clear:(GLbitfield)mask;
- (void)enable:(GLenum)capability;
- (void)disable:(GLenum)capability;
- (void)setBlendSourceFunction:(GLenum)sfactor destinationFunction:(GLenum)dfactor;
@end
