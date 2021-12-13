//
//  ViewController.h
//  CustomNanoVG
//
//  Created by 姚隽楠 on 2021/12/9.
//  Copyright © 2021 tencent. All rights reserved.
//
#include <mach/mach_time.h>

#import <GLKit/GLKit.h>
#include "NanoVGRenderer.h"

#define NUM_INSTANCES 1
#define POSITION_LOC 0
#define COLOR_LOC    1
#define MVP_LOC      2

typedef struct
{
    // handle to a program object
    GLuint programObject;
    // VertexBufferObject ids
    GLuint vboIds[3];
    // VertexArrayObject Id
    GLuint vaoId;
    // x-offset uniform location
    GLuint offsetLoc;
    
    // Instancing
    // ---
    GLuint positionVBO;
    GLuint colorVBO;
    GLuint mvpVBO;
    GLuint indicesIBO;
    // Number of indices
    int numIndices;
    // Rotation angle
    GLfloat angle[NUM_INSTANCES];
    // ---
    
    // Vertex
    // ---
    // Uniform locations
    GLint mvpLoc;
    // Vertex data
    GLfloat *vertices;
    GLuint  *indices;
    //Rotation angle
    ESMatrix mvpMatrix;
    // ---
    
} UserData;


typedef struct mach_timebase_info *mach_timebase_info_t;
typedef struct mach_timebase_info mach_timebase_info_data_t;

@interface ViewController : GLKViewController{
    NanoVGRenderer* renderer;
    double t;
    double prevt;
    double dt;
    GLuint framebuffer;
    GLuint colorRenderbuffer;
    GLuint depthRenderbuffer;
}
@property NanoVGRenderer* nanoVGRenderer;
@property(strong, nonatomic) EAGLContext *context;
@end

