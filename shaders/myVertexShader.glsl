uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;

uniform vec4 lightPosition;

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;

varying vec4 vertColor;
uniform float deform;


void main() {
  gl_Position = transform * position;    

  vec3 ecPosition = vec3(modelview * position);  
  vec3 ecNormal = (normalMatrix * normal);

  vec3 direction = normalize(lightPosition.xyz - ecPosition);    
  float intensity = max(0.0, dot(direction, ecNormal));

  // Use the parameters above to compute vertColor e.g.
  vertColor = max(vec4(intensity, intensity, intensity, 1) * color,color / 3) + vec4(0.45,0.3,0.2,1);           
}
