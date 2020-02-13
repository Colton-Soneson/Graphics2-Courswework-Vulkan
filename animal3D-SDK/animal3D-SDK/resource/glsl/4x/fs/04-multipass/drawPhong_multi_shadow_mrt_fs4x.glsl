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
	
	drawPhong_multi_shadow_mrt_fs4x.glsl
	Draw Phong shading model for multiple lights with MRT output and 
		shadow mapping.
*/

#version 410

// ****TO-DO: 
//	0) copy existing Phong shader
//	1) receive shadow coordinate
//	2) perform perspective divide
//	3) declare shadow map texture
//	4) perform shadow test


uniform sampler2D uTex_dm;	//diffuse map
uniform sampler2D uTex_sm;	//specular map


const float ambientStrength = 0.0f;
const int shine = 4;		//2 to the power of this number
const int NUM_LIGHT = 4;	//or 3, check this, I think dan said there was 5 lights
							//		make it so if the num of lights does not equal this (or is atleast greater) number here, then set the object to hot pink

//line 86 DemoShaderProgram.h, light uniform names location
uniform int uLightCt;		//not float, use for num of lights
uniform vec4 uLightPos[NUM_LIGHT];
uniform vec4 uLightCol[NUM_LIGHT];
uniform sampler2D uTex_shadow;	//this is the shadowmap

in vec2 vTexcoord;
in vec4 vMV_nrm_by_nrm;
in vec4 vMV_pos;
in vec4 vProjClip;

layout(location = 0) out vec4 rtFragColor;
layout(location = 1) out vec4 rtViewPosition;
layout(location = 2) out vec4 rtViewNormal;
layout(location = 3) out vec4 rtAtlasTexcoord;
layout(location = 4) out vec4 rtDiffuseMap;			
layout(location = 5) out vec4 rtSpecularMap;
layout(location = 6) out vec4 rtDiffuseTotal;
layout(location = 7) out vec4 rtSpecularTotal;


//i like to leave ambient as a seperate function because it doesnt have many dependencies to work,
//	its basic enough to just understand if the objects appear in the scene
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


vec4 phongLightRun(vec4 t_final_dm, vec4 t_final_sm)
{
	vec4 temp;
	
	if(NUM_LIGHT < uLightCt)
	{
		return vec4(1.0, 0.15, 0.0, 1.0);	
	}
	else
	{
		vec4 N = normalize(vMV_nrm_by_nrm);
		rtViewNormal = vec4(N.xyz, 1.0);

		vec4 sTotal = vec4(0.0,0.0,0.0,0.0);
		vec4 dTotal = vec4(0.0,0.0,0.0,0.0);
		
		vec4 projScreen = vProjClip / vProjClip.w;				//slide 13
		float shadowSample = texture(uTex_shadow, projScreen.xy).r;	//slide 21
		bool fragIsShadowed = (projScreen.z > (shadowSample + 0.0025));		//slide 24 (z fighting fix, use tiny offset)


		for(int i = 0; i < uLightCt; i++)
		{
			vec4 L = normalize(uLightPos[i] - vMV_pos);
			vec4 V = normalize(vMV_pos);					//view vector from eye to the point we are looking at
			vec4 R = reflect(-L, N);						//lD is negative because its pointing FROM light source, in current state it points towards it

			vec4 amb = ambient(ambientStrength, uLightCol[i]);

			float diff = max(0.0, dot(N, L));

			if(fragIsShadowed)		//scale down diffuse effect if fragment is under shadow
			{
				diff *= 0.2;
			}

			vec4 diffuse = vec4((diff * t_final_dm) * uLightCol[i]);
			dTotal += (diff);

			float spec = max(0.0, dot(V, R));
			for(int i = 0; i < shine; i++)
			{
				spec *= spec;
			}

			vec4 s = (spec * t_final_sm);
			vec4 specular = vec4( s * uLightCol[i]);
			sTotal += spec;

			temp += (amb + diffuse + specular);
		}

		rtDiffuseTotal = dTotal;
		rtSpecularTotal = sTotal;
		return temp;
	}
	
};

//test functions
vec4 textureCoordTest(vec2 tc) { return vec4(tc, 0.0, 1.0); };
vec4 viewNormsTest(vec4 mvNxN) { return mvNxN; };

void main()
{
	
	vec4 t_final_dm = texture(uTex_dm, vTexcoord);
	vec4 t_final_sm = texture(uTex_sm, vTexcoord);

	rtFragColor = phongLightRun(t_final_dm, t_final_sm);	
	rtAtlasTexcoord = vec4(vTexcoord, 0.0, 1.0);
	rtViewPosition = vMV_pos;
	rtDiffuseMap = vec4(t_final_dm.rgb, 1.0);
	rtSpecularMap = vec4(t_final_sm.rgb, 1.0);

	

	//testing
	//rtFragColor = textureCoordTest(vTexcoord);
	//rtFragColor = viewNormsTest(vMV_nrm_by_nrm);
	//rtFragColor = texture(uTex_dm, vTexcoord);
}
