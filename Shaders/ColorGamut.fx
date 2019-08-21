/**
 * Color Gamut version 0.1
 * by Pawel Kaluszynski
 *
 * ColorGamut transforms colors using correction matrix
 */

//Acer Predator XB271HK
//0,977227226838806,-0,0568506896740596,0,0249243823632514,0,
//0,00880163298016617,1,03968308989966,-0,0422618444396196,0,
//0,00934490194998139,0,0100721357315602,1,05924393718697,0,


#include "ReShadeUI.fxh"

uniform float Red_Red < __UNIFORM_SLIDER_FLOAT1
	ui_min = -0.5; ui_max = 1.5;
> = 0.977227226838806;

uniform float Red_Green < __UNIFORM_SLIDER_FLOAT1
	ui_min = -0.5; ui_max = 1.5;
> = -0.0568506896740596;

uniform float Red_Blue < __UNIFORM_SLIDER_FLOAT1
	ui_min = -0.5; ui_max = 1.5;
> = 0.0249243823632514;

uniform float Green_Red < __UNIFORM_SLIDER_FLOAT1
	ui_min = -0.5; ui_max = 1.5;
> = 0.00880163298016617;

uniform float Green_Green < __UNIFORM_SLIDER_FLOAT1
	ui_min = -0.5; ui_max = 1.5;
> = 1.03968308989966;

uniform float Green_Blue < __UNIFORM_SLIDER_FLOAT1
	ui_min = -0.5; ui_max = 1.5;
> = -0.0422618444396196;

uniform float Blue_Red < __UNIFORM_SLIDER_FLOAT1
	ui_min = -0.5; ui_max = 1.5;
> = 0.00934490194998139;

uniform float Blue_Green < __UNIFORM_SLIDER_FLOAT1
	ui_min = -0.5; ui_max = 1.5;
> = 0.0100721357315602;

uniform float Blue_Blue < __UNIFORM_SLIDER_FLOAT1
	ui_min = -0.5; ui_max = 1.5;
> = 1.05924393718697;

uniform float Gamma_Source < __UNIFORM_SLIDER_FLOAT1
	ui_min = 1.0; ui_max = 3.0;
> = 2.2;

uniform float Gamma_Display < __UNIFORM_SLIDER_FLOAT1
	ui_min = 1.0; ui_max = 3.0;
> = 2.2;

#include "ReShade.fxh"

float3 GamutCorrection(float4 position : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
    const float3x3 corr = float3x3(
        Red_Red,	Red_Green,	Red_Blue,
        Green_Red,	Green_Green,	Green_Blue,
        Blue_Red,	Blue_Green,	Blue_Blue);    

    float3 color = tex2D(ReShade::BackBuffer, texcoord).rgb;
    color = pow(color, Gamma_Source);
    color = mul(corr, color);
    color = pow(color, 1.0/Gamma_Display);
    color = saturate(color);
    return color;
}

technique ColorGamut
{
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = GamutCorrection;
	}
}
