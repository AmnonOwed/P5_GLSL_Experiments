
#version 430 core

#define PROCESSING_COLOR_SHADER

in vec3 gFacetNormal;
in vec3 gTriDistance;
in vec3 gPatchDistance;
in float gPrimitive;

float amplify(float d, float scale, float offset) {
    d = scale * d + offset;
    d = clamp(d, 0, 1);
    d = 1 - exp2(-2*d*d);
    return d;
}

void main() {
    vec3 color = vec3(0.0, 0.0, 1.0);

    float d1 = min(min(gTriDistance.x, gTriDistance.y), gTriDistance.z);
    float d2 = min(min(gPatchDistance.x, gPatchDistance.y), gPatchDistance.z);
    color = amplify(d1, 40, -0.5) * amplify(d2, 60, -0.5) * color;

    gl_FragColor = vec4(color, 1.0);
}
