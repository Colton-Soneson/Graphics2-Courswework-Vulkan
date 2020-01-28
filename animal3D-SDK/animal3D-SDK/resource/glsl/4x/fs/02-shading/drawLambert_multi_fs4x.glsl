/*
	Copyright 2011-2020 Daniel S. Buckstein

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
*/

/*
	animal3D SDK: Minimal 3D Animation Framework
	By Daniel S. Buckstein
	
	drawLambert_multi_fs4x.glsl
	Draw Lambert shading model for multiple lights.
*/

#version 410

// ****TO-DO: 
//	1) declare uniform variable for texture; see demo code for hints
//	2) declare uniform variables for lights; see demo code for hints
//	3) declare inbound varying data
//	4) implement Lambert shading model
//	Note: test all data and inbound values before using them!

layout (location = 0) in mat4 vMV;
layout (location = 4) in vec4 vNorm;
layout (location = 5) in vec2 texCoord;

out vec4 rtFragColor;

void main()
{
//	vec3 lightColor = vec3(1.0, 0.0, 1.0);
//	vec3 norm = normalize(inNormal);	//normalized normal vector
//	vec3 lightDir = normalize(inLightSource - fragPos);	//distance between light source position and the actual spot on the object
//
//	//ambient lighting
//	//float ambientStength = 0.5;
//	//vec4 ambient = vec4(ambientStength * lightColor, 1.0); 
//
//	//diffuse lighting
//	float diff = max(dot(norm, lightDir), 0.0);		//darker diffuse component the greater the angle
//	vec4 diffuse = vec4(diff * lightColor, 1.0);	//remember that we diffuse to the color of incoming light
//	
//	//outColor = (ambient + diffuse)* texture(texSampler, fragTextureCoord);	
//	diffuse = clamp(diffuse, 0.0, 1.0);



	// DUMMY OUTPUT: all fragments are OPAQUE RED
	//rtFragColor = vNorm;
}
