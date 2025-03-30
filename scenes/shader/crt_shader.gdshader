shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;

uniform vec2 resolution = vec2(320.0, 180.0);

// SCANLINES
uniform bool enable_scanlines = true;
uniform float scan_line_amount : hint_range(0.0, 1.0) = 1.0;
uniform float scan_line_strength : hint_range(-12.0, -1.0) = -8.0;

// WARP (Distorsión de pantalla)
uniform bool enable_warp = true;
uniform float warp_amount : hint_range(0.0, 5.0) = 0.1;

// NOISE (Ruido aleatorio)
uniform bool enable_noise = true;
uniform float noise_amount : hint_range(0.0, 0.3) = 0.03;

// INTERFERENCE (Interferencias tipo CRT)
uniform bool enable_interference = true;
uniform float interference_amount : hint_range(0.0, 1.0) = 0.2;

// GRILLE (Patrón de cuadrícula de pantalla)
uniform bool enable_grille = true;
uniform float grille_amount : hint_range(0.0, 1.0) = 0.1;
uniform float grille_size : hint_range(1.0, 5.0) = 1.0;

// VIGNETTE (Oscurecimiento en los bordes)
uniform bool enable_vignette = true;
uniform float vignette_amount : hint_range(0.0, 2.0) = 0.6;
uniform float vignette_intensity : hint_range(0.0, 1.0) = 0.4;

// CHROMATIC ABERRATION (Separación de colores RGB)
uniform bool enable_aberration = true;
uniform float aberration_amount : hint_range(0.0, 1.0) = 0.5;

// ROLLING LINES (Líneas en movimiento tipo CRT)
uniform bool enable_roll_lines = true;
uniform float roll_line_amount : hint_range(0.0, 1.0) = 0.3;
uniform float roll_speed : hint_range(-8.0, 8.0) = 1.0;

// PIXELATION (Filtro de pixelado)
uniform bool enable_pixelation = true;
uniform float pixel_strength : hint_range(-4.0, 0.0) = -2.0;

float random(vec2 uv) {
    return fract(cos(uv.x * 83.4827 + uv.y * 92.2842) * 43758.5453123);
}

vec2 warp(vec2 uv) {
    if (!enable_warp) return uv;
    vec2 delta = uv - 0.5;
    float delta2 = dot(delta.xy, delta.xy);
    float delta4 = delta2 * delta2;
    float delta_offset = delta4 * warp_amount;
    return (uv + delta * delta_offset - 0.5) / mix(1.0,1.2,warp_amount/5.0) + 0.5;
}

float vignette(vec2 uv) {
    if (!enable_vignette) return 1.0;
    uv *= 1.0 - uv.xy;
    float v = uv.x * uv.y * 15.0;
    return pow(v, vignette_intensity * vignette_amount);
}

vec3 fetch_pixel(vec2 uv) {
    vec2 pos = floor(uv * resolution) / resolution + vec2(0.5) / resolution;
    float noise = (enable_noise) ? random(pos + fract(TIME)) * noise_amount : 0.0;
    return texture(SCREEN_TEXTURE, pos, -16.0).rgb + noise;
}

void fragment() {
    vec2 pix = FRAGCOORD.xy;
    vec2 pos = warp(SCREEN_UV);

    // Rolling Line Effect
    float line = (enable_roll_lines) ? cos(pos.y * 3.0 - TIME * roll_speed) * roll_line_amount : 0.0;

    // Interference Effect
    if (enable_interference || enable_roll_lines) {
        float interference = random(pos.yy + fract(TIME));
        pos.x += (interference * (interference_amount + line * 6.0)) / resolution.x;
    }

    // Fetch pixel
    vec3 clr = fetch_pixel(pos);

    // Chromatic Aberration Effect
    if (enable_aberration) {
        float chromatic = aberration_amount + line * 2.0;
        vec2 chromatic_x = vec2(chromatic, 0.0) / resolution.x;
        vec2 chromatic_y = vec2(0.0, chromatic / 2.0) / resolution.y;
        clr = vec3(fetch_pixel(pos - chromatic_x).r, fetch_pixel(pos + chromatic_y).g, fetch_pixel(pos + chromatic_x).b);
    }

    // Grille Effect
    if (enable_grille) {
        clr *= mix(vec3(1.0), vec3(0.7, 0.8, 1.0), grille_amount);
    }

    // Scanlines Effect
    if (enable_scanlines) {
        clr *= 1.0 + scan_line_amount * 0.6 + line * 3.0;
    }

    // Vignette Effect
    clr *= vignette(pos);
    
    COLOR.rgb = clr;
    COLOR.a = 1.0;
}
