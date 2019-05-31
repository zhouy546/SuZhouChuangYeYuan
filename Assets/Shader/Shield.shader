// Upgrade NOTE: upgraded instancing buffer 'MyShield' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "My/Shield"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_WaveIntensity("WaveIntensity", Float) = 0.2
		_WaveSpeed("WaveSpeed", Float) = 0.5
		_Color0("Color 0", Color) = (1,0.5122582,0,1)
		_OuterColor("OuterColor", Color) = (0.8773585,0.09518514,0.6197016,1)
		_Opacity("Opacity", Range( 0 , 1)) = 1
		_CenterColor("CenterColor", Color) = (0,0.01058197,1,0)
		_EmissionIntensity("EmissionIntensity", Float) = 2
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _TextureSample1;
		uniform float _WaveIntensity;
		uniform float4 _OuterColor;
		uniform float4 _CenterColor;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float4 _Color0;
		uniform float _EmissionIntensity;
		uniform float _Opacity;

		UNITY_INSTANCING_BUFFER_START(MyShield)
			UNITY_DEFINE_INSTANCED_PROP(float, _WaveSpeed)
#define _WaveSpeed_arr MyShield
		UNITY_INSTANCING_BUFFER_END(MyShield)

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float _WaveSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaveSpeed_arr, _WaveSpeed);
			float3 ase_vertexNormal = v.normal.xyz;
			float4 transform90 = mul(unity_WorldToObject,float4( ase_vertexNormal , 0.0 ));
			float4 break36 = transform90;
			float4 appendResult41 = (float4((0.0 + (break36.x - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) , (0.0 + (break36.y - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) , 0.0 , 0.0));
			float cos21 = cos( _WaveSpeed_Instance );
			float sin21 = sin( _WaveSpeed_Instance );
			float2 rotator21 = mul( appendResult41.xy - float2( 0,0 ) , float2x2( cos21 , -sin21 , sin21 , cos21 )) + float2( 0,0 );
			float2 panner22 = ( ( _WaveSpeed_Instance * _Time.y ) * float2( 0.1,0.1 ) + rotator21);
			float4 tex2DNode29 = tex2Dlod( _TextureSample1, float4( panner22, 0, 0.0) );
			v.vertex.xyz += ( tex2DNode29.r * _WaveIntensity * ase_vertexNormal );
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV44 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode44 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV44, 1.0 ) );
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float4 tex2DNode5 = tex2D( _TextureSample0, uv_TextureSample0 );
			float _WaveSpeed_Instance = UNITY_ACCESS_INSTANCED_PROP(_WaveSpeed_arr, _WaveSpeed);
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			float4 transform90 = mul(unity_WorldToObject,float4( ase_vertexNormal , 0.0 ));
			float4 break36 = transform90;
			float4 appendResult41 = (float4((0.0 + (break36.x - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) , (0.0 + (break36.y - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) , 0.0 , 0.0));
			float cos21 = cos( _WaveSpeed_Instance );
			float sin21 = sin( _WaveSpeed_Instance );
			float2 rotator21 = mul( appendResult41.xy - float2( 0,0 ) , float2x2( cos21 , -sin21 , sin21 , cos21 )) + float2( 0,0 );
			float2 panner22 = ( ( _WaveSpeed_Instance * _Time.y ) * float2( 0.1,0.1 ) + rotator21);
			float4 tex2DNode29 = tex2D( _TextureSample1, panner22 );
			o.Emission = ( ( ( _OuterColor * fresnelNode44 ) + ( ( _CenterColor * tex2DNode5.g ) - ( tex2DNode5.r * _CenterColor ) ) + ( _Color0 * tex2DNode5.r * tex2DNode29 ) ) * _EmissionIntensity * i.vertexColor ).rgb;
			float clampResult48 = clamp( ( ( fresnelNode44 + ( tex2DNode5.r * _Color0.r ) ) * (1.0 + (( tex2DNode29.r * 1.5 ) - 0.0) * (0.0 - 1.0) / (1.0 - 0.0)) ) , 0.0 , 1.0 );
			float clampResult72 = clamp( ( clampResult48 * _Opacity * i.vertexColor.a * _OuterColor.a ) , 0.0 , 1.0 );
			o.Alpha = clampResult72;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				surfIN.vertexColor = IN.color;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16301
70.4;77.6;1523;789;-57.59426;-174.7452;1.991092;True;True
Node;AmplifyShaderEditor.NormalVertexDataNode;35;653.2051,737.485;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldToObjectTransfNode;90;863.0213,876.1663;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;36;1119.664,737.5742;Float;False;FLOAT4;1;0;FLOAT4;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.TFHCRemapNode;37;1411.471,466.2747;Float;True;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;38;1410.031,711.0069;Float;True;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;41;1734.82,569.4184;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;25;2000.644,776.2226;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;1963.181,641.1993;Float;False;InstancedProperty;_WaveSpeed;WaveSpeed;3;0;Create;True;0;0;False;0;0.5;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;21;2171.61,361.1517;Float;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;2291.989,647.6887;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;34;2348.842,182.2249;Float;False;Constant;_Vector0;Vector 0;3;0;Create;True;0;0;False;0;0.1,0.1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;22;2552.836,336.317;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;29;2907.721,182.546;Float;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;e28dc97a9541e3642a48c0e3886688c5;cd460ee4ac5c1e746b7a734cc7cc64dd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;5;3296.46,-1705.292;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;3cc886b8119dc1049af17e8cea5602a7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;7;3189.739,-860.7186;Float;False;Property;_Color0;Color 0;4;0;Create;True;0;0;False;0;1,0.5122582,0,1;0,0.4346562,0.8867924,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;45;3138.306,-582.962;Float;False;Constant;_Float1;Float 1;4;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;44;3575.988,-753.1245;Float;True;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;3586.856,76.13667;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;3941.511,-360.2733;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;64;3714.832,-1955.183;Float;False;Property;_CenterColor;CenterColor;7;0;Create;True;0;0;False;0;0,0.01058197,1,0;0,0.6551723,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;61;3853.999,-23.4504;Float;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;47;4227.984,-374.3507;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;53;3204.003,-1353.278;Float;False;Property;_OuterColor;OuterColor;5;0;Create;True;0;0;False;0;0.8773585,0.09518514,0.6197016,1;0.5943396,0.5943396,0.5943396,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;70;4203.46,-1592.778;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;4128.409,-1963.782;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;4511.677,-363.0744;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;48;4802.147,-542.3743;Float;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;3835.444,-1386.3;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;50;4796.63,-914.3134;Float;False;Property;_Opacity;Opacity;6;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;71;4561.915,-1868.02;Float;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;4372.961,-1202.068;Float;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;51;4550.595,-926.2889;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;5152.806,-832.1938;Float;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;3498.158,713.6827;Float;False;Property;_WaveIntensity;WaveIntensity;2;0;Create;True;0;0;False;0;0.2;0.01;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;55;4909.131,-1425.887;Float;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;57;4634.952,-1057.489;Float;False;Property;_EmissionIntensity;EmissionIntensity;8;0;Create;True;0;0;False;0;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;3656.925,579.777;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;5196.231,-1161.136;Float;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;72;5493.954,-854.0641;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;59;5722.939,-1103.449;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;My/Shield;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;4;1;False;-1;1;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;90;0;35;0
WireConnection;36;0;90;0
WireConnection;37;0;36;0
WireConnection;38;0;36;1
WireConnection;41;0;37;0
WireConnection;41;1;38;0
WireConnection;21;0;41;0
WireConnection;21;2;24;0
WireConnection;23;0;24;0
WireConnection;23;1;25;0
WireConnection;22;0;21;0
WireConnection;22;2;34;0
WireConnection;22;1;23;0
WireConnection;29;1;22;0
WireConnection;44;3;45;0
WireConnection;60;0;29;1
WireConnection;46;0;5;1
WireConnection;46;1;7;1
WireConnection;61;0;60;0
WireConnection;47;0;44;0
WireConnection;47;1;46;0
WireConnection;70;0;5;1
WireConnection;70;1;64;0
WireConnection;66;0;64;0
WireConnection;66;1;5;2
WireConnection;73;0;47;0
WireConnection;73;1;61;0
WireConnection;48;0;73;0
WireConnection;54;0;53;0
WireConnection;54;1;44;0
WireConnection;71;0;66;0
WireConnection;71;1;70;0
WireConnection;52;0;7;0
WireConnection;52;1;5;1
WireConnection;52;2;29;0
WireConnection;49;0;48;0
WireConnection;49;1;50;0
WireConnection;49;2;51;4
WireConnection;49;3;53;4
WireConnection;55;0;54;0
WireConnection;55;1;71;0
WireConnection;55;2;52;0
WireConnection;43;0;29;1
WireConnection;43;1;42;0
WireConnection;43;2;35;0
WireConnection;56;0;55;0
WireConnection;56;1;57;0
WireConnection;56;2;51;0
WireConnection;72;0;49;0
WireConnection;59;2;56;0
WireConnection;59;9;72;0
WireConnection;59;11;43;0
ASEEND*/
//CHKSM=3A80B34BCADCCAA6CB4112675794010D317ADC98