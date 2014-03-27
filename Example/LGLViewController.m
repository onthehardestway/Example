//
//  LGLViewController.m
//  Example
//
//  Created by Liu Zhijin on 3/18/14.
//  Copyright (c) 2014 OnTheEasiestWay. All rights reserved.
//

#import "LGLViewController.h"
#import "AGLK/AGLK.h"
#import "sphere.h"

@interface LGLViewController ()
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *positionBuffer;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *normalBuffer;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *textureBuffer;
@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@end

@implementation LGLViewController
#pragma mark - GLKViewController method
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSAssert([self.view isKindOfClass:[GLKView class]], @"view should be GLKView");
    GLKView *view = (GLKView *)self.view;
    
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AGLKContext setCurrentContext:view.context];

    ((AGLKContext *)view.context).clearColor = GLKVector4Make(0.0, 0.0, 0.0, 1.0);
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    
    self.baseEffect = [[GLKBaseEffect alloc] init];

    self.baseEffect.light0.enabled = YES;
    self.baseEffect.light0.diffuseColor = GLKVector4Make(0.7, 0.7, 0.7, 1.0);
    self.baseEffect.light0.ambientColor = GLKVector4Make(0.2, 0.2, 0.2, 1.0);
    self.baseEffect.light0.position = GLKVector4Make(1.0f, 0.0f, -0.8f, 0.0f);
    
    UIImage *texture = [UIImage imageNamed:@"Earth512x256.jpg"];
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:texture.CGImage options:@{GLKTextureLoaderOriginBottomLeft: [NSNumber numberWithBool:YES]} error:NULL];
    self.baseEffect.texture2d0.target = textureInfo.target;
    self.baseEffect.texture2d0.name = textureInfo.name;
    
    self.positionBuffer = 
    [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:3 * sizeof(GLfloat)
                                             numberOfVertices:sizeof(sphereVerts) / (3 * sizeof(GLfloat))
                                                         data:sphereVerts
                                                        usage:GL_STATIC_DRAW];
    
    self.normalBuffer = 
    [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:3 * sizeof(GLfloat)
                                             numberOfVertices:sizeof(sphereNormals) / (3 * sizeof(GLfloat))
                                                         data:sphereNormals
                                                        usage:GL_STATIC_DRAW];
    
    self.textureBuffer = 
    [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:2 * sizeof(GLfloat)
                                             numberOfVertices:sizeof(sphereTexCoords) / (2 * sizeof(GLfloat))
                                                         data:sphereTexCoords
                                                        usage:GL_STATIC_DRAW];
    
    [((AGLKContext *)view.context) enable:GL_DEPTH_TEST];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];
    
    [((AGLKContext *)view.context) clear:GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT];
    
    [self.positionBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                             numberOfCoordinates:3
                                    attribOffset:0
                                    shouldEnable:YES];
    
    [self.normalBuffer prepareToDrawWithAttrib:GLKVertexAttribNormal
                           numberOfCoordinates:3
                                  attribOffset:0
                                  shouldEnable:YES];
    
    [self.textureBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0
                            numberOfCoordinates:2
                                   attribOffset:0
                                   shouldEnable:YES];
    
    CGFloat aspectRatio = (CGFloat)view.drawableWidth / (CGFloat)view.drawableHeight;
    self.baseEffect.transform.projectionMatrix = GLKMatrix4MakeScale(1.0, aspectRatio, 1.0);

    
    [AGLKVertexAttribArrayBuffer drawPreparedArraysWithMode:GL_TRIANGLES
                                           startVertexIndex:0
                                           numberOfVertices:sizeof(sphereVerts) / (3 * sizeof(GLfloat))];
}

- (void)viewDidUnload
{
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    [AGLKContext setCurrentContext:view.context];
    
    self.positionBuffer = nil;
    self.normalBuffer = nil;
    self.textureBuffer = nil;
    
    view.context = nil;
    [AGLKContext setCurrentContext:nil];
}
@end
