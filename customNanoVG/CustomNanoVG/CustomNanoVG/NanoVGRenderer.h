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
#include "../nanovg/src/nanovg.h"

// #include "../../../nanovg/src/nanovg.h"

struct DemoData {
    int fontNormal, fontBold, fontIcons, fontEmoji;
    int images[12];
};
typedef struct DemoData DemoData;

@interface NanoVGRenderer : NSObject
{
@public
    ESContext context;
    NVGcontext* vg;
    DemoData data;
}
@property DemoData data;
@property(nonatomic) ESContext context;
-(int)loadData:(NVGcontext*)vg demoData:(DemoData*)demoData;
-(void)render:(NVGcontext*)vg MX:(float)mx MY:(float)my Width:(float)width Height:(float)height T:(float)t Blowup:(int)blowup demoData:(DemoData*)demoData;
-(void)drawLines:(NVGcontext*)vg X:(float)x Y:(float)y W:(float)w H:(float)h T:(float)t;
// -(void)Shutdown:(ESContext*)esContext;
// -(void)Draw:(ESContext*)esContext;
-(void)setup;
@end

#endif /* NanoVGRenderer_h */
