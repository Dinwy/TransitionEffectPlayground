// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PokemonTransition"
{
	Properties
	{
		_Color("Color", Color) = (0,0,0,0)
		_TransitionTexture("TransitionTexture", 2D) = "white" {}
		_Diffuse("Diffuse", 2D) = "white" {}
		_Cutoff("Cutoff", Range( 0 , 1)) = 0
		_Distort("Distort", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}
	
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		

		Pass
		{
			Name "Unlit"
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			

			struct appdata
			{
				float4 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord : TEXCOORD0;
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_OUTPUT_STEREO
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			uniform sampler2D _TransitionTexture;
			uniform float4 _TransitionTexture_ST;
			uniform float _Cutoff;
			uniform sampler2D _Diffuse;
			uniform float4 _Diffuse_ST;
			uniform float _Distort;
			uniform float4 _Color;
			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				
				v.vertex.xyz +=  float3(0,0,0) ;
				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				fixed4 finalColor;
				float2 uv_TransitionTexture = i.ase_texcoord.xy * _TransitionTexture_ST.xy + _TransitionTexture_ST.zw;
				float4 tex2DNode13 = tex2D( _TransitionTexture, uv_TransitionTexture );
				float2 uv_Diffuse = i.ase_texcoord.xy * _Diffuse_ST.xy + _Diffuse_ST.zw;
				float2 normalizeResult15 = normalize( ( ( ( tex2DNode13.g - 0.5 ) * 2.0 ) * ( ( tex2DNode13.r - 0.5 ) * 2.0 ) * float2( 1,0 ) ) );
				float2 _Vector0 = float2(0,0);
				float2 ifLocalVar28 = 0;
				if( _Distort <= 0.0 )
				ifLocalVar28 = _Vector0;
				else
				ifLocalVar28 = normalizeResult15;
				float2 direction24 = ifLocalVar28;
				float4 tex2DNode10 = tex2D( _Diffuse, ( uv_Diffuse + ( _Cutoff * direction24 ) ) );
				float4 ifLocalVar5 = 0;
				if( tex2DNode13.b >= _Cutoff )
				ifLocalVar5 = tex2DNode10;
				else
				ifLocalVar5 = _Color;
				
				
				finalColor = ifLocalVar5;
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16100
1942;133;1386;620;962.0459;-353.8851;1;True;False
Node;AmplifyShaderEditor.TexturePropertyNode;11;-1093.442,480.189;Float;True;Property;_TransitionTexture;TransitionTexture;1;0;Create;True;0;0;False;0;fc34e15bcb9bc2f48ae4a5b1a35b5733;6dda137af8358a248b686c09e34733f2;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;13;-886.9724,608.0881;Float;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-546.0757,747.3944;Float;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;16;-377.0757,634.2944;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-330.2758,761.6943;Float;False;Constant;_Float1;Float 1;5;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;22;-395.2757,524.9444;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;32;-153.87,772.7174;Float;False;Constant;_Vector1;Vector 1;6;0;Create;True;0;0;False;0;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;-189.8755,539.2444;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-171.6757,648.5944;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;11.2095,558.6231;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NormalizeNode;15;152.7366,486.9877;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;14;6.076606,313.8337;Float;False;Property;_Distort;Distort;4;0;Create;True;0;0;False;0;0;0.89;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;30;299.9331,632.1365;Float;False;Constant;_Vector0;Vector 0;6;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;29;-33.74741,390.9944;Float;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;28;361.2347,333.923;Float;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;575.1781,358.5734;Float;False;direction;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-823.3018,157.6148;Float;False;Property;_Cutoff;Cutoff;3;0;Create;True;0;0;False;0;0;0.172;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-1445.8,491.4211;Float;False;24;direction;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;8;-1589.11,62.98697;Float;True;Property;_Diffuse;Diffuse;2;0;Create;True;0;0;False;0;fc34e15bcb9bc2f48ae4a5b1a35b5733;ed1f150a7ee8a6640b9e3ff8f4f05cde;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-1339.802,299.9148;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1232.076,427.1946;Float;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-1080.976,301.9946;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;6;-639.3018,309.6148;Float;False;Property;_Color;Color;0;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;10;-913.4318,247.4673;Float;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ConditionalIfNode;5;-344.6693,168.4275;Float;False;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;9;61.98575,170.4876;Float;False;True;2;Float;ASEMaterialInspector;0;1;PokemonTransition;0770190933193b94aaa3065e307002fa;0;0;Unlit;2;True;0;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;True;0;False;-1;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;0;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;13;0;11;0
WireConnection;16;0;13;1
WireConnection;16;1;17;0
WireConnection;22;0;13;2
WireConnection;22;1;17;0
WireConnection;23;0;22;0
WireConnection;23;1;19;0
WireConnection;18;0;16;0
WireConnection;18;1;19;0
WireConnection;31;0;23;0
WireConnection;31;1;18;0
WireConnection;31;2;32;0
WireConnection;15;0;31;0
WireConnection;28;0;14;0
WireConnection;28;1;29;0
WireConnection;28;2;15;0
WireConnection;28;3;30;0
WireConnection;28;4;30;0
WireConnection;24;0;28;0
WireConnection;1;2;8;0
WireConnection;26;0;4;0
WireConnection;26;1;27;0
WireConnection;25;0;1;0
WireConnection;25;1;26;0
WireConnection;10;0;8;0
WireConnection;10;1;25;0
WireConnection;5;0;13;3
WireConnection;5;1;4;0
WireConnection;5;2;10;0
WireConnection;5;3;10;0
WireConnection;5;4;6;0
WireConnection;9;0;5;0
ASEEND*/
//CHKSM=D8E1171A9D48133EC7B5F54065F2162FEB93EB4D