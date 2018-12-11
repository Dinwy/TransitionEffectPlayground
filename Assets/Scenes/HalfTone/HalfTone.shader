// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Dinwy/HalfTone"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
		[PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" {}
		_Speed("Speed", Vector) = (0,1,0,0)
		_BackgroundImage("BackgroundImage", 2D) = "white" {}
		_Diffuse("Diffuse", 2D) = "white" {}
		_Scale("Scale", Float) = 40
		[HideInInspector] _texcoord3( "", 2D ) = "white" {}
	}

	SubShader
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }

		Cull Off
		Lighting Off
		ZWrite Off
		Blend One OneMinusSrcAlpha
		
		
		Pass
		{
		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile _ PIXELSNAP_ON
			#pragma multi_compile _ ETC1_EXTERNAL_ALPHA
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				float4 ase_texcoord2 : TEXCOORD2;
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				float2 texcoord  : TEXCOORD0;
				UNITY_VERTEX_OUTPUT_STEREO
				float4 ase_texcoord1 : TEXCOORD1;
			};
			
			uniform fixed4 _Color;
			uniform float _EnableExternalAlpha;
			uniform sampler2D _MainTex;
			uniform sampler2D _AlphaTex;
			uniform sampler2D _Diffuse;
			uniform float2 _Speed;
			uniform float _Scale;
			uniform sampler2D _BackgroundImage;
			uniform float4 _BackgroundImage_ST;
			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				OUT.ase_texcoord1.xy = IN.ase_texcoord2.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				OUT.ase_texcoord1.zw = 0;
				
				IN.vertex.xyz +=  float3(0,0,0) ; 
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color * _Color;
				#ifdef PIXELSNAP_ON
				OUT.vertex = UnityPixelSnap (OUT.vertex);
				#endif

				return OUT;
			}

			fixed4 SampleSpriteTexture (float2 uv)
			{
				fixed4 color = tex2D (_MainTex, uv);

#if ETC1_EXTERNAL_ALPHA
				// get the color from an external texture (usecase: Alpha support for ETC1 on android)
				fixed4 alpha = tex2D (_AlphaTex, uv);
				color.a = lerp (color.a, alpha.r, _EnableExternalAlpha);
#endif //ETC1_EXTERNAL_ALPHA

				return color;
			}
			
			fixed4 frag(v2f IN  ) : SV_Target
			{
				float2 uv10 = IN.texcoord.xy * ( _ScreenParams / _Scale ).xy + float2( 0,0 );
				float2 panner36 = ( _Time.y * ( _Speed * -1.0 ) + uv10);
				float2 uv3_BackgroundImage = IN.ase_texcoord1.xy * _BackgroundImage_ST.xy + _BackgroundImage_ST.zw;
				
				fixed4 c = ( tex2D( _Diffuse, panner36 ) + tex2D( _BackgroundImage, uv3_BackgroundImage ) );
				c.rgb *= c.a;
				return c;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16100
1927;109;1894;833;859.598;773.1313;1;True;False
Node;AmplifyShaderEditor.ScreenParams;78;-1039.89,-375.92;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;82;-1026.39,-139.82;Float;False;Property;_Scale;Scale;3;0;Create;True;0;0;False;0;40;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;81;-799.39,-238.82;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-578.7089,79.33124;Float;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;False;0;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;37;-589.5687,-61.76801;Float;False;Property;_Speed;Speed;0;0;Create;True;0;0;True;0;0,1;1,-1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TimeNode;43;-470.9044,166.517;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-394.7089,-67.66876;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-556.0996,-240.8001;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;55;-512.615,-495.7842;Float;True;Property;_Diffuse;Diffuse;2;0;Create;True;0;0;False;0;e418ed550f6e9d34eae17c4ea329fbbe;fc34e15bcb9bc2f48ae4a5b1a35b5733;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.PannerNode;36;-209.7686,-188.468;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;84;-337.5548,336.6127;Float;True;Property;_BackgroundImage;BackgroundImage;1;0;Create;True;0;0;False;0;e418ed550f6e9d34eae17c4ea329fbbe;c18f8c7ed00a4d64a9a9ee89870a8994;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SamplerNode;85;-29.38727,63.09116;Float;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;True;0;None;None;True;2;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;46;32.19559,-212.9829;Float;True;Property;_Texture;Texture;3;0;Create;True;0;0;True;0;None;None;True;2;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;83;470.8141,-166.0142;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;77;635.2001,-200.7;Float;False;True;2;Float;ASEMaterialInspector;0;5;Dinwy/HalfTone;0f8ba0101102bb14ebf021ddadce9b49;0;0;SubShader 0 Pass 0;2;True;3;1;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;True;2;False;-1;False;False;True;2;False;-1;False;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;81;0;78;0
WireConnection;81;1;82;0
WireConnection;64;0;37;0
WireConnection;64;1;65;0
WireConnection;10;0;81;0
WireConnection;36;0;10;0
WireConnection;36;2;64;0
WireConnection;36;1;43;2
WireConnection;85;0;84;0
WireConnection;46;0;55;0
WireConnection;46;1;36;0
WireConnection;83;0;46;0
WireConnection;83;1;85;0
WireConnection;77;0;83;0
ASEEND*/
//CHKSM=3EAA98B3E6C5984C9578778901AECF71F4D6C402