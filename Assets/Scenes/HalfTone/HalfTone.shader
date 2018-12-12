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
		_Speed("Speed", Vector) = (1,1,0,0)
		_Diffuse("Diffuse", 2D) = "white" {}
		_GradientCenterPosition("Gradient Center Position", Range( 0 , 0.999)) = 0.9
		_TextureScale("TextureScale", Range( 1 , 20)) = 10
		_GradientColorA("GradientColorA", Color) = (0.4386792,1,0.4866341,0)
		_GradientColorB("GradientColorB", Color) = (0,0.1070018,1,0)
		_MaskAngle("MaskAngle", Float) = 45
		_NoiseAmount("NoiseAmount", Range( 0 , 40)) = 12
		_GradientAmount("GradientAmount", Range( 0 , 1)) = 1
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
				
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				float2 texcoord  : TEXCOORD0;
				UNITY_VERTEX_OUTPUT_STEREO
				
			};
			
			uniform fixed4 _Color;
			uniform float _EnableExternalAlpha;
			uniform sampler2D _MainTex;
			uniform sampler2D _AlphaTex;
			uniform sampler2D _Diffuse;
			uniform float2 _Speed;
			uniform float _TextureScale;
			uniform float4 _GradientColorA;
			uniform float4 _GradientColorB;
			uniform float _GradientCenterPosition;
			uniform float _GradientAmount;
			uniform float _NoiseAmount;
			uniform float _MaskAngle;
			float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }
			float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }
			float snoise( float2 v )
			{
				const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
				float2 i = floor( v + dot( v, C.yy ) );
				float2 x0 = v - i + dot( i, C.xx );
				float2 i1;
				i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
				float4 x12 = x0.xyxy + C.xxzz;
				x12.xy -= i1;
				i = mod2D289( i );
				float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
				float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
				m = m * m;
				m = m * m;
				float3 x = 2.0 * frac( p * C.www ) - 1.0;
				float3 h = abs( x ) - 0.5;
				float3 ox = floor( x + 0.5 );
				float3 a0 = x - ox;
				m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
				float3 g;
				g.x = a0.x * x0.x + h.x * x0.y;
				g.yz = a0.yz * x12.xz + h.yz * x12.yw;
				return 130.0 * dot( m, g );
			}
			
			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				
				
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
				float2 uv10 = IN.texcoord.xy * ( _ScreenParams / _TextureScale ).xy + float2( 0,0 );
				float2 panner36 = ( _Time.x * ( _Speed * -1.0 ) + uv10);
				float2 uv165 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float4 lerpResult89 = lerp( _GradientColorA , _GradientColorB , ( ( uv165.x - _GradientCenterPosition ) / ( 1.0 - _GradientCenterPosition ) ));
				float4 Gradient153 = ( lerpResult89 * _GradientAmount );
				float2 uv137 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float cos136 = cos( radians( _MaskAngle ) );
				float sin136 = sin( radians( _MaskAngle ) );
				float2 rotator136 = mul( uv137 - float2( 0.5,0.5 ) , float2x2( cos136 , -sin136 , sin136 , cos136 )) + float2( 0.5,0.5 );
				float2 temp_cast_1 = (( _NoiseAmount * rotator136.y )).xx;
				float simplePerlin2D144 = snoise( temp_cast_1 );
				float Mask134 = ( 1.0 - step( simplePerlin2D144 , 0.0 ) );
				float4 lerpResult117 = lerp( ( tex2D( _Diffuse, panner36 ) + ( Gradient153 * uv10.y ) ) , float4( 0,0,0,0 ) , Mask134);
				
				fixed4 c = lerpResult117;
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
335;111;1467;961;2378.248;-527.3512;1.49492;True;False
Node;AmplifyShaderEditor.CommentaryNode;173;-2136.158,702.1846;Float;False;2428.591;903.285;NoiseMap;13;125;137;129;124;136;147;138;146;144;114;141;134;145;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;174;-801.5555,-1548.31;Float;False;1696.201;874.1188;GradientMap;11;164;165;166;167;88;168;86;150;89;91;153;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;125;-2086.158,1312.874;Float;False;Property;_MaskAngle;MaskAngle;6;0;Create;True;0;0;False;0;45;46.3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;165;-751.5555,-1437.591;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;137;-1949.722,752.1846;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RadiansOpNode;129;-1891.89,1311.12;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;124;-1932.79,1013.964;Float;False;Constant;_Vector0;Vector 0;5;0;Create;True;0;0;False;0;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;164;-751.5555,-1181.591;Float;False;Property;_GradientCenterPosition;Gradient Center Position;2;0;Create;True;0;0;False;0;0.9;0.116;0;0.999;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;167;-490.7555,-927.1913;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;166;-394.7558,-1114.39;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;136;-1626.803,1033.835;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;88;-435.7057,-1306.331;Float;False;Property;_GradientColorB;GradientColorB;5;0;Create;True;0;0;False;0;0,0.1070018,1,0;1,0.02849725,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;147;-1075.92,837.082;Float;False;Property;_NoiseAmount;NoiseAmount;7;0;Create;True;0;0;False;0;12;10;0;40;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;168;-177.5555,-942.5913;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;138;-1308.779,1019.384;Float;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ColorNode;86;-443.9504,-1498.31;Float;False;Property;_GradientColorA;GradientColorA;4;0;Create;True;0;0;False;0;0.4386792,1,0.4866341,0;0.2439288,1,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;150;55.92796,-1083.223;Float;False;Property;_GradientAmount;GradientAmount;8;0;Create;True;0;0;False;0;1;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;89;6.688782,-1354.402;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;-769.3066,1172.361;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-1034.313,-199.9305;Float;False;Property;_TextureScale;TextureScale;3;0;Create;True;0;0;False;0;10;5;1;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenParams;78;-1039.89,-375.92;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;143;-644.3783,245.9727;Float;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;False;0;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;81;-799.39,-266.676;Float;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;37;-632.4566,-20.50172;Float;False;Property;_Speed;Speed;0;0;Create;True;0;0;True;0;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.NoiseGeneratorNode;144;-575.9352,1162.986;Float;False;Simplex2D;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;392.4833,-1128.036;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;-375.3783,-57.02728;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TimeNode;43;-658.6671,461.2249;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;114;-357.9581,1114.514;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-537.0402,-299.4441;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;153;651.6453,-1137.309;Float;False;Gradient;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;55;-545.118,-530.9846;Float;True;Property;_Diffuse;Diffuse;1;0;Create;True;0;0;False;0;fc34e15bcb9bc2f48ae4a5b1a35b5733;fc34e15bcb9bc2f48ae4a5b1a35b5733;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.GetLocalVarNode;170;4.841565,-637.4423;Float;False;153;Gradient;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;141;-135.1387,1115.256;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;36;-152.5845,-197.2655;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;134;49.43352,1114.248;Float;False;Mask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;46;101.0239,-261.4075;Float;True;Property;_Texture;Texture;3;0;Create;True;0;0;True;0;None;None;True;2;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;172;300.744,-506.3799;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;163;576.1257,-265.2081;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;135;129.2032,-6.971189;Float;False;134;Mask;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;145;-1064.352,1306.47;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;117;927.6277,-176.8962;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;157;424.6544,91.67035;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;77;1293.481,-170.875;Float;False;True;2;Float;ASEMaterialInspector;0;5;Dinwy/HalfTone;0f8ba0101102bb14ebf021ddadce9b49;0;0;SubShader 0 Pass 0;2;True;3;1;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;True;2;False;-1;False;False;True;2;False;-1;False;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;0
WireConnection;129;0;125;0
WireConnection;167;0;164;0
WireConnection;166;0;165;1
WireConnection;166;1;164;0
WireConnection;136;0;137;0
WireConnection;136;1;124;0
WireConnection;136;2;129;0
WireConnection;168;0;166;0
WireConnection;168;1;167;0
WireConnection;138;0;136;0
WireConnection;89;0;86;0
WireConnection;89;1;88;0
WireConnection;89;2;168;0
WireConnection;146;0;147;0
WireConnection;146;1;138;1
WireConnection;81;0;78;0
WireConnection;81;1;82;0
WireConnection;144;0;146;0
WireConnection;91;0;89;0
WireConnection;91;1;150;0
WireConnection;142;0;37;0
WireConnection;142;1;143;0
WireConnection;114;0;144;0
WireConnection;10;0;81;0
WireConnection;153;0;91;0
WireConnection;141;0;114;0
WireConnection;36;0;10;0
WireConnection;36;2;142;0
WireConnection;36;1;43;1
WireConnection;134;0;141;0
WireConnection;46;0;55;0
WireConnection;46;1;36;0
WireConnection;172;0;170;0
WireConnection;172;1;10;2
WireConnection;163;0;46;0
WireConnection;163;1;172;0
WireConnection;117;0;163;0
WireConnection;117;2;135;0
WireConnection;77;0;117;0
ASEEND*/
//CHKSM=67C173B1B3BB515C0711EDD3A993D59A1B5AAC53