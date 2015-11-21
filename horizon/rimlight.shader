// Upgrade NOTE: replaced 'PositionFog()' with multiply of UNITY_MATRIX_MVP by position
// Upgrade NOTE: replaced 'V2F_POS_FOG' with 'float4 pos : SV_POSITION'

Shader "Rim Light" {
	
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_RimColor ("Rim Color", Color) = (1, 1, 1, 1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	
	SubShader {
		
		Pass {
			
			Program "vp" {
// Vertex combos: 1
//   opengl - ALU: 23 to 23
//   d3d9 - ALU: 23 to 23
//   d3d11 - ALU: 12 to 12, TEX: 0 to 0, FLOW: 1 to 1
//   d3d11_9x - ALU: 12 to 12, TEX: 0 to 0, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 9 [_WorldSpaceCameraPos]
Matrix 5 [_World2Object]
Vector 10 [unity_Scale]
Vector 11 [_MainTex_ST]
Vector 12 [_RimColor]
"!!ARBvp1.0
# 23 ALU
PARAM c[14] = { { 1, 0.69999999, 0, 1.4285715 },
		state.matrix.mvp,
		program.local[5..12],
		{ 2, 3 } };
TEMP R0;
TEMP R1;
MOV R1.w, c[0].x;
MOV R1.xyz, c[9];
DP4 R0.z, R1, c[7];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
MAD R0.xyz, R0, c[10].w, -vertex.position;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, R0;
DP3 R0.x, vertex.normal, R0;
ADD R0.x, -R0, c[0].y;
MUL R0.x, R0, c[0].w;
MIN R0.x, R0, c[0];
MAX R0.x, R0, c[0].z;
MAD R0.y, -R0.x, c[13].x, c[13];
MUL R0.x, R0, R0;
MUL R0.x, R0, R0.y;
MUL result.color.xyz, R0.x, c[12];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[11], c[11].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 23 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Matrix 4 [_World2Object]
Vector 9 [unity_Scale]
Vector 10 [_MainTex_ST]
Vector 11 [_RimColor]
"vs_2_0
; 23 ALU
def c12, 1.00000000, 0.69999999, 1.42857146, 0.00000000
def c13, 2.00000000, 3.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mov r1.w, c12.x
mov r1.xyz, c8
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
mad r0.xyz, r0, c9.w, -v0
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
dp3 r0.x, v1, r0
add r0.x, -r0, c12.y
mul r0.x, r0, c12.z
min r0.x, r0, c12
max r0.x, r0, c12.w
mad r0.y, -r0.x, c13.x, c13
mul r0.x, r0, r0
mul r0.x, r0, r0.y
mul oD0.xyz, r0.x, c11
mad oT0.xy, v2, c10, c10.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "d3d11 " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 64 // 48 used size, 4 vars
Vector 16 [_MainTex_ST] 4
Vector 32 [_RimColor] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 21 instructions, 1 temp regs, 0 temp arrays:
// ALU 12 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0
eefiecedchjkelfjaihegeknpnmjpkkmjloojnpbabaaaaaafiaeaaaaadaaaaaa
cmaaaaaakaaaaaaabeabaaaaejfdeheogmaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaafjaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaahahaaaagaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
apadaaaafaepfdejfeejepeoaaeoepfcenebemaafeeffiedepepfceeaaklklkl
epfdeheogmaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaaadaaaaaa
aaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaadamaaaa
gfaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahaiaaaafdfgfpfaepfdejfe
ejepeoaafeeffiedepepfceeaaedepemepfcaaklfdeieefcdmadaaaaeaaaabaa
mpaaaaaafjaaaaaeegiocaaaaaaaaaaaadaaaaaafjaaaaaeegiocaaaabaaaaaa
afaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaabaaaaaafpaaaaaddcbabaaaacaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
giaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaacaaaaaaegiacaaaaaaaaaaaabaaaaaa
ogikcaaaaaaaaaaaabaaaaaadiaaaaajhcaabaaaaaaaaaaafgifcaaaabaaaaaa
aeaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaalhcaabaaaaaaaaaaaegiccaaa
acaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaaaaaaaaadcaaaaal
hcaabaaaaaaaaaaaegiccaaaacaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaa
egacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaa
acaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaa
acaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
baaaaaahbcaabaaaaaaaaaaaegbcbaaaabaaaaaaegacbaaaaaaaaaaaaaaaaaai
bcaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaadddddddpdicaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaagonllgdpdcaaaaajccaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaamaabeaaaaaaaaaeaeadiaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaadiaaaaaihccabaaaacaaaaaa
agaabaaaaaaaaaaaegiccaaaaaaaaaaaacaaaaaadoaaaaab"
}

SubProgram "gles " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _RimColor;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;

uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _WorldSpaceCameraPos;
  highp float t_2;
  t_2 = max (min ((((1.0 - dot (normalize(_glesNormal), normalize((((_World2Object * tmpvar_1).xyz * unity_Scale.w) - _glesVertex.xyz)))) - 0.3) / 0.7), 1.0), 0.0);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR = (vec3((t_2 * (t_2 * (3.0 - (2.0 * t_2))))) * _RimColor.xyz);
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Color;
uniform sampler2D _MainTex;
void main ()
{
  highp vec4 texcol_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  texcol_1 = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (texcol_1 * _Color);
  texcol_1.w = tmpvar_3.w;
  texcol_1.xyz = (tmpvar_3.xyz + xlv_COLOR);
  gl_FragData[0] = texcol_1;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _RimColor;
uniform highp vec4 _MainTex_ST;
uniform highp vec4 unity_Scale;
uniform highp mat4 _World2Object;

uniform highp vec3 _WorldSpaceCameraPos;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _WorldSpaceCameraPos;
  highp float t_2;
  t_2 = max (min ((((1.0 - dot (normalize(_glesNormal), normalize((((_World2Object * tmpvar_1).xyz * unity_Scale.w) - _glesVertex.xyz)))) - 0.3) / 0.7), 1.0), 0.0);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_COLOR = (vec3((t_2 * (t_2 * (3.0 - (2.0 * t_2))))) * _RimColor.xyz);
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
uniform highp vec4 _Color;
uniform sampler2D _MainTex;
void main ()
{
  highp vec4 texcol_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  texcol_1 = tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = (texcol_1 * _Color);
  texcol_1.w = tmpvar_3.w;
  texcol_1.xyz = (tmpvar_3.xyz + xlv_COLOR);
  gl_FragData[0] = texcol_1;
}



#endif"
}

SubProgram "flash " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 8 [_WorldSpaceCameraPos]
Matrix 4 [_World2Object]
Vector 9 [unity_Scale]
Vector 10 [_MainTex_ST]
Vector 11 [_RimColor]
"agal_vs
c12 1.0 0.7 1.428571 0.0
c13 2.0 3.0 0.0 0.0
[bc]
aaaaaaaaabaaaiacamaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c12.x
aaaaaaaaabaaahacaiaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c8
bdaaaaaaaaaaaeacabaaaaoeacaaaaaaagaaaaoeabaaaaaa dp4 r0.z, r1, c6
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, r1, c4
bdaaaaaaaaaaacacabaaaaoeacaaaaaaafaaaaoeabaaaaaa dp4 r0.y, r1, c5
adaaaaaaabaaahacaaaaaakeacaaaaaaajaaaappabaaaaaa mul r1.xyz, r0.xyzz, c9.w
acaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r0.xyz, r1.xyzz, a0
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaaaaaahacaaaaaappacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r0.w, r0.xyzz
bcaaaaaaaaaaabacabaaaaoeaaaaaaaaaaaaaakeacaaaaaa dp3 r0.x, a1, r0.xyzz
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaamaaaaffabaaaaaa add r0.x, r0.x, c12.y
adaaaaaaaaaaabacaaaaaaaaacaaaaaaamaaaakkabaaaaaa mul r0.x, r0.x, c12.z
agaaaaaaaaaaabacaaaaaaaaacaaaaaaamaaaaoeabaaaaaa min r0.x, r0.x, c12
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaamaaaappabaaaaaa max r0.x, r0.x, c12.w
bfaaaaaaabaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1.x, r0.x
adaaaaaaaaaaacacabaaaaaaacaaaaaaanaaaaaaabaaaaaa mul r0.y, r1.x, c13.x
abaaaaaaaaaaacacaaaaaaffacaaaaaaanaaaaoeabaaaaaa add r0.y, r0.y, c13
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaacaaaaaa mul r0.x, r0.x, r0.x
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaffacaaaaaa mul r0.x, r0.x, r0.y
adaaaaaaahaaahaeaaaaaaaaacaaaaaaalaaaaoeabaaaaaa mul v7.xyz, r0.x, c11
adaaaaaaaaaaadacadaaaaoeaaaaaaaaakaaaaoeabaaaaaa mul r0.xy, a3, c10
abaaaaaaaaaaadaeaaaaaafeacaaaaaaakaaaaooabaaaaaa add v0.xy, r0.xyyy, c10.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaahaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v7.w, c0
"
}

SubProgram "d3d11_9x " {
Keywords { }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
ConstBuffer "$Globals" 64 // 48 used size, 4 vars
Vector 16 [_MainTex_ST] 4
Vector 32 [_RimColor] 4
ConstBuffer "UnityPerCamera" 128 // 76 used size, 8 vars
Vector 64 [_WorldSpaceCameraPos] 3
ConstBuffer "UnityPerDraw" 336 // 336 used size, 6 vars
Matrix 0 [glstate_matrix_mvp] 4
Matrix 256 [_World2Object] 4
Vector 320 [unity_Scale] 4
BindCB "$Globals" 0
BindCB "UnityPerCamera" 1
BindCB "UnityPerDraw" 2
// 21 instructions, 1 temp regs, 0 temp arrays:
// ALU 12 float, 0 int, 0 uint
// TEX 0 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"vs_4_0_level_9_3
eefiecedmglcmpbbmcnakpmcjfbnfajigahgdeaaabaaaaaakaagaaaaaeaaaaaa
daaaaaaaheacaaaaliafaaaacmagaaaaebgpgodjdmacaaaadmacaaaaaaacpopp
oeabaaaafiaaaaaaaeaaceaaaaaafeaaaaaafeaaaaaaceaaabaafeaaaaaaabaa
acaaabaaaaaaaaaaabaaaeaaabaaadaaaaaaaaaaacaaaaaaaeaaaeaaaaaaaaaa
acaabaaaafaaaiaaaaaaaaaaaaaaaaaaabacpoppfbaaaaafanaaapkadddddddp
gonllgdpaaaaaaaaaaaaiadpfbaaaaafaoaaapkaaaaaaamaaaaaeaeaaaaaaaaa
aaaaaaaabpaaaaacafaaaaiaaaaaapjabpaaaaacafaaabiaabaaapjabpaaaaac
afaaaciaacaaapjaabaaaaacaaaaahiaadaaoekaafaaaaadabaaahiaaaaaffia
ajaaoekaaeaaaaaeaaaaaliaaiaakekaaaaaaaiaabaakeiaaeaaaaaeaaaaahia
akaaoekaaaaakkiaaaaapeiaacaaaaadaaaaahiaaaaaoeiaalaaoekaaeaaaaae
aaaaahiaaaaaoeiaamaappkaaaaaoejbceaaaaacabaaahiaaaaaoeiaaiaaaaad
aaaaabiaabaaoejaabaaoeiaacaaaaadaaaaabiaaaaaaaibanaaaakaafaaaaad
aaaaabiaaaaaaaiaanaaffkaalaaaaadaaaaabiaaaaaaaiaanaakkkaakaaaaad
aaaaabiaaaaaaaiaanaappkaaeaaaaaeaaaaaciaaaaaaaiaaoaaaakaaoaaffka
afaaaaadaaaaabiaaaaaaaiaaaaaaaiaafaaaaadaaaaabiaaaaaaaiaaaaaffia
afaaaaadabaaahoaaaaaaaiaacaaoekaaeaaaaaeaaaaadoaacaaoejaabaaoeka
abaaookaafaaaaadaaaaapiaaaaaffjaafaaoekaaeaaaaaeaaaaapiaaeaaoeka
aaaaaajaaaaaoeiaaeaaaaaeaaaaapiaagaaoekaaaaakkjaaaaaoeiaaeaaaaae
aaaaapiaahaaoekaaaaappjaaaaaoeiaaeaaaaaeaaaaadmaaaaappiaaaaaoeka
aaaaoeiaabaaaaacaaaaammaaaaaoeiappppaaaafdeieefcdmadaaaaeaaaabaa
mpaaaaaafjaaaaaeegiocaaaaaaaaaaaadaaaaaafjaaaaaeegiocaaaabaaaaaa
afaaaaaafjaaaaaeegiocaaaacaaaaaabfaaaaaafpaaaaadpcbabaaaaaaaaaaa
fpaaaaadhcbabaaaabaaaaaafpaaaaaddcbabaaaacaaaaaaghaaaaaepccabaaa
aaaaaaaaabaaaaaagfaaaaaddccabaaaabaaaaaagfaaaaadhccabaaaacaaaaaa
giaaaaacabaaaaaadiaaaaaipcaabaaaaaaaaaaafgbfbaaaaaaaaaaaegiocaaa
acaaaaaaabaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaaacaaaaaaaaaaaaaa
agbabaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpcaabaaaaaaaaaaaegiocaaa
acaaaaaaacaaaaaakgbkbaaaaaaaaaaaegaobaaaaaaaaaaadcaaaaakpccabaaa
aaaaaaaaegiocaaaacaaaaaaadaaaaaapgbpbaaaaaaaaaaaegaobaaaaaaaaaaa
dcaaaaaldccabaaaabaaaaaaegbabaaaacaaaaaaegiacaaaaaaaaaaaabaaaaaa
ogikcaaaaaaaaaaaabaaaaaadiaaaaajhcaabaaaaaaaaaaafgifcaaaabaaaaaa
aeaaaaaaegiccaaaacaaaaaabbaaaaaadcaaaaalhcaabaaaaaaaaaaaegiccaaa
acaaaaaabaaaaaaaagiacaaaabaaaaaaaeaaaaaaegacbaaaaaaaaaaadcaaaaal
hcaabaaaaaaaaaaaegiccaaaacaaaaaabcaaaaaakgikcaaaabaaaaaaaeaaaaaa
egacbaaaaaaaaaaaaaaaaaaihcaabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaa
acaaaaaabdaaaaaadcaaaaalhcaabaaaaaaaaaaaegacbaaaaaaaaaaapgipcaaa
acaaaaaabeaaaaaaegbcbaiaebaaaaaaaaaaaaaabaaaaaahicaabaaaaaaaaaaa
egacbaaaaaaaaaaaegacbaaaaaaaaaaaeeaaaaaficaabaaaaaaaaaaadkaabaaa
aaaaaaaadiaaaaahhcaabaaaaaaaaaaapgapbaaaaaaaaaaaegacbaaaaaaaaaaa
baaaaaahbcaabaaaaaaaaaaaegbcbaaaabaaaaaaegacbaaaaaaaaaaaaaaaaaai
bcaabaaaaaaaaaaaakaabaiaebaaaaaaaaaaaaaaabeaaaaadddddddpdicaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaabeaaaaagonllgdpdcaaaaajccaabaaa
aaaaaaaaakaabaaaaaaaaaaaabeaaaaaaaaaaamaabeaaaaaaaaaeaeadiaaaaah
bcaabaaaaaaaaaaaakaabaaaaaaaaaaaakaabaaaaaaaaaaadiaaaaahbcaabaaa
aaaaaaaaakaabaaaaaaaaaaabkaabaaaaaaaaaaadiaaaaaihccabaaaacaaaaaa
agaabaaaaaaaaaaaegiccaaaaaaaaaaaacaaaaaadoaaaaabejfdeheogmaaaaaa
adaaaaaaaiaaaaaafaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapapaaaa
fjaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaaahahaaaagaaaaaaaaaaaaaaa
aaaaaaaaadaaaaaaacaaaaaaapadaaaafaepfdejfeejepeoaaeoepfcenebemaa
feeffiedepepfceeaaklklklepfdeheogmaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadamaaaagfaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahaiaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaedepemepfcaakl
"
}

}
Program "fp" {
// Fragment combos: 1
//   opengl - ALU: 4 to 4, TEX: 1 to 1
//   d3d9 - ALU: 3 to 3, TEX: 1 to 1
//   d3d11 - ALU: 1 to 1, TEX: 1 to 1, FLOW: 1 to 1
//   d3d11_9x - ALU: 1 to 1, TEX: 1 to 1, FLOW: 1 to 1
SubProgram "opengl " {
Keywords { }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
"!!ARBfp1.0
# 4 ALU, 1 TEX
PARAM c[1] = { program.local[0] };
TEMP R0;
TEX R0, fragment.texcoord[0], texture[0], 2D;
MUL R0, R0, c[0];
ADD result.color.xyz, R0, fragment.color.primary;
MOV result.color.w, R0;
END
# 4 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
"ps_2_0
; 3 ALU, 1 TEX
dcl_2d s0
dcl t0.xy
dcl v0.xyz
texld r0, t0, s0
mul r0, r0, c0
add r0.xyz, r0, v0
mov oC0, r0
"
}

SubProgram "d3d11 " {
Keywords { }
ConstBuffer "$Globals" 64 // 64 used size, 4 vars
Vector 48 [_Color] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
// 5 instructions, 1 temp regs, 0 temp arrays:
// ALU 1 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0
eefieceddafmongglmkdbhkhagcclibpdigaddakabaaaaaamaabaaaaadaaaaaa
cmaaaaaakaaaaaaaneaaaaaaejfdeheogmaaaaaaadaaaaaaaiaaaaaafaaaaaaa
aaaaaaaaabaaaaaaadaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaa
adaaaaaaabaaaaaaadadaaaagfaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaa
ahahaaaafdfgfpfaepfdejfeejepeoaafeeffiedepepfceeaaedepemepfcaakl
epfdeheocmaaaaaaabaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaa
aaaaaaaaapaaaaaafdfgfpfegbhcghgfheaaklklfdeieefcoeaaaaaaeaaaaaaa
djaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaafkaaaaadaagabaaaaaaaaaaa
fibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaagcbaaaad
hcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacabaaaaaaefaaaaaj
pcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaaaaaaaaaa
diaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaaadaaaaaa
dcaaaaakhccabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaaadaaaaaa
egbcbaaaacaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaadoaaaaab
"
}

SubProgram "gles " {
Keywords { }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { }
"!!GLES"
}

SubProgram "flash " {
Keywords { }
Vector 0 [_Color]
SetTexture 0 [_MainTex] 2D
"agal_ps
[bc]
ciaaaaaaaaaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r0, v0, s0 <2d wrap linear point>
adaaaaaaaaaaapacaaaaaaoeacaaaaaaaaaaaaoeabaaaaaa mul r0, r0, c0
abaaaaaaaaaaahacaaaaaakeacaaaaaaahaaaaoeaeaaaaaa add r0.xyz, r0.xyzz, v7
aaaaaaaaaaaaapadaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r0
"
}

SubProgram "d3d11_9x " {
Keywords { }
ConstBuffer "$Globals" 64 // 64 used size, 4 vars
Vector 48 [_Color] 4
BindCB "$Globals" 0
SetTexture 0 [_MainTex] 2D 0
// 5 instructions, 1 temp regs, 0 temp arrays:
// ALU 1 float, 0 int, 0 uint
// TEX 1 (0 load, 0 comp, 0 bias, 0 grad)
// FLOW 1 static, 0 dynamic
"ps_4_0_level_9_3
eefiecedgdlceakdgdiojhkbadjpfchlpmlaofamabaaaaaagmacaaaaaeaaaaaa
daaaaaaaniaaaaaameabaaaadiacaaaaebgpgodjkaaaaaaakaaaaaaaaaacpppp
gmaaaaaadeaaaaaaabaaciaaaaaadeaaaaaadeaaabaaceaaaaaadeaaaaaaaaaa
aaaaadaaabaaaaaaaaaaaaaaabacppppbpaaaaacaaaaaaiaaaaaadlabpaaaaac
aaaaaaiaabaaahlabpaaaaacaaaaaajaaaaiapkaecaaaaadaaaaapiaaaaaoela
aaaioekaafaaaaadabaaaiiaaaaappiaaaaappkaaeaaaaaeabaaahiaaaaaoeia
aaaaoekaabaaoelaabaaaaacaaaiapiaabaaoeiappppaaaafdeieefcoeaaaaaa
eaaaaaaadjaaaaaafjaaaaaeegiocaaaaaaaaaaaaeaaaaaafkaaaaadaagabaaa
aaaaaaaafibiaaaeaahabaaaaaaaaaaaffffaaaagcbaaaaddcbabaaaabaaaaaa
gcbaaaadhcbabaaaacaaaaaagfaaaaadpccabaaaaaaaaaaagiaaaaacabaaaaaa
efaaaaajpcaabaaaaaaaaaaaegbabaaaabaaaaaaeghobaaaaaaaaaaaaagabaaa
aaaaaaaadiaaaaaiicaabaaaaaaaaaaadkaabaaaaaaaaaaadkiacaaaaaaaaaaa
adaaaaaadcaaaaakhccabaaaaaaaaaaaegacbaaaaaaaaaaaegiccaaaaaaaaaaa
adaaaaaaegbcbaaaacaaaaaadgaaaaaficcabaaaaaaaaaaadkaabaaaaaaaaaaa
doaaaaabejfdeheogmaaaaaaadaaaaaaaiaaaaaafaaaaaaaaaaaaaaaabaaaaaa
adaaaaaaaaaaaaaaapaaaaaafmaaaaaaaaaaaaaaaaaaaaaaadaaaaaaabaaaaaa
adadaaaagfaaaaaaaaaaaaaaaaaaaaaaadaaaaaaacaaaaaaahahaaaafdfgfpfa
epfdejfeejepeoaafeeffiedepepfceeaaedepemepfcaaklepfdeheocmaaaaaa
abaaaaaaaiaaaaaacaaaaaaaaaaaaaaaaaaaaaaaadaaaaaaaaaaaaaaapaaaaaa
fdfgfpfegbhcghgfheaaklkl"
}

}

#LINE 62

		}
	}
}
