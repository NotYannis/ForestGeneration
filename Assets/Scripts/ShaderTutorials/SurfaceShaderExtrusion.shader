Shader "Custom/SurfaceShaderExtrusion" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Amount ("Extrusion Amount", Range(-2, 1)) = 0

	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert vertex:vert

		//IDEA : use this extrusion shader to make the tree grow.
		//I just need to know how to stop extrusion when primitives exceed the center of the tree

		struct Input {
			float2 uv_MainTex;
		};

		float _Amount;
		void vert(inout appdata_full v){
			v.vertex.xyz += v.normal * _Amount;
			//if(v.vertex.x <= 0.0) v.vertex.x = 0.0;
			//v.vertex.x = step(0.0, v.vertex.x);
			//v.vertex.z = step(0.0, v.vertex.z);
		}

		sampler2D _MainTex;
		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
