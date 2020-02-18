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
	
	drawTexture_blendScreen4_fs4x.glsl
	Draw blended sample from multiple textures using screen function.
*/

#version 410

// ****TO-DO: 
//	0) copy existing texturing shader
//	1) declare additional texture uniforms
//	2) implement screen function with 4 inputs
//	3) use screen function to sample input textures

uniform sampler2D uTex_dm;

uniform sampler2D uImage00;
uniform sampler2D uImage01;
uniform sampler2D uImage02;
uniform sampler2D uImage03;

in vec2 vTexcoord;
in vec4 vOriginal;

layout (location = 0) out vec4 rtFragColor;

void main()
{
	// DUMMY OUTPUT: all fragments are OPAQUE YELLOW
	//vec3 A = texture(uImage00, vTexcoord).rgb;
	//vec3 B = texture(uImage01, vTexcoord).rgb;
	//vec4 C = texture(uImage02, vTexcoord);
	//vec4 D = texture(uImage03, vTexcoord);

	//vec3 OG = texture(uTex_dm, vTexcoord).rgb;

	//slide 32
	//rtFragColor = 1.0 - (1.0 - A) * (1.0 - B) * (1.0 - C) * (1.0 - D);
	//rtFragColor = 1.0 - (1.0 - A) * (1.0 - B);
	//rtFragColor = vec4(vec3(1.0) - (vec3(1.0) - A) * (vec3(1.0) - OG), 1.0);

	vec3 original = texture(uTex_dm, vTexcoord).rgb;
	vec3 bloom = texture(uImage00, vTexcoord).rgb;
	original += bloom;

	vec3 result = vec3(1.0) - (vec3(1.0) - original);
	//vec3 result = vec3(1.0) - exp(-original * 0.5);

	result = pow(result, vec3(1.0 / 2.2));

	rtFragColor = vec4(result, 1.0);
	//rtFragColor = vOriginal;
}
