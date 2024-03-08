//
//  Shaders.metal
//  RAD
//
//  Created by Linar Zinatullin on 07/03/24.
//

#include <metal_stdlib>
using namespace metal;

[[stitchable]] half4 rainbow(float2 pos, half4 color, float t) {
    float angle = atan2(pos.y, pos.x) + t;
    
    return half4(sin(angle), sin(angle+2), sin(angle+4), color.a);
}

[[stitchable]] float2 wave (float2 pos, float t) {
    pos.y += sin(t*5+pos.y  /20) * 5;
    return pos;
}
