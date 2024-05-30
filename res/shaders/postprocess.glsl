#version 330

in vec2 fragTexCoord;

out vec4 finalColor;

uniform sampler2D texture0;

uniform vec2 resolution;

void main()
{
    vec2 uv = fragTexCoord * vec2(1, -1);
    vec4 texelColor = texture(texture0, uv);

    finalColor = texelColor;
}
