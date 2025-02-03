package objectsplus;

import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Cinematics extends FlxBasic
{
    var upperBar:FlxSprite;
    var lowerBar:FlxSprite;
    var initialUpperY:Float = -350;  // Define initial positions as constants
    var initialLowerY:Float = 720;

    public function new()
    {
        super();
        // Create upper bar
        upperBar = new FlxSprite(-110, initialUpperY).makeGraphic(1500, 350, 0xFF000000);
        upperBar.cameras = [PlayState.instance.camHUD];
        PlayState.instance.add(upperBar);

        // Create lower bar
        lowerBar = new FlxSprite(-110, initialLowerY).makeGraphic(1500, 350, 0xFF000000);
        lowerBar.cameras = [PlayState.instance.camHUD];
        PlayState.instance.add(lowerBar);
    }

    public function onEvent(eventName:String, value1:String, value2:String)
    {
        if (eventName == 'Cinematics')
        {
            var speed:Float = Std.parseFloat(value1);
            var distance:Float = Std.parseFloat(value2);

            if (speed > 0 && distance > 0)
            {
                // Entrance animation
                FlxTween.tween(upperBar, {y: initialUpperY + distance}, speed, {ease: FlxEase.quadOut});
                FlxTween.tween(lowerBar, {y: initialLowerY - distance}, speed, {
                    ease: FlxEase.quadOut, 
                    onComplete: function(twn:FlxTween){
                        FlxTween.tween(upperBar, {y: initialUpperY}, speed, {ease: FlxEase.quadIn});
                        FlxTween.tween(lowerBar, {y: initialLowerY}, speed, {ease: FlxEase.quadIn});
                        FlxTween.tween(PlayState.instance.healthBar, {alpha: 1}, speed/2);
                        FlxTween.tween(PlayState.instance.iconP1, {alpha: 1}, speed/2);
                        FlxTween.tween(PlayState.instance.iconP2, {alpha: 1}, speed/2);
                    }
                });
                FlxTween.tween(PlayState.instance.healthBar, {alpha: 0}, speed/2);
                FlxTween.tween(PlayState.instance.iconP1, {alpha: 0}, speed/2);
                FlxTween.tween(PlayState.instance.iconP2, {alpha: 0}, speed/2);
            }
        }
    }
}
