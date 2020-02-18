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
	
	drawTexture_blurGaussian_fs4x.glsl
	Draw texture with Gaussian blurring.
*/

#version 410

// ****TO-DO: 
//	0) copy existing texturing shader
//	1) declare uniforms for pixel size and sampling axis
//	2) implement Gaussian blur function using a 1D kernel (hint: Pascal's triangle)
//	3) sample texture using Gaussian blur function and output result


uniform sampler2D uImage00;
uniform vec2 uAxis;		//we set this in idle-renderer.c
uniform vec2 uSize;		//we set this in idle-renderer.c

in vec2 vTexcoord;

layout (location = 0) out vec4 rtFragColor;

//number indicates which row of the triangle the weights are coming from
vec4 blurGaussian0(in sampler2D img, in vec2 centerCoord, in vec2 directionToBlur)		
{
	return texture(img, centerCoord);
}

//directionToBlur is not a unit vector
vec4 blurGaussian1(in sampler2D img, in vec2 centerCoord, in vec2 directionToBlur)		
{
	//pascal row 3
	//	1 2 1

	vec4 c = vec4(0.0);
	c += texture(img, centerCoord) * 2.0;
	c += texture(img, centerCoord + directionToBlur) * 1.0;
	c += texture(img, centerCoord - directionToBlur) * 1.0;
	return (c * 0.25);	// c / 4	as you get larger kernel, you expand this power of two
}

vec4 blurGaussian2(in sampler2D img, in vec2 centerCoord, in vec2 directionToBlur)		
{
	//pascal row 5
	//	1 4 6 4 1

	vec4 c = vec4(0.0);
	c += texture(img, centerCoord) * 6.0;
	c += texture(img, centerCoord + directionToBlur) * 4.0;
	c += texture(img, centerCoord + directionToBlur) * 1.0;
	c += texture(img, centerCoord - directionToBlur) * 4.0;
	c += texture(img, centerCoord - directionToBlur) * 1.0;
	return (c * 0.0625);	//this number was way wrong, its 1/16 NOT 1/8
}

void main()
{
	//vec2 texUnits = 1.0 / textureSize(uImage00, 0);

	//rtFragColor = vec4(1.0,1.0,1.0,1.0);
	rtFragColor = blurGaussian2(uImage00, vTexcoord, uAxis * uSize);
}
