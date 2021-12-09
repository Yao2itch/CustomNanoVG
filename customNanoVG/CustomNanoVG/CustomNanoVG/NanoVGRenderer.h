//
//  NanoVGRenderer.h
//  CustomNanoVG
//
//  Created by 姚隽楠 on 2021/12/9.
//  Copyright © 2021 tencent. All rights reserved.
//

#ifndef NanoVGRenderer_h
#define NanoVGRenderer_h

#include "ESUtil.h"
#include <Foundation/Foundation.h>
#include "../../../nanovg/src/nanovg.h"

@interface NanoVGRenderer : NSObject
{
    NVGcontext* vg;
@public
    ESContext context;
}
@property(nonatomic) ESContext context;
// -(void)Shutdown:(ESContext*)esContext;
// -(void)Draw:(ESContext*)esContext;
-(void)setup;
@end

#endif /* NanoVGRenderer_h */
