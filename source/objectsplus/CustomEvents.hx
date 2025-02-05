package objectsplus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class CustomEvents {
    /* Quick Note:
    All variables have to be "static var" at least to be read by the static function
    */

    // Cinematic Stuff
    static var initialUpperY:Float = -350; 
    static var initialLowerY:Float = 720;

    public static function onEvent(eventName:String, value1:String, value2:String) {
        switch (eventName) {
            case 'Cinematics':
                var upperBar:FlxSprite = new FlxSprite(-110, initialUpperY).makeGraphic(1500, 350, 0xFF000000);
                var lowerBar:FlxSprite = new FlxSprite(-110, initialLowerY).makeGraphic(1500, 350, 0xFF000000);
                upperBar.cameras = [PlayState.instance.camHUD];
                lowerBar.cameras = [PlayState.instance.camHUD];
                PlayState.instance.add(upperBar);
                PlayState.instance.add(lowerBar);

                var vals1:Array<String> = value1.split(",");
                var speed:Float = 0.0;
                var wait:Float = 0.0;
                if (vals1 != null) {
                    if (vals1[0] != null || vals1[0] != '') speed = Std.parseFloat(vals1[0].trim());
                    if (vals1[1] != null || vals1[1] != '') wait = Std.parseFloat(vals1[1].trim());
                }

                //var speed:Float = Std.parseFloat(value1);
                var distance:Float = Std.parseFloat(value2);
                if (distance > 200.0) distance = 200.0;

                if (speed > 0 && distance > 0) {
                    FlxTween.tween(upperBar, {y: initialUpperY + distance}, speed, {ease: FlxEase.quadOut});
                    FlxTween.tween(lowerBar, {y: initialLowerY - distance}, speed, {
                        ease: FlxEase.quadOut, 
                        onComplete: function(twn:FlxTween) {
                            new FlxTimer().start(wait, function(tmr:FlxTimer) {
                                FlxTween.tween(upperBar, {y: initialUpperY}, speed, {ease: FlxEase.quadIn});
                                FlxTween.tween(lowerBar, {y: initialLowerY}, speed, {
                                    ease: FlxEase.quadIn,
                                    onComplete: function (other:FlxTween) {
                                        upperBar.kill();
                                        upperBar.destroy();
                                        lowerBar.kill();
                                        lowerBar.destroy();
                                    }
                                });
                                FlxTween.tween(PlayState.instance.healthBar, {alpha: 1}, speed/2);
                                FlxTween.tween(PlayState.instance.iconP1, {alpha: 1}, speed/2);
                                FlxTween.tween(PlayState.instance.iconP2, {alpha: 1}, speed/2);
                            });
                        }
                    });
                    FlxTween.tween(PlayState.instance.healthBar, {alpha: 0}, speed/2);
                    FlxTween.tween(PlayState.instance.iconP1, {alpha: 0}, speed/2);
                    FlxTween.tween(PlayState.instance.iconP2, {alpha: 0}, speed/2);
                }

            case 'Camera Switch':
                var duration:Float = Std.parseFloat(value1);
                if (value2.toLowerCase() == 'on') {
                    FlxTween.tween(PlayState.instance.camHUD, {alpha: 1}, duration, {ease: FlxEase.linear});
                    FlxTween.tween(PlayState.instance.camGame, {alpha: 1}, duration, {ease: FlxEase.linear});
                } else if (value2.toLowerCase() == 'off') {
                    FlxTween.tween(PlayState.instance.camHUD, {alpha: 0}, duration, {ease: FlxEase.linear});
                    FlxTween.tween(PlayState.instance.camGame, {alpha: 0}, duration, {ease: FlxEase.linear});
                }
        }
    }
}