//
//  AGLKVertexAttribArrayBuffer.m
//  Example
//
//  Created by Liu Zhijin on 3/19/14.
//  Copyright (c) 2014 OnTheEasiestWay. All rights reserved.
//

#import "AGLKVertexAttribArrayBuffer.h"

/*
 Buffer usage:
 
 1. Generate
 Ask OpenGL ES to generate a unique identifier for a buffer that the graphics processor controls.
 
 2. Bind
 Tell OpenGL ES to use a buffer for subsequent operations.
 
 3. Buffer Data
 Tell OpenGL ES to allocate and initialize sufficient contiguous memory for a currently bound buffer—often by copying data from CPU-controlled memory into the allocated memory.
 
 4. Enable or Disable
 Tell OpenGL ES whether to use data in buffers during subsequent rendering.
 
 5. Set Pointers
 Tell OpenGL ES about the types of data in buffers and any memory offsets needed to access the data.
 
 6. Draw
 Tell OpenGL ES to render all or part of a scene using data in currently bound and enabled buffers.
 
 7. Delete
 Tell OpenGL ES to delete previously generated buffers and free associated resources.
 */

@interface AGLKVertexAttribArrayBuffer ()
@property (nonatomic, assign) GLuint glName;
@property (nonatomic, assign) GLsizeiptr bufferSizeBytes;
@property (nonatomic, assign) GLsizeiptr stride;
@end

@implementation AGLKVertexAttribArrayBuffer
+ (void)drawPreparedArraysWithMode:(GLenum)mode
                  startVertexIndex:(GLint)first
                  numberOfVertices:(GLsizei)count
{
    // 6. Draw
    // Tell OpenGL ES to render all or part of a scene using data in currently bound and enabled buffers.
    glDrawArrays(mode, first, count);
}

- (id)initWithAttribStride:(GLsizeiptr)stride numberOfVertices:(GLsizei)count data:(const GLvoid *)dataPtr usage:(GLenum)usage
{
    NSParameterAssert(0 < stride);
    NSAssert(((NULL != dataPtr) || (0 == count && NULL == dataPtr)),
              @"data must not be NULL or count > 0");
    
    self = [super init];
    if (self) {
        self.stride = stride;
        self.bufferSizeBytes = stride * count;
        
        // 1. Generate
        // Ask OpenGL ES to generate a unique identifier for a buffer that the graphics processor controls.
        glGenBuffers(1, &_glName);
        NSAssert(0 != self.glName, @"Failed to generate glName");
        
        // 2. Bind
        // Tell OpenGL ES to use a buffer for subsequent operations.
        glBindBuffer(GL_ARRAY_BUFFER, self.glName);
        
        // 3. Buffer Data
        // Tell OpenGL ES to allocate and initialize sufficient contiguous memory for a currently bound buffer—often by copying data from CPU-controlled memory into the allocated memory.
        glBufferData(GL_ARRAY_BUFFER,
                     self.bufferSizeBytes,
                     dataPtr,
                     usage);
    }
    return self;
}

- (void)reinitWithAttribStride:(GLsizeiptr)stride numberOfVertices:(GLsizei)count data:(const GLvoid *)dataPtr
{
    NSParameterAssert(0 < stride);
    NSParameterAssert(0 < count);
    NSParameterAssert(NULL != dataPtr);
    NSAssert(0 != self.glName, @"Invalid name");

    self.stride = stride;
    self.bufferSizeBytes = count * stride;

    // 2. Bind
    // Tell OpenGL ES to use a buffer for subsequent operations.
    glBindBuffer(GL_ARRAY_BUFFER, self.glName);
    
    // 3. Buffer Data
    // Tell OpenGL ES to allocate and initialize sufficient contiguous memory for a currently bound buffer—often by copying data from CPU-controlled memory into the allocated memory.
    glBufferData(GL_ARRAY_BUFFER,
                 self.bufferSizeBytes,
                 dataPtr,
                 GL_DYNAMIC_DRAW);
    
}

- (void)prepareToDrawWithAttrib:(GLuint)index numberOfCoordinates:(GLint)count attribOffset:(GLsizeiptr)offset shouldEnable:(BOOL)shouldEnable
{
    NSParameterAssert((0 < count) && (count < 4));
    NSParameterAssert(offset < self.stride);
    
    NSAssert(0 != self.glName, @"Invalid glName");

    // 2. Bind
    // Tell OpenGL ES to use a buffer for subsequent operations.
    glBindBuffer(GL_ARRAY_BUFFER, self.glName);

    if (shouldEnable) {
        // 4. Enable or Disable
        // Tell OpenGL ES whether to use data in buffers during subsequent rendering.
        glEnableVertexAttribArray(index);
    }

    // 5. Set Pointers
    // Tell OpenGL ES about the types of data in buffers and any memory offsets needed to access the data.
    glVertexAttribPointer(index,            // Identifies the attribute to use
                          count,            // number of coordinates for attribute
                          GL_FLOAT,         // data is floating point
                          GL_FALSE,         // no fixed point scaling
                          self.stride,      // total num bytes stored per vertex
                          NULL + offset);   // offset from start of each vertex to
                                            // first coord for attribute
}

- (void)drawArrayWithMode:(GLenum)mode startVertexIndex:(GLint)first numberOfVertices:(GLsizei)count
{
    NSAssert(self.bufferSizeBytes >= ((first + count) * self.stride),
             @"Attempt to draw more vertex data than available");

    // 6. Draw
    // Tell OpenGL ES to render all or part of a scene using data in currently bound and enabled buffers.
    glDrawArrays(mode, first, count);
}

- (void)dealloc
{
    if (0 != self.glName) {
        // 7. Delete
        // Tell OpenGL ES to delete previously generated buffers and free associated resources.
        glDeleteBuffers(1, &_glName);
        self.glName = 0;
    }
}
@end
