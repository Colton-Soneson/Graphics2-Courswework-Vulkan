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
	
	passTexcoord_transform_vs4x.glsl
	Vertex shader that passes texture coordinate. Outputs transformed position 
		attribute and atlas transformed texture coordinate attribute.
*/

#version 410

// ****TO-DO: 
//	1) declare uniform variable for MVP matrix; see demo code for hint
//	2) correctly transform input position by MVP matrix
//	3) declare texture coordinate attribute; see graphics library for location
//	4) declare atlas transform; see demo code for hint
//	5) declare texture coordinate outbound varying
//	6) correctly transform input texture coordinate by atlas matrix

uniform mat4 uMVP;
uniform mat4 uAtlas;
uniform mat4 uMV;
uniform mat4 uMV_nrm;	//model view for normals, ask dan if this is just (view * model) * normalMap

layout (location = 0) in vec4 aPosition;
layout (location = 2) in vec4 aNormal;
layout (location = 8) in vec4 aTexcoord;

out vec2 vTexcoord;
out vec4 vMV_nrm_by_nrm;	//find better name that isnt outnorm / ask for standard naming convention
out vec4 vMV_pos;

void main()
{
	// DUMMY OUTPUT: directly assign input position to output position
	vMV_nrm_by_nrm = uMV_nrm * aNormal;
	vMV_pos = uMV * aPosition;
	vTexcoord = vec2(uAtlas * aTexcoord);
	gl_Position = uMVP * aPosition;
}
