﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ShaderPractice/DiffusePixelLit"
{
	Properties
	{
		_Diffuse("Diffuse", Color) = (1, 1, 1, 1)
	}
	SubShader
	{
		Pass
		{
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma enable_d3d11_debug_symbols
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"
			fixed4 _Diffuse;

			struct a2v
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};
			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
			};
			
			v2f vert(a2v v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 worldNormal = normalize(i.worldNormal); //规范化不能放在vert中因为这个normal是线性插值得到的
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(i.worldNormal, worldLight));
				fixed3 color = ambient + diffuse;
				return fixed4(color, 1.0);
			}

			ENDCG
		}
	}
	Fallback "Diffuse"
}