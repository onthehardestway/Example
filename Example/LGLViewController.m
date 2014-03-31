//
//  LGLViewController.m
//  Example
//
//  Created by Liu Zhijin on 3/18/14.
//  Copyright (c) 2014 OnTheEasiestWay. All rights reserved.
//

#import "LGLViewController.h"
#import "AGLK/AGLK.h"
#import "lowPolyAxesAndModels2.h"

typedef enum {
    Scene_Transform_Type_Translate,
    Scene_Transform_Type_Rotate,
    Scene_Transform_Type_Scale,
} SceneTransformType;

typedef enum {
    Scene_Transform_Axis_X = 0,
    Scene_Transform_Axis_Y,
    Scene_Transform_Axis_Z,
} SceneTransformAxis;

typedef struct {
    SceneTransformType type;
    SceneTransformAxis axis;
    GLfloat value;
} SceneTransform;

@interface LGLViewController ()
#pragma mark - IBoutlet


@property (nonatomic, strong) GLKBaseEffect *baseEffect;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *positionBuffer;
@property (nonatomic, strong) AGLKVertexAttribArrayBuffer *normalBuffer;


@property (nonatomic, assign) SceneTransform firstTransform;
@property (nonatomic, assign) SceneTransform secondTransform;
@property (nonatomic, assign) SceneTransform thirdTransform;
@end

@implementation LGLViewController
#pragma mark - GLKViewController method
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSAssert([self.view isKindOfClass:[GLKView class]], @"view must be GLKView");
    GLKView *view = (GLKView *)self.view;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    
    AGLKContext *context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.context = context;
    [AGLKContext setCurrentContext:context];
    
    context.clearColor = GLKVector4Make(0.0, 0.0, 0.0, 1.0);
    [context enable:GL_DEPTH_TEST];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.ambientColor = GLKVector4Make(0.4, 0.4, 0.4, 1.0);
    self.baseEffect.light0.position = GLKVector4Make(1.0, 0.8, 0.4, 0);
    
    // Rotate about x-axis 30°
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(30), 1.0, 0.0, 0.0);
    // Rotate about y-axis -30°
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(-30), 0.0, 1.0, 0.0);
    modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, -0.25, 0.00, -0.20);
    self.baseEffect.transform.modelviewMatrix = modelViewMatrix;
    
    size_t stride = sizeof(GLfloat) * 3;
    self.positionBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                           initWithAttribStride:stride
                           numberOfVertices:sizeof(lowPolyAxesAndModels2Verts) / stride
                           data:lowPolyAxesAndModels2Verts
                           usage:GL_STATIC_DRAW];
    
    self.normalBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                         initWithAttribStride:stride numberOfVertices:sizeof(lowPolyAxesAndModels2Normals) / stride
                         data:lowPolyAxesAndModels2Normals
                         usage:GL_STATIC_DRAW];
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    const GLfloat aspectRatio = (GLfloat)view.drawableWidth / (GLfloat)view.drawableHeight;
    self.baseEffect.transform.projectionMatrix = GLKMatrix4MakeOrtho(-0.5 * aspectRatio, 0.5 * aspectRatio, -0.5, 0.5, -5.0, 5.0);
    self.baseEffect.light0.diffuseColor = GLKVector4Make(1.0, 1.0, 1.0, 1.0);
    [self.baseEffect prepareToDraw];
    
    [((AGLKContext *)view.context) clear:GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT];
    
    size_t stride = sizeof(GLfloat) * 3;
    [self.positionBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                             numberOfCoordinates:3
                                    attribOffset:0
                                    shouldEnable:YES];
    
    [self.normalBuffer prepareToDrawWithAttrib:GLKVertexAttribNormal
                           numberOfCoordinates:3
                                  attribOffset:0
                                  shouldEnable:YES];
    
    [AGLKVertexAttribArrayBuffer drawPreparedArraysWithMode:GL_TRIANGLES
                                           startVertexIndex:0
                                           numberOfVertices:sizeof(lowPolyAxesAndModels2Verts) / stride];
}

- (void)viewDidUnload
{
    [super viewDidLoad];
}

@end
