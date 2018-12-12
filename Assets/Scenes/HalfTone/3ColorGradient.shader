// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "3ColorGradient"
{
	Properties
	{
		_CentralPosition("Central Position", Range( 0.001 , 0.999)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _CentralPosition;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 _Color1 = float4(0,1,0,0);
			float2 uv_TexCoord6 = i.uv_texcoord * float2( 1,1 ) + float2( 0,0 );
			float4 lerpResult4 = lerp( float4(1,0,0,0) , _Color1 , ( uv_TexCoord6.x / _CentralPosition ));
			float4 lerpResult11 = lerp( _Color1 , float4(0,0,1,0) , ( ( uv_TexCoord6.x - _CentralPosition ) / ( 1.0 - _CentralPosition ) ));
			o.Albedo = ( ( lerpResult4 * step( uv_TexCoord6.x , _CentralPosition ) ) + ( lerpResult11 * step( _CentralPosition , uv_TexCoord6.x ) ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=14205
955;92;965;966;2098.714;932.0085;2.654644;True;False
Node;AmplifyShaderEditor.RangedFloatNode;7;-1408,384;Float;False;Property;_CentralPosition;Central Position;1;0;Create;True;0;0.4507923;0.001;0.999;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1408,128;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;8;-896,512;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;10;-1024,640;Float;False;1;0;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;2;-1408,-304;Float;False;Constant;_Color1;Color 1;1;0;Create;True;0,1,0,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-1408,-128;Float;False;Constant;_Color2;Color 2;1;0;Create;True;0,0,1,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;1;-1408,-480;Float;False;Constant;_Color0;Color 0;1;0;Create;True;1,0,0,0;0,0,0,0;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;9;-768,640;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;5;-896,-256;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;4;-512,-512;Float;True;3;0;COLOR;0.0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;12;-640,256;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;11;-512,512;Float;True;3;0;COLOR;0.0;False;1;COLOR;0.0,0,0,0;False;2;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;13;-640,0;Float;False;2;0;FLOAT;0.0;False;1;FLOAT;0.0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-256,-128;Float;True;2;2;0;COLOR;0.0;False;1;FLOAT;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-256,384;Float;True;2;2;0;COLOR;0.0;False;1;FLOAT;0.0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;15;0,128;Float;True;2;2;0;COLOR;0.0;False;1;COLOR;0.0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;256,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;3ColorGradient;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;0;False;0;0;False;0;Custom;0.5;True;True;0;True;TransparentCutout;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;False;0;255;255;0;0;0;0;0;0;0;0;False;2;15;10;25;False;0.5;True;2;SrcAlpha;OneMinusSrcAlpha;0;Zero;Zero;OFF;OFF;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;0;0;False;0;0;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0.0;False;4;FLOAT;0.0;False;5;FLOAT;0.0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0.0;False;9;FLOAT;0.0;False;10;FLOAT;0.0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;8;0;6;1
WireConnection;8;1;7;0
WireConnection;10;0;7;0
WireConnection;9;0;8;0
WireConnection;9;1;10;0
WireConnection;5;0;6;1
WireConnection;5;1;7;0
WireConnection;4;0;1;0
WireConnection;4;1;2;0
WireConnection;4;2;5;0
WireConnection;12;0;7;0
WireConnection;12;1;6;1
WireConnection;11;0;2;0
WireConnection;11;1;3;0
WireConnection;11;2;9;0
WireConnection;13;0;6;1
WireConnection;13;1;7;0
WireConnection;14;0;4;0
WireConnection;14;1;13;0
WireConnection;16;0;11;0
WireConnection;16;1;12;0
WireConnection;15;0;14;0
WireConnection;15;1;16;0
WireConnection;0;0;15;0
ASEEND*/
//CHKSM=500097273298FA33D169A7CB0D546F8D57B55DA9