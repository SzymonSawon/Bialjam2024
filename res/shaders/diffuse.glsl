#version 330

in vec2 fragTexCoord;
in vec3 fragNormal;
in vec4 fragColor;
in vec3 fragWorldPosition;

out vec4 finalColor;

uniform sampler2D texture0;
uniform vec4 colDiffuse;
uniform vec3 lightPosition = vec3(0, 1, 0);
uniform float lightRadius = 5;
uniform float ambientLight = 0.2;
uniform float time;
uniform float targetingFactor = 0;

void main()
{
    float ambient = 0.2;
    vec4 texelColor = texture(texture0, fragTexCoord);
    vec3 lightVec = lightPosition - fragWorldPosition;
    vec3 lightVecNorm = normalize(lightVec * vec3(0.5, 1, 1));
    float lightIntensity = pow(1 - min(length(lightVec) / lightRadius, 1), 2) * max(0, dot(fragNormal, lightVecNorm));
    finalColor = vec4(vec3(lightIntensity + ambientLight), 1) * texelColor * colDiffuse * fragColor;
    finalColor += vec4(vec3(pow(sin(time * 2), 2)), 0.0) * 0.4 * targetingFactor;
}
