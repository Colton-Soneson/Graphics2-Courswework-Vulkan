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
	
	drawTexture_outline_fs4x.glsl
	Draw texture sample with outlines.
*/

#version 410

// ****TO-DO: 
//	0) copy existing texturing shader
//	1) implement outline algorithm - see render code for uniform hints
const float thickness = 0.1;

uniform sampler2D uTex_dm;

in vec2 vTexcoord;
in vec4 vMV_nrm_by_nrm;
in vec4 vMV_pos;

out vec4 rtFragColor;

void main()
{
	//this is just going to end up being like a version of cell shading
	//	but in this case we only want one angle
	//	we want the angle closest to 90 degrees from eye view v normal on fragment post_depth_coverage

	vec4 V = normalize(vMV_pos);	//view vector from eye to the point we are looking at
	vec4 N = normalize(vMV_nrm_by_nrm);

	if(dot(V, N) < thickness)
	{
		rtFragColor = texture(uTex_dm, vTexcoord) * 0.1f;	//just make it darker
	}
	else
	{
		rtFragColor = texture(uTex_dm, vTexcoord);
	}

}
