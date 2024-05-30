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

void main()
{
    fragTexCoord = vertexTexCoord;
    fragColor = vertexColor;
    fragNormal = normalize((matNormal * vec4(vertexNormal, 1.0)).xyz);
    gl_Position = mvp * vec4(vertexPosition, 1.0);
    fragWorldPosition = (matModel * vec4(vertexPosition, 1.0)).xyz;
}
