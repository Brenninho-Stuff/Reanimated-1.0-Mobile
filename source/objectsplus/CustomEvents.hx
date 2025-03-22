package objectsplus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import objects.Character;
import objectsplus.IconsAnimator;

class CustomEvents {
    /* Quick Note:
    All variables have to be "static var" at least to be read by the static function
    */

    // Cinematic Stuff
    static var initialUpperY:Float = -350; 
    static var initialLowerY:Float = 720;

    static var gameTween:FlxTween;
    static var hudTween:FlxTween;

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
                                IconsAnimator.canResetProperties = true;
                            });
                        }
                    });
                    FlxTween.tween(PlayState.instance.healthBar, {alpha: 0}, speed/2);
                    FlxTween.tween(PlayState.instance.iconP1, {alpha: 0}, speed/2);
                    FlxTween.tween(PlayState.instance.iconP2, {alpha: 0}, speed/2);
                    IconsAnimator.canResetProperties = false;
                    
                }

            case 'Camera Fade':
                var duration:Float = Std.parseFloat(value1);
                if (gameTween != null) gameTween.cancel();
                if (hudTween != null) hudTween.cancel();
                if (value2.toLowerCase() == 'on') {
                    hudTween = FlxTween.tween(PlayState.instance.camHUD, {alpha: 1}, duration, {ease: FlxEase.expoOut});
                    gameTween = FlxTween.tween(PlayState.instance.camGame, {alpha: 1}, duration, {ease: FlxEase.expoOut});
                } else if (value2.toLowerCase() == 'off') {
                    hudTween = FlxTween.tween(PlayState.instance.camHUD, {alpha: 0}, duration, {ease: FlxEase.expoOut});
                    gameTween = FlxTween.tween(PlayState.instance.camGame, {alpha: 0}, duration, {ease: FlxEase.expoOut});
                }

            case 'Color Transform':
                var characters:Array<Character> = [PlayState.instance.boyfriend, PlayState.instance.gf, PlayState.instance.dad];
                var seconds:Float = (value1 != null && value1 != '') ? Std.parseFloat(value1) : 0;
                var delay:Float = 0;
                var reverseImmediate:Bool = false;
                var skipColorTransform:Bool = false;

                if (value2 != null && value2.trim() != '') {
                    var value2Parts:Array<String> = value2.split(",");
                    for (part in value2Parts) {
                        part = part.trim();
                        if (~/^-?\d+(\.\d+)?$/.match(part)) {
                            delay = Std.parseFloat(part);
                        } else if (part.toLowerCase() == "nocolor") {
                            skipColorTransform = true;
                        } else {
                            reverseImmediate = true;
                        }
                    }
                }

                var blackScreen:FlxSprite = PlayState.instance.blackScreen;
                FlxTween.tween(blackScreen, {alpha: 0.6}, seconds, {ease: FlxEase.linear});

                for (char in characters) {
                    if (char == null || !char.visible || char.alpha <= 0) continue;

                    if (!skipColorTransform) {
                        FlxTween.cancelTweensOf(char.colorTransform);

                        var rgbColors:Array<Int> = char.healthColorArray;
                        FlxTween.tween(char.colorTransform, { 
                            redOffset: rgbColors[0], greenOffset: rgbColors[1], blueOffset: rgbColors[2], 
                            redMultiplier: 0, greenMultiplier: 0, blueMultiplier: 0 
                        }, seconds, {ease: FlxEase.linear});
                    }

                    if (reverseImmediate) {
                        revertColorTransform(char, seconds);
                        fadeOutBlackScreen(blackScreen, seconds);
                    } else if (delay > 0) {
                        new FlxTimer().start(delay, function(tmr:FlxTimer) {
                            revertColorTransform(char, seconds);
                            fadeOutBlackScreen(blackScreen, seconds);
                        });
                    }
                }

        }
    
    }
    
    static function revertColorTransform(char:Character, seconds:Float) {
        FlxTween.tween(char.colorTransform, { 
            redOffset: 0, greenOffset: 0, blueOffset: 0, 
            redMultiplier: 1.0, greenMultiplier: 1.0, blueMultiplier: 1.0 
        }, seconds, {ease: FlxEase.linear});
    }

    static function fadeOutBlackScreen(blackScreen:FlxSprite, seconds:Float) {
        FlxTween.tween(blackScreen, {alpha: 0}, seconds, {ease: FlxEase.linear});
    }
    
}