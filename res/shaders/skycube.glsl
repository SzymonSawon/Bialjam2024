#version 330

in vec2 fragTexCoord;
in vec3 fragNormal;

out vec4 finalColor;

uniform float time;

float rand(vec3 co) {
    return fract(sin(dot(co, vec3(23.312312, 12.9898, 78.233))) * 43758.5453);
}

void main()
{
    float color = rand(floor((fragNormal) * 150) / 150);
    color = smoothstep(0.995, 1, color);
    finalColor = vec4(vec3(color), 1);
}
