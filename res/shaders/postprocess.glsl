#version 330

in vec2 fragTexCoord;

out vec4 finalColor;

uniform sampler2D texture0;

uniform vec2 resolution;

uniform float shakiness = 0;
uniform float invertness = 0;
uniform float time = 0;

const int indexMatrix4x4[16] = int[](
        0, 8, 2, 10,
        12, 4, 14, 6,
        3, 11, 1, 9,
        15, 7, 13, 5);

float indexValue() {
    int x = int(mod(gl_FragCoord.x / 4, 4));
    int y = int(mod(gl_FragCoord.y / 4, 4));
    return indexMatrix4x4[(x + y * 4)] / 16.0;
}

void main()
{
    vec2 uv = fragTexCoord * vec2(1, -1);
    uv += vec2(cos(time * 100), sin(2*time * 100)) * 0.01 * shakiness;
    vec4 texelColor = texture(texture0, uv);

    finalColor = texelColor;
    finalColor *= 20;
    vec4 closestColor = round(finalColor);
    vec4 secondClosestColor = floor(finalColor) + 1 - (round(finalColor) - floor(finalColor));
    float d = indexValue();
    float distance = length(closestColor - finalColor);
    finalColor = (distance < d) ? closestColor : secondClosestColor;
    finalColor /= 20;

    vec4 inverted = vec4(1 - finalColor.xyz, finalColor.w);
    finalColor = mix(finalColor, inverted, invertness);
}
