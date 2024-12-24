#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;


float randomWithSeed(float2 st, float seed) {
    float2 k = float2(12.9898, 78.233);
    return fract(sin(dot(st, k) + seed) * 43758.5453);
}

float randomFloatInRange(float st, float seed, float range) {
    float r = randomWithSeed(st, seed);
    return (r * 2.0 - 1.0) * range;
}

[[ stitchable ]] half4 particle(float2 p,SwiftUI::Layer l, float2 s, float2 d, float progress) {
    
    float2 uv = p / s;
    float2 dp = d / s;
    float2 gp = floor(p / 2.0) * 2.0;
    float randx = randomFloatInRange(gp.x, 3.1423, 1.0);
    float randy = randomFloatInRange(gp.y, 9.3234, 1.0);
    
    
    //calculate distance
    float dx = uv.x - dp.x;
    float dy = uv.y - dp.y;
    float distance = sqrt(dx * dx + dy * dy);
    
    //create force function
    float maxdistance = 0.1;
    float force = (maxdistance - distance) / distance;
    float forceDirectionX = dx / distance;
    float forceDirectionY = dy / distance;

    float gravity_x = (forceDirectionX + force);
    float gravity_y = (forceDirectionY + force);
    
    
    //spiral direction
    float angle = atan2(dy,dx);
    float spiralfactor = 24.0;
    
    angle += spiralfactor * distance;

    //adjust positioning based on maxdistance (outside of the it becomes stronger)
    
    float diffx = distance * tan(angle) + randy * 0.01 * sin(gravity_x);
    float diffy = distance * cos(angle) + randx * 0.01 * cos(gravity_y);
    
    
    //final calculation
    float basex = uv.x + diffx;
    float basey = uv.y + diffy;

    float2 newPos = float2(basex - diffx * progress, basey - diffy * progress);
    
    return half4(l.sample(newPos * s).rgb,1.0);
}
