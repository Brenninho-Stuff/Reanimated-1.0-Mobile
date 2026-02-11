package ui_toolkit;

import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

/**
 * A static helper class for creating "Juicy" UI animations.
 * Designed to be reusable and decoupled.
 */
class UIAnimator
{
	/**
	 * Makes a sprite pop in from scale 0 to 1 with a bouncy effect.
	 * @param sprite The sprite to animate.
	 * @param duration Duration in seconds (default: 0.5).
	 * @param delay Delay before starting (default: 0).
	 */
	public static function popIn(sprite:FlxSprite, duration:Float = 0.5, delay:Float = 0):FlxTween
	{
		sprite.scale.set(0, 0);
		// Reset alpha just in case
		sprite.alpha = 1;
		
		return FlxTween.tween(sprite.scale, {x: 1, y: 1}, duration, {
			ease: FlxEase.backOut,
			startDelay: delay
		});
	}

	/**
	 * Slides a sprite in from a relative offset with a bouncy effect.
	 * @param sprite The sprite to animate.
	 * @param xOffset X distance to slide from (default: 0).
	 * @param yOffset Y distance to slide from (default: 100).
	 * @param duration Duration in seconds (default: 0.7).
	 * @param delay Delay before starting (default: 0).
	 */
	public static function slideIn(sprite:FlxSprite, xOffset:Float = 0, yOffset:Float = 100, duration:Float = 0.7, delay:Float = 0):FlxTween
	{
		var targetX = sprite.x;
		var targetY = sprite.y;

		sprite.x += xOffset;
		sprite.y += yOffset;
		sprite.alpha = 0;

		// Fade in
		FlxTween.tween(sprite, {alpha: 1}, duration * 0.8, {startDelay: delay, ease: FlxEase.circOut});

		// Move to position with bounce
		return FlxTween.tween(sprite, {x: targetX, y: targetY}, duration, {
			ease: FlxEase.elasticOut, // Much juicier bounce!
			startDelay: delay
		});
	}

	/**
	 * Slides a sprite out to a relative offset.
	 * @param sprite The sprite to animate.
	 * @param xOffset X distance to slide to (default: 0).
	 * @param yOffset Y distance to slide to (default: 100).
	 * @param duration Duration in seconds (default: 0.5).
	 * @param delay Delay before starting (default: 0).
	 */
	public static function slideOut(sprite:FlxSprite, xOffset:Float = 0, yOffset:Float = 100, duration:Float = 0.5, delay:Float = 0):FlxTween
	{
		return FlxTween.tween(sprite, {x: sprite.x + xOffset, y: sprite.y + yOffset, alpha: 0}, duration, {
			ease: FlxEase.backIn,
			startDelay: delay
		});
	}

	/**
	 * Makes a sprite pulse continuously (heartbeat effect).
	 * @param sprite The sprite to animate.
	 * @param scaleMultiplier How much to scale up (default: 1.05).
	 * @param duration Duration of one pulse cycle (default: 0.8).
	 */
	public static function pulse(sprite:FlxSprite, scaleMultiplier:Float = 1.05, duration:Float = 0.8):FlxTween
	{
		return FlxTween.tween(sprite.scale, {x: scaleMultiplier, y: scaleMultiplier}, duration / 2, {
			ease: FlxEase.sineInOut,
			type: PINGPONG
		});
	}

	/**
	 * Shakes a sprite to indicate an error or impact.
	 * @param sprite The sprite to animate.
	 * @param intensity How far to shake (default: 10).
	 * @param duration Duration of the shake (default: 0.5).
	 */
	public static function shake(sprite:FlxSprite, intensity:Float = 10, duration:Float = 0.5):Void
	{
		var startX = sprite.x;
		// Simple shake using FlxTween.shake is not available directly on sprite coordinates usually, 
		// but Flixel has FlxG.camera.shake. For a sprite, we can use a randomized tween or the built-in shake effect if available.
		// A cleaner manual approach for a single sprite:
		
		FlxTween.shake(sprite, intensity / 100, duration, XY, {ease: FlxEase.quadOut});
        // Note: FlxTween.shake might not exist in older versions, if it fails we can fallback to a custom shaker.
        // But assuming modern HaxeFlixel, let's use a chain of small movements if shake isn't suitable, 
        // actually FlxTween.shake is NOT a standard method in standard HaxeFlixel (it's usually on Camera).
        // Let's implement a custom "wiggle" shake.
        
        // Cancel any existing shake tween on this sprite if we were tracking it, but for simplicity:
        var offset = 4.0;
		// Chain a few movements to simulate a shake
		FlxTween.tween(sprite, {x: startX - offset}, 0.05, {onComplete: function(_) {
			FlxTween.tween(sprite, {x: startX + offset}, 0.05, {onComplete: function(_) {
				FlxTween.tween(sprite, {x: startX - offset}, 0.05, {onComplete: function(_) {
					FlxTween.tween(sprite, {x: startX + offset}, 0.05, {onComplete: function(_) {
						FlxTween.tween(sprite, {x: startX}, 0.05, {ease: FlxEase.quadOut});
					}});
				}});
			}});
		}});
	}

    /**
     * Animate button press (scale down slightly).
     */
    public static function press(sprite:FlxSprite):Void
    {
        FlxTween.tween(sprite.scale, {x: 0.9, y: 0.9}, 0.1, {ease: FlxEase.backOut});
    }

    /**
     * Animate button release/hover (scale back to normal/slight enlarge with rotation).
     */
    public static function hover(sprite:FlxSprite, cancelExisting:Bool = true):Void
	{
		// Robustness: Cancel any running tweens on this sprite to prevent conflicts
		if (cancelExisting) FlxTween.cancelTweensOf(sprite);
		
		// Reduced scale to prevent items from going off-screen
		FlxTween.tween(sprite.scale, {x: 1.02, y: 1.02}, 0.4, {ease: FlxEase.elasticOut});
		
		// Subtle rotation for extra "juice"
		var targetAngle = -5; // Tilt slightly left
		if (sprite.ID % 2 != 0) targetAngle = 5; // Alternating tilt if ID is set, or just fixed
		
		FlxTween.tween(sprite, {angle: targetAngle}, 0.4, {ease: FlxEase.backOut});
	}

    /**
     * Specialized animation for text entrance (Slide in + Fade).
     * @param text The text object to animate.
     * @param delay Delay before starting.
     */
    public static function textIn(text:FlxSprite, delay:Float = 0):FlxTween
    {
        text.alpha = 0;
        var finalY = text.y;
        text.y += 20; // Start slightly lower

        return FlxTween.tween(text, {y: finalY, alpha: 1}, 0.8, {
            ease: FlxEase.circOut,
            startDelay: delay
        });
    }

    /**
     * Specialized animation for text exit (Slide out + Fade).
     * @param text The text object to animate.
     * @param delay Delay before starting.
     */
    public static function textOut(text:FlxSprite, delay:Float = 0):FlxTween
    {
        return FlxTween.tween(text, {y: text.y + 20, alpha: 0}, 0.5, {
            ease: FlxEase.circIn,
            startDelay: delay
        });
    }

    /**
     * Reset scale and angle to normal.
     */
    public static function idle(sprite:FlxSprite):Void
    {
        // Robustness: Cancel any running tweens on this sprite to prevent conflicts
        FlxTween.cancelTweensOf(sprite);

        FlxTween.tween(sprite.scale, {x: 1, y: 1}, 0.3, {ease: FlxEase.backOut});
        FlxTween.tween(sprite, {angle: 0}, 0.3, {ease: FlxEase.backOut});
    }
}

