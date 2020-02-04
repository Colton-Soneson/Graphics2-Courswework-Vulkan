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
	
	drawTexture_mrt_fs4x.glsl
	Draw texture sample with MRT output.
*/

#version 410

// ****TO-DO: 
//	1) declare uniform variable for texture; see demo code for hints
//	2) declare inbound varying for texture coordinate
//	3) sample texture using texture coordinate
//	4) assign sample to output render target (location 0)
//	5) declare new render target (location 3) and output texcoord

uniform sampler2D uTex_dm;

in vec2 vTexcoord;
in vec4 vMV_nrm_by_nrm;	
in vec4 vMV_pos;

//remember, first hit ">" then cycle using "}" and thats where these come from
layout(location = 0) out vec4 rtFragColor;
layout(location = 1) out vec4 rtViewPosition;
layout(location = 2) out vec4 rtViewNormal;
layout(location = 3) out vec4 rtAtlasTexcoord;
layout(location = 4) out vec4 rtDiffuseMap;			
//layout(location = 5) out vec4 rtSpecularMap;
//layout(location = 6) out vec4 rtDiffuseTotal;
//layout(location = 7) out vec4 rtSpecularTotal;

void main()
{
	vec4 t_final = texture(uTex_dm, vTexcoord);
	vec4 N = normalize(vMV_nrm_by_nrm);

	rtFragColor = t_final;
	rtViewPosition = vMV_pos;
	rtViewNormal = N;
	rtAtlasTexcoord = vec4(vTexcoord, 0.0, 1.0);
	//rtDiffuseMap = vec4(uTex_dm.xy, 0.0, 1.0);	//cant get this
	rtDiffuseMap = vec4(t_final.rgb, 1.0);	

}
