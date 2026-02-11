package ui_toolkit;

import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;

/**
 * A reusable "Juicy" button that handles its own states and animations.
 * Usage: add(new JuicyButton(100, 100, "Play", onPlayClick));
 */
class JuicyButton extends FlxSpriteGroup
{
	public var bg:FlxSprite;
	public var label:FlxText;
	public var onClick:Void->Void;
	
	// Configuration for "Juice"
	public var hoverScale:Float = 1.05;
	public var clickScale:Float = 0.95;
	public var normalColor:FlxColor = 0xFF4A4A4A; // Dark Gray
	public var hoverColor:FlxColor = 0xFF666666;  // Lighter Gray
	public var clickColor:FlxColor = 0xFF222222;  // Darker

	private var _isHovered:Bool = false;
	private var _isPressed:Bool = false;

	/**
	 * Creates a new JuicyButton.
	 * @param x X position.
	 * @param y Y position.
	 * @param text Button label text.
	 * @param onClick Callback function when clicked.
	 * @param width Optional width (default: 200).
	 * @param height Optional height (default: 60).
	 */
	public function new(x:Float = 0, y:Float = 0, text:String, ?onClick:Void->Void, width:Int = 200, height:Int = 60)
	{
		super(x, y);
		this.onClick = onClick;

		// 1. Create Background
		bg = new FlxSprite().makeGraphic(width, height, FlxColor.WHITE);
		bg.color = normalColor;
		add(bg);

		// 2. Create Text
		label = new FlxText(0, 0, width, text, 24);
		label.setFormat(null, 24, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
		label.borderSize = 2;
		// Center vertically
		label.y = (height - label.height) / 2;
		add(label);

		// 3. Setup Origin for scaling (Center)
		// FlxSpriteGroup doesn't always handle member origins automatically when scaling the group.
		// But if we tween 'scale' of the group, it scales from the group's origin.
		// By default group origin is (0,0). We want center.
		// Note: Changing width/height of group updates origin usually, but let's be explicit if needed.
		// However, FlxSpriteGroup behavior can vary. 
		// A safe bet for a "juice" button is to animate the MEMBERS relative to center, 
		// OR ensure the group behaves.
		// Let's try animating the group. If the group is at (X,Y), its origin is usually (0,0) relative to (X,Y).
		// We want origin at (width/2, height/2).
		
		// This forces the origin to the center of the button for proper scaling
		var centerOffsetX = width / 2;
		var centerOffsetY = height / 2;
		
		// We can't easily set origin of a group to center without offsetting position logic in some Flixel versions.
		// BUT, we can just use the UIAnimator to scale `this` and rely on standard behavior.
		// To fix the "scale from top-left" issue, we usually offset the position while scaling, 
		// or use specific center-pivot logic.
		// For simplicity in this module, we will trust the user to position it, 
		// OR we can wrap the visual elements in a container that is centered.
		
		// Actually, let's just set the origin of the members? No, that breaks group logic.
		// Let's set the origin of the group.
		// width/height are calculated from members.
		
		// Important: For popIn to look good (center expand), we need center origin.
		// this.origin.set(width / 2, height / 2) should work for the group transform.
		
		// 4. Intro Animation
		// We need to wait a frame for bounds to be calculated correctly sometimes, 
		// but since we added fixed size sprites, it should be fine.
		
		// Manually setting width/height helps for group origin calculation
		// this.width = width;
		// this.height = height;
		// this.origin.set(width * 0.5, height * 0.5); 
		// (FlxSpriteGroup usually calculates this on update, let's trigger it)
		
		UIAnimator.popIn(this, 0.5, 0.2); // Small delay for effect
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		
		// Update origin to center if it reset (Flixel groups sometimes reset origin)
		// Use the center of the background as the anchor
		origin.set(bg.width / 2, bg.height / 2);

		// Mouse Interaction
		// Check overlap with the background sprite specifically for better hitboxing if group is complex,
		// but checking 'this' is usually fine.
		if (FlxG.mouse.overlaps(this))
		{
			if (!_isHovered)
			{
				_isHovered = true;
				onHover();
			}

			if (FlxG.mouse.justPressed)
			{
				_isPressed = true;
				onPress();
			}
			
			if (FlxG.mouse.justReleased)
			{
				if (_isPressed)
				{
					_isPressed = false;
					onRelease(); // Visual release
					if (onClick != null) onClick();
				}
			}
		}
		else
		{
			if (_isHovered)
			{
				_isHovered = false;
				_isPressed = false;
				onOut();
			}
		}
	}

	function onHover()
	{
		bg.color = hoverColor;
		// Pulse slightly or scale up
		UIAnimator.hover(this); 
	}

	function onOut()
	{
		bg.color = normalColor;
		UIAnimator.idle(this);
	}

	function onPress()
	{
		bg.color = clickColor;
		UIAnimator.press(this);
	}

	function onRelease()
	{
		bg.color = hoverColor;
		UIAnimator.hover(this);
	}
}
