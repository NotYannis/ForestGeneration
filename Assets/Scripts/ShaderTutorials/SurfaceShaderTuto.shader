Shader "Custom/SurfaceShaderTuto" {
	Properties {
		_r ("Red indice", Range(0.0, 1.0)) = 1.0
		_g ("Green indice", Range(0.0, 1.0)) = 1.0
		_b ("Blue indice", Range(0.0, 1.0)) = 1.0
		
		_a ("Alpha indice", Range(0.0, 1.0)) = 1.0

		_Center ("Center", Vector) = (0, 0, 0, 0)
		_Radius ("Radius", Float) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Transparent" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert

		float _r;
		float _g;
		float _b;
		float _a;

		float3 _Center;
		float _Radius;


		struct Input {
			float4 color : COLOR;
			float3 worldPos;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			float d = distance(_Center, IN.worldPos);
			float dN = 1 - saturate(d / _Radius);
			dN = step(0.25, dN) * step(dN, 0.3);

			o.Albedo.rgb = fixed3(_r, _g, _b) * (1-dN) + half3(1,1,1) * dN;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
