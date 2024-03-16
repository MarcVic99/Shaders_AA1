Shader "Custom/FlowmapTemperatureShader" {
    Properties{
        _MainTex("Main Texture", 2D) = "white" {}
        _NoiseTexture("Noise Texture", 2D) = "white" {}
        _NoiseScale("Noise Scale", Float) = 1.0
        _Speed("Speed", Range(0.01, 0.4)) = 0.01
        _Temperature("Temperature", Range(0, 1)) = 0.5
    }

        SubShader{
            Tags { "RenderType" = "Opaque" }
            LOD 200

            CGPROGRAM
            #pragma surface surf Standard fullforwardshadows

            struct Input {
                float2 uv_MainTex;
                float2 uv_NoiseTexture;
            };

            sampler2D _MainTex;
            sampler2D _NoiseTexture;
            float _NoiseScale;
            float _Speed;
            float _Temperature;

            void surf(Input IN, inout SurfaceOutputStandard o) {
                // Calculate flowmap offset
                float2 flowOffset = tex2D(_NoiseTexture, IN.uv_NoiseTexture * _NoiseScale + _Time.y * _Speed).rg;

                // Apply flowmap offset to UV
                IN.uv_MainTex += flowOffset;

                // Sample the main texture
                fixed4 texColor = tex2D(_MainTex, IN.uv_MainTex);

                // Adjust the color based on temperature
                texColor.rgb *= _Temperature;

                // Output the final color
                o.Albedo = texColor.rgb;
                o.Alpha = texColor.a;
            }
            ENDCG
        }

            FallBack "Diffuse"
}
