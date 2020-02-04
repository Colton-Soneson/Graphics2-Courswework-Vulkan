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
	
	drawLambert_multi_mrt_fs4x.glsl
	Draw Lambert shading model for multiple lights with MRT output.
*/

#version 410

// ****TO-DO: 
//	1) declare uniform variable for texture; see demo code for hints
//	2) declare uniform variables for lights; see demo code for hints
//	3) declare inbound varying data
//	4) implement Lambert shading model
//	Note: test all data and inbound values before using them!
//	5) set location of final color render target (location 0)
//	6) declare render targets for each attribute and shading component

uniform sampler2D uTex_dm;	//texture


const float ambientStrength = 0.1f;
const int NUM_LIGHT = 4;	//or 3, check this, I think dan said there was 5 lights
							//		make it so if the num of lights does not equal this (or is atleast greater) number here, then set the object to hot pink

//line 86 DemoShaderProgram.h, light uniform names location
uniform int uLightCt;		//not float, use for num of lights
uniform vec4 uLightPos[NUM_LIGHT];
uniform vec4 uLightCol[NUM_LIGHT];

in vec2 vTexcoord;
in vec4 vMV_nrm_by_nrm;
in vec4 vMV_pos;

layout(location = 0) out vec4 rtFragColor;
layout(location = 1) out vec4 rtViewPosition;
layout(location = 2) out vec4 rtViewNormal;
layout(location = 3) out vec4 rtAtlasTexcoord;
layout(location = 4) out vec4 rtDiffuseMap;
//layout(location = 5) out vec4 rtSpecularMap;
layout(location = 6) out vec4 rtDiffuseTotal;
//layout(location = 7) out vec4 rtSpecularTotal;

//glsl requires you to forward declare just like c++, so functions go before main

vec4 ambient(float a_strength, vec4 l_col)
{
	if(NUM_LIGHT < uLightCt)
	{
		return vec4(1.0, 0.15, 0.0, 1.0);	//dont waste time doing lighting we cant do
	}
	else
	{
		return vec4(a_strength * l_col);
	}
} 


vec4 lambertLightRun(vec4 t_final)
{
	vec4 temp;
	
	if(NUM_LIGHT < uLightCt)
	{
		return vec4(1.0, 0.15, 0.0, 1.0);	
	}
	else
	{
		vec4 N = normalize(vMV_nrm_by_nrm);
		rtViewNormal = N;

		vec4 diffuseTotal = vec4(0.0,0.0,0.0,0.0);

		for(int i = 0; i < uLightCt; i++)
		{
			vec4 L = normalize(uLightPos[i] - vMV_pos);
			float diff = max(0.0, dot(N, L));
			vec4 diffuse = vec4(diff * uLightCol[i]);
			vec4 amb = ambient(ambientStrength, uLightCol[i]);

			diffuseTotal += (diff * t_final);

			temp += (amb + diffuse) * t_final;
		}

		rtDiffuseTotal = diffuseTotal;
		return temp;
	}
};

//test functions
vec4 textureCoordTest(vec2 tc) { return vec4(tc, 0.0, 1.0); };
vec4 viewNormsTest(vec4 mvNxN) { return mvNxN; };

void main()
{
	
	vec4 t_final_dm = texture(uTex_dm, vTexcoord);
	rtFragColor = lambertLightRun(t_final_dm);
	rtViewPosition = vMV_pos;
	rtAtlasTexcoord = vec4(vTexcoord, 0.0, 1.0);
	rtDiffuseMap = vec4(t_final_dm.rgb, 1.0);


	//testing
	//rtFragColor = textureCoordTest(vTexcoord);
	//rtFragColor = viewNormsTest(vMV_nrm_by_nrm);
	//rtFragColor = texture(uTex_dm, vTexcoord);
}
