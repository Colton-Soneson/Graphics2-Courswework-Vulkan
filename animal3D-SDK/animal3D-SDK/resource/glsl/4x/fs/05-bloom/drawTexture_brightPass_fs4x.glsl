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
	
	drawTexture_brightPass_fs4x.glsl
	Draw texture sample with brightening.
*/

#version 410

// ****TO-DO: 
//	0) copy existing texturing shader
//	1) implement brightness function (e.g. luminance)
//	2) use brightness to implement tone mapping or just filter out dark areas

uniform sampler2D uImage00;
in vec2 vTexcoord;

layout (location = 0) out vec4 rtFragColor;

//Luminence function (describes brightness of color)
float relativeLuminance(vec3 col)
{
	//this is just a weighted value to what humans see
	return (0.2126 * col.r + 0.7152 * col.g + 0.0722 * col.b);
}


void main()
{
	float luminance = relativeLuminance(texture(uImage00, vTexcoord).rgb);
	vec3 Vin = texture(uImage00, vTexcoord).rgb * luminance;
	vec3 result = Vin / (Vin + vec3(1.0));		//https://en.wikipedia.org/wiki/Tone_mapping
	
	//vec3 result = texture(uImage00, vTexcoord).rgb;

	//result *= 0.18 / ( luminance );
	//result *= (1.0 + (result / (0.8 * 0.8)));
	//result -= 5.0;

	//result = max(result, 0.0);
	//result /= (10.0 + result);

	rtFragColor = vec4(result, 1.0);	//slide 14 says to multiply
}
