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
const float thickness = 0.5;

uniform sampler2D uTex_dm;
uniform sampler2D uTex_nm;

in vec2 vTexcoord;
in vec4 vMV_nrm_by_nrm;
in vec4 vMV_pos;
in vec4 vWorldNorm;

out vec4 rtFragColor;

void main()
{
	//this is just going to end up being like a version of cell shading
	//	but in this case we only want one angle
	//	we want the angle closest to 90 degrees from eye view v normal on fragment post_depth_coverage

	vec4 V = normalize(vMV_pos);	//view vector from eye to the point we are looking at
	vec4 N = normalize(vMV_nrm_by_nrm);



	////this creates a frame effect actually kinda weird
	//if(dot(V, N) < thickness)
	//{
	//	rtFragColor = texture(uTex_dm, vTexcoord) * 0.1f;	//just make it darker
	//}
	//else
	//{
	//	rtFragColor = texture(uTex_dm, vTexcoord);
	//}

	//Wiki for Sobel Operator
	//https://en.wikipedia.org/wiki/Sobel_operator
	//basic edge detection

//	vec3 A = texture(uTex_dm, vTexcoord).rgb;	//image, wiki had only mat3 matrices
//	mat3 Sx = mat3(1.0, 2.0, 1.0,
//						0.0, 0.0, 0.0,
//							-1.0, -2.0, -1.0);		//remember this flips
//	mat3 Sy = mat3(1.0, 0.0, -1.0, 
//						2.0, 0.0, -2.0, 
//							1.0, 0.0, -1.0);
//
//	mat3 final = mat3(0.0);
//	for(int i = 0; i < 3; i++)
//	{
//		for(int j = 0; j < 3; j++)
//		{

	//http://in2gpu.com/2014/06/23/toon-shading-effect-and-simple-contour-detection/

	float edgeDetection = (dot(V, N) > 0.3) ? 1 : 0; 
			
	rtFragColor = edgeDetection * texture(uTex_dm, vTexcoord);


}
