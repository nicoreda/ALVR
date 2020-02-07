//https://github.com/zachsaw/RenderScripts/blob/master/RenderScripts/ImageProcessingShaders/MPC-HC/Sharpen.hlsl
cbuffer ColorCorrectionParams {
	float brightness;
	float contrast;
	float saturation;
	float gamma;

};

Texture2D<float4> sourceTexture;

SamplerState bilinearSampler {
	Filter = MIN_MAG_LINEAR_MIP_POINT;
	AddressU = CLAMP;
	AddressV = CLAMP;
};

sampler s0 : register(s0);


// https://forum.unity.com/threads/hue-saturation-brightness-contrast-shader.260649/
float4 main(float2 uv : TEXCOORD0) : SV_Target{

	float val1 = -0.125f;
	float3 pixel = sourceTexture.Sample(bilinearSampler, uv);

	float dx = saturation / 2880;
	float dy = saturation / 1600;
	float4 p1 = sourceTexture.Sample(bilinearSampler, uv + float2(-dx, -dy)) * val1;
	float4 p2 = sourceTexture.Sample(bilinearSampler, uv + float2(0, -dy)) * val1;
	float4 p3 = sourceTexture.Sample(bilinearSampler, uv + float2(-dx, 0)) * val1;
	float4 p4 = sourceTexture.Sample(bilinearSampler, uv + float2(dx, 0)) * val1;
	float4 p5 = sourceTexture.Sample(bilinearSampler, uv + float2(0, dy)) * val1;
	float4 p6 = sourceTexture.Sample(bilinearSampler, uv + float2(dx, dy)) * val1;
	float4 p7 = sourceTexture.Sample(bilinearSampler, uv + float2(-dx, +dy)) * val1;
	float4 p8 = sourceTexture.Sample(bilinearSampler, uv + float2(+dx, -dy)) * val1;
	float4 p9 = sourceTexture.Sample(bilinearSampler, uv)* 2.0f;
	pixel = (p1 + p2 + p3 + p4 + p5 + p6 + p7 + p8 + p9);

	pixel = pow(pixel, 1. / gamma);                                            // gamma
	pixel += brightness;                               // brightness
	pixel = (pixel - 0.5) * contrast + 0.5f;                                   // contast

	return float4(pixel, 1);
}
