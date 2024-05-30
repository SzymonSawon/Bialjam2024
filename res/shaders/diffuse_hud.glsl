#version 330

in vec2 fragTexCoord;
in vec3 fragNormal;
in vec4 fragColor;
in vec3 fragWorldPosition;

out vec4 finalColor;

uniform sampler2D texture0;
uniform vec4 colDiffuse;
uniform vec3 lightDirection = vec3(.7071067812, .7071067812, 0);
uniform float ambientLight = 0.2;

void main()
{
    float ambient = 0.2;
    vec4 texelColor = texture(texture0, fragTexCoord);
    float lightIntensity = max(0, dot(fragNormal, lightDirection));
    finalColor = vec4(vec3(lightIntensity + ambientLight), 1) * texelColor * colDiffuse * fragColor;
}
