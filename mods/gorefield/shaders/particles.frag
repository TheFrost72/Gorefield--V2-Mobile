#pragma header

precision highp float;

uniform float time;
uniform vec2 res;
uniform vec2 particleXY;
uniform vec3 particleColor;
uniform vec2 particleDirection;
uniform float particleZoom;
uniform float particlealpha;
uniform int layers;

#define PI 3.1415927
#define TWO_PI 6.283185

#define ANIMATION_SPEED 1.5
#define MOVEMENT_SPEED 0.5
#define MOVEMENT_DIRECTION (particleDirection)

#define PARTICLE_SIZE 0.009

#define PARTICLE_SCALE (vec2(0.5, 1.6))
#define PARTICLE_SCALE_VAR (vec2(0.25, 0.2))

#define SPARK_COLOR (particleColor * 1.5)
#define SMOKE_COLOR (vec3(0.31,0.031,0.612) * 0.8)

#define SIZE_MOD 1.2
#define ALPHA_MOD 0.9

#define MAX_LAYERS 16

float hash1_2(in vec2 x)
{
    return fract(sin(dot(x, vec2(52.127, 61.2871))) * 521.582);
}

vec2 hash2_2(in vec2 x)
{
    mat2 m = mat2(20.52, 24.1994, 70.291, 80.171);
    return fract(sin(m * x) * 492.194);
}

vec2 noise2_2(vec2 uv)
{
    vec2 f = smoothstep(0.0, 1.0, fract(uv));
    vec2 uv00 = floor(uv);
    vec2 uv01 = uv00 + vec2(0.0, 1.0);
    vec2 uv10 = uv00 + vec2(1.0, 0.0);
    vec2 uv11 = uv00 + vec2(1.0, 1.0);
    vec2 v00 = hash2_2(uv00);
    vec2 v01 = hash2_2(uv01);
    vec2 v10 = hash2_2(uv10);
    vec2 v11 = hash2_2(uv11);
    vec2 v0 = mix(v00, v01, f.y);
    vec2 v1 = mix(v10, v11, f.y);
    return mix(v0, v1, f.x);
}

float noise1_2(vec2 uv)
{
    vec2 f = fract(uv);
    vec2 uv00 = floor(uv);
    vec2 uv01 = uv00 + vec2(0.0, 1.0);
    vec2 uv10 = uv00 + vec2(1.0, 0.0);
    vec2 uv11 = uv00 + vec2(1.0, 1.0);
    float v00 = hash1_2(uv00);
    float v01 = hash1_2(uv01);
    float v10 = hash1_2(uv10);
    float v11 = hash1_2(uv11);
    float v0 = mix(v00, v01, f.y);
    float v1 = mix(v10, v11, f.y);
    return mix(v0, v1, f.x);
}

float layeredNoise1_2(in vec2 uv, in float sizeMod, in float alphaMod, in int layerCount, in float animation)
{
    float noise = 0.0;
    float alpha = 1.0;
    float size = 1.0;
    vec2 offset = vec2(0.0);
    for (int i = 0; i < MAX_LAYERS; i++)
    {
        if (i >= layerCount) break;
        offset += hash2_2(vec2(alpha, size)) * 10.0;
        noise += noise1_2(uv * size + time * animation * 8.0 * MOVEMENT_DIRECTION * MOVEMENT_SPEED + offset) * alpha;
        alpha *= alphaMod;
        size *= sizeMod;
    }
    float denom = (1.0 - pow(alphaMod, float(layerCount)));
    if (denom == 0.0) denom = 1.0;
    noise *= (1.0 - alphaMod) / denom;
    return noise;
}

vec2 rotate(in vec2 point, in float deg)
{
    float s = sin(deg);
    float c = cos(deg);
    return mat2(c, -s, s, c) * point;
}

vec2 voronoiPointFromRoot(in vec2 root, in float deg)
{
    vec2 point = hash2_2(root) - vec2(0.5, 0.5);
    float s = sin(deg);
    float c = cos(deg);
    point = mat2(c, -s, s, c) * point * 0.66;
    point += root + vec2(0.5, 0.5);
    return point;
}

float degFromRootUV(in vec2 uv)
{
    return time * ANIMATION_SPEED * (hash1_2(uv) - 0.5) * 2.0;
}

vec2 randomAround2_2(in vec2 point, in vec2 range, in vec2 uv)
{
    return point + (hash2_2(uv) - vec2(0.5, 0.5)) * range;
}

vec3 fireParticles(in vec2 uv, in vec2 originalUV, in vec2 scrolledUV)
{
    vec3 particles = vec3(0.0, 0.0, 0.0);
    vec2 rootUV = floor(uv);
    float deg = degFromRootUV(rootUV);
    vec2 pointUV = voronoiPointFromRoot(rootUV, deg);
    vec2 tempUV = uv + (noise2_2(uv * 2.0) - vec2(0.5, 0.5)) * 0.1;
    tempUV += -(noise2_2(uv * 3.0 + time) - vec2(0.5, 0.5)) * 0.07;
    float dist = length(rotate(tempUV - pointUV, 0.7) * randomAround2_2(PARTICLE_SCALE, PARTICLE_SCALE_VAR, rootUV));
    particles += (1.0 - smoothstep(PARTICLE_SIZE * 0.6, PARTICLE_SIZE * 3.0, dist)) * SPARK_COLOR;
    float border = (hash1_2(rootUV) - 0.5) * 2.0;
    float disappear = 1.0 - smoothstep(border, border + 0.5, scrolledUV.y);
    border = (hash1_2(rootUV + vec2(0.214, 0.214)) - 1.8) * 0.7;
    float appear = smoothstep(border, border + 0.4, scrolledUV.y);
    return particles * disappear * appear;
}

vec3 layeredParticles(in vec2 uv, in float sizeMod, in float alphaMod, in int layerCount)
{
    vec3 particles = vec3(0.0, 0.0, 0.0);
    float size = 1.0;
    float alpha = 1.0;
    vec2 offset = vec2(0.0, 0.0);
    for (int i = 0; i < MAX_LAYERS; i++)
    {
        if (i >= layerCount) break;
        vec2 noiseOffset = (noise2_2(uv * size * 2.0 + vec2(0.5, 0.5)) - vec2(0.5, 0.5)) * 0.15;
        vec2 bokehUV = (uv * (1.0 / particleZoom) * size + time * MOVEMENT_DIRECTION * MOVEMENT_SPEED) + offset + noiseOffset;
        particles += fireParticles(bokehUV, uv * (1.0 / particleZoom), uv + vec2(particleXY.x / res.x, particleXY.y / res.y)) * alpha;
        offset += hash2_2(vec2(alpha, alpha)) * 10.0;
        alpha *= alphaMod;
        size *= sizeMod;
    }
    return particles;
}

void main()
{
    vec2 uv = openfl_TextureCoordv;
    vec2 uvv = vec2(uv.x, 1.0 - uv.y);
    vec2 particleUv = (2.0 * (uvv * res) - res) / res.x;
    vec4 tex = flixel_texture2D(bitmap, uv);
    vec3 screen = tex.rgb;
    vec3 particles = layeredParticles(particleUv * 1.8, SIZE_MOD, ALPHA_MOD, layers);
    particles *= particlealpha;
    vec3 col = particles + screen + SMOKE_COLOR * 0.02;
    col = smoothstep(vec3(-0.08, -0.08, -0.08), vec3(1.0, 1.0, 1.0), col);
    gl_FragColor = vec4(col, tex.a);
}