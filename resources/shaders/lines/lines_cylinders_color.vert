#version 150
// please send comments or report bug to: liangliang.nan@gmail.com

// It uses geometry shader for vertex generation.
// The code does not cover round caps.

//#extension GL_EXT_gpu_shader4 : enable

uniform mat4 MANIP = mat4(1.0);
uniform mat4 MV;
uniform mat4 PROJ;

uniform vec4 default_color;
uniform bool per_vertex_color;

uniform bool planeClippingDiscard = false;
uniform bool clippingPlaneEnabled = false;
uniform bool crossSectionEnabled = false;
uniform vec4 clippingPlane0;
uniform vec4 clippingPlane1;

in  vec3 vtx_position;	// point position
in  vec3 vtx_color;		// point color

out vec4  vOutColor;
out float vOutClipped;

void main()
{
    vec4 new_position = MANIP * vec4(vtx_position, 1.0);

    vOutClipped = 0.0;
    if (clippingPlaneEnabled) {
        if (planeClippingDiscard && dot(new_position, clippingPlane0) < 0)
            vOutClipped = 1.0;
        if (crossSectionEnabled) {
            if (planeClippingDiscard && dot(new_position, clippingPlane1) < 0)
                vOutClipped = 1.0;
        }
    }

    gl_Position = MV * new_position;

    if (per_vertex_color)
        vOutColor = vec4(vtx_color, 1.0f);
    else
        vOutColor = default_color;
}
