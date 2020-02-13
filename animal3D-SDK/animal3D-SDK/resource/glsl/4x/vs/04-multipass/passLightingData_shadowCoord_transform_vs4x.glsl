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
	
	passLightingData_shadowCoord_transform_vs4x.glsl
	Vertex shader that prepares and passes lighting data. Outputs transformed 
		position attribute and all others required for lighting. Also computes 
		and passes shadow coordinate.
*/

#version 410

// ****TO-DO: 
//	0) copy previous lighting data vertex shader
//	1) declare MVPB matrix for light
//	2) declare varying for shadow coordinate
//	3) calculate and pass shadow coordinate

uniform mat4 uMVP;
uniform mat4 uAtlas;
uniform mat4 uMV;
uniform mat4 uMV_nrm;	//model view for normals, ask dan if this is just (view * model) * normalMap
uniform mat4 uP;		//find necessity of this
uniform mat4 uMVPB_other;	//use "other" because we have to transform the vertex pos into light screen space, not just object

layout (location = 0) in vec4 aPosition;
layout (location = 2) in vec4 aNormal;
layout (location = 8) in vec4 aTexcoord;

out vec2 vTexcoord;
out vec4 vMV_nrm_by_nrm;	//find better name that isnt outnorm / ask for standard naming convention
out vec4 vMV_pos;
out vec4 vProjClip;	//slide 13

void main()
{
	vMV_nrm_by_nrm = uMV_nrm * aNormal;
	vMV_pos = uMV * aPosition;
	vTexcoord = vec2(uAtlas * aTexcoord);
	//gl_Position = uMVP * aPosition;	
	gl_Position = uP * vMV_pos;	
	vProjClip = uMVPB_other * aPosition;

}
