#version 330

in vec3 vertexPosition;
in vec2 vertexTexCoord;
in vec3 vertexNormal;
in vec4 vertexColor;

out vec2 fragTexCoord;
out vec3 fragNormal;
out vec4 fragColor;
out vec3 fragWorldPosition;

uniform mat4 mvp;
uniform mat4 matNormal;
uniform mat4 matModel;
uniform float time;

void main()
{
    vec3 pos = (matModel * vec4(vertexPosition, 1.0)).xyz;
    fragTexCoord = vertexTexCoord;
    fragColor = vertexColor;
    fragNormal = normalize((matNormal * vec4(vertexNormal, 1.0)).xyz);
    vec3 wobble = vec3(cos(time + pos.y * 10), sin(time + pos.y * 6), sin(time + pos.y * 10)) * 0.05;
    gl_Position = mvp * vec4(vertexPosition + wobble, 1.0);
    fragWorldPosition = pos;
}
