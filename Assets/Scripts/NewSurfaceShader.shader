Shader "Custom/ShaderTuto" {
	Properties {
		_AmbientLightColor ("Ambient Color Light", Color) = (1, 1, 1, 1)
		_AmbientLightIntensity("Ambient Light Intensity", Range(0.0, 1.0)) = 1.0
	}
	SubShader {
		Pass{
			CGPROGRAM
			#pragma target 2.0
			#pragma vertex vertexShader
			#pragma fragment fragmentShader

			fixed4 _AmbientLightColor;
			float _AmbientLightIntensity;

			float4 vertexShader(float4 v:POSITION) : SV_POSITION
			{
				return mul(UNITY_MATRIX_MVP, v);
			}

			fixed4 fragmentShader() : SV_TARGET
			{
				return _AmbientLightColor * _AmbientLightIntensity;
			}

			ENDCG
		}
	}
	FallBack "Diffuse"
}
