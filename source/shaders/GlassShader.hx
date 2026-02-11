package shaders;

import flixel.system.FlxAssets.FlxShader;

class GlassShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		uniform float iTime;
		uniform float uSpeed;
		uniform float uBrightness; // Controls brightness
		uniform vec2 uResolution; // Screen resolution
		uniform vec4 uRect; // x, y, width, height of sprite
		uniform sampler2D uScreenTexture; // Background texture

		// Gaussian weights for cleaner blur
		float gaussian(vec2 i, float sigma) {
			return exp(-0.5 * dot(i /= sigma, i)) / (6.28318 * sigma * sigma);
		}

		void main() {
			vec2 sprite_uv = openfl_TextureCoordv;
			
			// Get sprite alpha first (use as mask)
			float spriteAlpha = texture2D(bitmap, sprite_uv).a;
			
			// Early exit: if sprite is transparent here, skip rendering
			if (spriteAlpha < 0.1) {
				discard;
			}
			
			// Center UVs (0.0 at center) - No distortion anymore
			vec2 uv_centered = sprite_uv - 0.5;
			
			// Calculate screen position for sampling
			// Map sprite UV (0-1) to screen coordinates based on uRect
			vec2 screen_pos = uRect.xy + sprite_uv * uRect.zw;
			vec2 screenUV = screen_pos / uResolution;
			
			vec4 color = vec4(0.0);
			float total = 0.0;
			
			// Gaussian Blur Settings
			// Radius 6 on a 1/4 size texture is like Radius 24 on full size!
			const int radius = 6; 
			const float sigma = 4.0;
			
			// Use exact pixel size to avoid artifacts/pixelation
			// Multiply by 4.0 to account for the 0.25x downscale in PauseSubState
			// This ensures we sample the correct texels of the low-res texture
			vec2 pixelSize = (1.0 / uResolution) * 4.0;
			
			// Blur Loop
			for(int x = -radius; x <= radius; x++) {
				for(int y = -radius; y <= radius; y++) {
					vec2 offset = vec2(float(x), float(y)) * pixelSize;
					float weight = gaussian(vec2(float(x), float(y)), sigma);
					
					color += texture2D(uScreenTexture, screenUV + offset) * weight;
					total += weight;
				}
			}
			color /= total;
			
			// Frosted Glass Effect
			// Mix with white to create the "frosted" look
			// Increased brightness/whiteness as requested
			vec3 finalColor = mix(color.rgb, vec3(1.0), 0.2 + uBrightness);
			
			// Slight contrast boost to make it pop
			finalColor = pow(finalColor, vec3(0.9));
			
			gl_FragColor = vec4(finalColor, spriteAlpha);
		}
	')

	public function new()
	{
		super();
		iTime.value = [0.0];
		uSpeed.value = [1.0];
		uBrightness.value = [0.25]; // Increased default brightness
		uResolution.value = [1280, 720];
		uRect.value = [0, 0, 100, 100];
	}

	public function update(time:Float):Void
	{
		iTime.value = [time];
	}
	
	public function setBrightness(value:Float):Void
	{
		uBrightness.value = [value];
	}

	public function setSpeed(value:Float):Void
	{
		uSpeed.value = [value];
	}

	public function setRect(x:Float, y:Float, w:Float, h:Float):Void
	{
		uRect.value = [x, y, w, h];
	}
	
	public function setResolution(w:Float, h:Float):Void
	{
		uResolution.value = [w, h];
	}
}
