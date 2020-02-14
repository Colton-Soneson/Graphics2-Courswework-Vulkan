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
	
	drawTexture_coordManip_fs4x.glsl
	Draw texture sample after manipulating texcoord.
*/

#version 410

// ****TO-DO: 
//	1) declare uniform variable for texture; see demo code for hints
//	2) declare inbound varying for texture coordinate
//	3) modify texture coordinate in some creative way
//	4) sample texture using modified texture coordinate
//	5) assign sample to output color

uniform sampler2D uTex_dm;
uniform double uTime;

in vec2 vTexcoord;

out vec4 rtFragColor;

void main()
{
	//my 2D attempt at the gerstner wave equation (not even gonna be possible)
	float amplitude = 0.12f;
	float wavelength = 0.4f;
	float freq = 2 / wavelength;
	float speed = 0.5;
	float phase_constant = speed * wavelength;
	vec2 waveDir = vec2(0.5, 0.75);
	vec2 xy = vec2(1, 1);

	//this is supposed to be the zvalue of the wave
	//float Gerstner = amplitude * sin( dot(waveDir, xy) * freq + (uTime * phase_constant));
	//vec2 gerstDir = sin(clamp(max(0.0, Gerstner), 0, 1) * uTime) * vTexcoord;

	//rtFragColor = texture(uTex_dm, gerstDir);
	vec2 temp = vec2((sin(float(uTime * speed)) * freq) * vTexcoord.x, vTexcoord.y + abs(sin(float(uTime * speed))));
	rtFragColor = texture(uTex_dm, temp);

}
