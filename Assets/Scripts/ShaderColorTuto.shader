Shader "Custom/ShaderColorTuto" {
	Properties { //This is some exemples of properties you can use in shaders. They're kind of public vars.
		_MainText ("My texture", 2D) = "white" {}
		/*_MyNormalMap ("My normal map", 2D) = "bump" {}	// Grey
	 
		_MyInt ("My integer", Int) = 2
		_MyFloat ("My float", Float) = 1.5
		_MyRange ("My range", Range(0.0, 1.0)) = 0.5
	 
		_MyColor ("My colour", Color) = (1, 0, 0, 1)	// (R, G, B, A)
		_MyVector ("My Vector4", Vector) = (0, 0, 0, 0)	// (x, y, z, w)*/

		_r ("Red indice", Range(0.0, 1.0)) = 1.0
		_g ("Green indice", Range(0.0, 1.0)) = 1.0
		_b ("Blue indice", Range(0.0, 1.0)) = 1.0
		_a ("Alpha indice", Range(0.0, 1.0)) = 1.0
	}

	SubShader {
		Tags { //Used to tell Unity how to render the shader
			"Queue" = "Transparent" //the order it should be rendered (geometry = further ones are drawn first)
			"RenderType"="TransparentCutout" //How it should be rendered
		}
		LOD 200

		Pass{ //This is needed for vertex and fragment shaders
			CGPROGRAM

			#pragma vertex vert //Vertex shader = calculation done on vertex
			#pragma fragment frag //Fragment shader = calculation on the colour of every pixels

			float _r;
			float _g;
			float _b;
			float _a;

			struct vertInput{
				float4 pos : POSITION;
			};

			struct vertOutput{
				float4 pos : SV_POSITION;
			};

			vertOutput vert(vertInput input){ //Converts the vertices from their native 3D space to their final 2D position on the screen
				vertOutput o;
				o.pos = mul(UNITY_MATRIX_MVP, input.pos);
				return o;
			}

			half4 frag(vertOutput output) : COLOR { //Color the surface in red
				return half4(_r, _g, _b, _a);
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
