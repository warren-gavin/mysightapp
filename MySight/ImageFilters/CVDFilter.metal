//
//  CVDFilter.metal
//  MySight
//
//  Created by Warren Gavin on 08/11/2021.
//

#include <metal_stdlib>
using namespace metal;

/// Color vision deficiency (CVD), or color blindness, simulating filter based on the papers
///
///     Brettel, H., Viénot, F., & Mollon, J. D. (1997). Computerized simulation of color appearance for dichromats. Journal of the
///     Optical Society of America. A, Optics, Image Science, and Vision, 14(10), 2647–2655.
///     https://doi.org/10.1364/josaa.14.002647
///
///     Viénot, F., Brettel, H., & Mollon, J. D. (1999). Digital video colourmaps for checking the legibility of displays by dichromats.
///     Color Research & Application, 24(4), 243–252
///
/// A comprehensive explanation of the filters is given in https://daltonlens.org/understanding-cvd-simulation/
///
/// The Brettel (1997) implementation is used to simulate tritan CVD, while Viénot (1999) is used to simulate both deutan and
/// protan CVD.

enum CVD {
    deutan,
    protan,
    tritan
};

// Common methods for handling the non-linear sRGB color space
float srgb_to_rgb(float v) {
    if (v <= 0.04045f)
        return 0.0773993808f * v;

    return pow((v + 0.055f) * 0.9478672986f, 2.4f);
}

float rgb_to_srgb(float v) {
    if (v <= 0.0f)
        return 0.0f;

    if (v >= 1.0f)
        return 1.0f;

    if (v <= 0.0031308f)
        return 12.92f * v;

    return (pow(v, 0.4166666667f) * 1.055f) - 0.055f;
}

// Brettel 1997 simulation
// -----------------------
half4 brettel_1997_color_transform(float severity, half4 color) {
    const float3x3 rgb_to_lms(0.17886, 0.43997, 0.03597,
                              0.03380, 0.27515, 0.03621,
                              0.00031, 0.00192, 0.01528);

    const float3x3 lms_to_rgb(8.00533, -12.88195, 11.68065,
                              -0.97821, 5.26945, -10.18300,
                              -0.04017, -0.39885, 66.48079);

    const float3 tritan_projection_plane1(-0.00213, 0.05477, 0.00000);
    const float3 tritan_projection_plane2(-0.06195, 0.16826, 0.00000);
    const float3 tritan_separation_plane_normal(0.34516, -0.65480, 0.00000);

    const float3 rgb(srgb_to_rgb(color.r),
                     srgb_to_rgb(color.g),
                     srgb_to_rgb(color.b));

    float3 lms = rgb * rgb_to_lms;

    const float dot_product = dot(lms, tritan_separation_plane_normal);
    const float3 projection_plane = (dot_product >= 0 ? tritan_projection_plane1 : tritan_projection_plane2);
    const float projected_element = dot(projection_plane, lms);

    lms[tritan] = (severity * projected_element) + ((1.0f - severity) * lms[tritan]);

    const float3 rgb_cvd =  lms * lms_to_rgb;

    return half4(rgb_to_srgb(rgb_cvd.r),
                 rgb_to_srgb(rgb_cvd.g),
                 rgb_to_srgb(rgb_cvd.b),
                 color.a);
}

// Viénot 1999 simulation
// ----------------------
half4 vienot_1999_color_transform(CVD cvd, float severity, half4 color) {
    const float3x3 vienot_deutan_rgb_transform(0.29031, 0.70969, -0.00000,
                                               0.29031, 0.70969, -0.00000,
                                               -0.02197, 0.02197, 1.00000);

    const float3x3 vienot_protan_rgb_transform(0.10889, 0.89111, -0.00000,
                                               0.10889, 0.89111, 0.00000,
                                               0.00447, -0.00447, 1.00000);

    const float3 rgb(srgb_to_rgb(color.r),
                     srgb_to_rgb(color.g),
                     srgb_to_rgb(color.b));

    const float3x3 rgb_transform = (cvd == deutan ? vienot_deutan_rgb_transform
                                                  : vienot_protan_rgb_transform);

    float3 rgb_cvd = rgb * rgb_transform;

    if (severity < 0.999f) {
        rgb_cvd = (severity * rgb_cvd) + ((1.0f - severity) * rgb);
    }

    return half4(rgb_to_srgb(rgb_cvd.r),
                 rgb_to_srgb(rgb_cvd.g),
                 rgb_to_srgb(rgb_cvd.b),
                 color.a);
}

kernel void cvdKernel(texture2d<half, access::write> outputTexture [[texture(0)]],
                      texture2d<half, access::read> inputTexture [[texture(1)]],
                      constant unsigned char &inputCVD [[buffer(0)]],
                      constant float &severity [[buffer(1)]],
                      uint2 gid [[thread_position_in_grid]]) {

    if (gid.x >= outputTexture.get_width() || gid.y >= outputTexture.get_height()) {
        return;
    }

    const half4 inColor = inputTexture.read(gid);
    const CVD cvd = (CVD)inputCVD;

    switch (cvd) {
        case deutan:
        case protan:
            outputTexture.write(vienot_1999_color_transform(cvd, severity, inColor), gid);
            break;

        case tritan:
            outputTexture.write(brettel_1997_color_transform(severity, inColor), gid);
            break;

        default:
            assert(false);
    }
}
