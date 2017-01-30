Shader "Custom/GeometryShaderTest" {
	Properties {
		_AmbientLightColor ("Ambient Color Light", Color) = (1, 1, 1, 1)
		_Size ("Size", Range(0, 3)) = 1.0
		_Distance ("Distance", Range(0, 3)) = 1.0
	}
	SubShader {
		Pass{
			Tags { "RenderType"="Opaque" }
			LOD 200

			CGPROGRAM
				#pragma target 4.0
				#pragma vertex VS_Main
				#pragma geometry GS_Main
				#pragma fragment FS_Main
				#include "UnityCG.cginc" 


				struct GS_INPUT
				{
					float4	pos		: POSITION;
					float3	normal	: NORMAL;
					fixed4  tex0	: COLOR;
				};

				struct FS_INPUT{
					float4	pos		: POSITION;
					float3	normal	: NORMAL;
					fixed4  tex0	: COLOR;
				};

				float _Size;
				float _Distance;
				fixed4 _AmbientLightColor;

				GS_INPUT VS_Main(appdata_base v)
				{
					GS_INPUT output = (GS_INPUT)0;

					output.pos =  mul(UNITY_MATRIX_MVP, v.vertex);
					output.normal = v.normal;
					output.tex0 = _AmbientLightColor;

					return output;
				}
				
				[maxvertexcount(4)]
				void GS_Main(triangle GS_INPUT p[3], inout TriangleStream<FS_INPUT> triStream){
					FS_INPUT fIn;
					
					fIn.pos = float4(p[0].pos[0] + _Distance, p[0].pos[1] + _Distance, p[0].pos[2] + _Distance, p[0].pos[3] + _Distance);
					fIn.normal = float3(p[0].normal[0] + _Distance, p[0].normal[1] + _Size, p[0].normal[2] + _Size);
					fIn.tex0 = p[0].tex0;
					triStream.Append(fIn);

					fIn.pos = float4(p[1].pos[0] + _Distance, p[1].pos[1] + _Distance, p[1].pos[2] + _Distance, p[1].pos[3] + _Distance);
					fIn.normal = float3(p[1].normal[0] + _Size, p[1].normal[1] + _Size, p[1].normal[2] + _Size);
					fIn.tex0 = p[1].tex0;
					triStream.Append(fIn);

					fIn.pos = float4(p[2].pos[0] + _Distance, p[2].pos[1] + _Distance, p[2].pos[2] + _Distance, p[2].pos[3] + _Distance);
					fIn.normal = float3(p[2].normal[0] + _Size, p[2].normal[1] + _Size, p[2].normal[2] + _Size);
					fIn.tex0 = p[2].tex0;
					triStream.Append(fIn);
					
				}

				fixed4 FS_Main(FS_INPUT input) : COLOR
				{
					return _AmbientLightColor;
				}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
