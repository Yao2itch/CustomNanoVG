//
//  NanoVGRenderer.m
//  CustomNanoVG
//
//  Created by 姚隽楠 on 2021/12/9.
//  Copyright © 2021 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "NanoVGRenderer.h"

#include "../../../nanovg/src/nanovg_gl.h"

@implementation NanoVGRenderer
-(void)setup
{
    vg = nvgCreateGLES3(NVG_ANTIALIAS | NVG_STENCIL_STROKES | NVG_DEBUG);
    if (vg == NULL)
    {
        printf(" could not init nanovg.\n");
        return;
    }
}
@end
