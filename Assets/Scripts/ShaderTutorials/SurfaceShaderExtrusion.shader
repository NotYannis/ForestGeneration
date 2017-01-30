Shader "Custom/SurfaceShaderExtrusion" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Color("Color", Color) = (1, 1, 1, 1)
		_Growth("Growth Amount", Range(0.01, 2)) = 0.01
		_Gloss("Gloss", Range(-2, 2)) = 0.1
		_Specular("Specular", Range(0, 1)) = 0.1
		_Emission("Light Emission", Range(0, 1)) = 0.0
	}
	SubShader {
		Tags { 
			"RenderType"="Opaque" 
			"DisableBatching" = "True"
		}
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert vertex:vert

		//IDEA : use this extrusion shader to make the tree grow.
		//I just need to know how to stop extrusion when primitives exceed the center of the tree

		struct Input {
			float2 uv_MainTex;
		};

		float4 _Color;
		float _Growth;

		void vert(inout appdata_full v){
			v.vertex = mul(v.vertex, _Growth);
			v.texcoord = mul(v.texcoord, _Growth);
			v.normal = mul(v.normal, _Growth);
		}

		fixed _Emission;
		half _Specular;
		fixed _Gloss;
		sampler2D _MainTex;

		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo = _Color;
			o.Gloss = _Gloss;
			o.Specular = _Specular;
			o.Emission = fixed3(_Emission, _Emission, _Emission);
		}
		ENDCG
	}
	FallBack "Diffuse"
}
