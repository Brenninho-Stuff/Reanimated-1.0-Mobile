package objectsplus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import objects.Character;
import lawsthings.objects.IconsAnimator;

class CustomEvents {
    /* Quick Note:
    All variables have to be "static var" at least to be read by the static function
    */

    // Cinematic Stuff
    static var initialUpperY:Float = -350; 
    static var initialLowerY:Float = 720;

    static var gameTween:FlxTween;
    static var hudTween:FlxTween;
    static var blackcamTween:FlxTween;

    // Cinematics-A bars
    static var upperBar:FlxSprite;
    static var lowerBar:FlxSprite;
    static var upperInitY:Float = -690;
    static var lowerInitY:Float = 1060;

    public static function onEvent(eventName:String, value1:String, value2:String) {
        switch (eventName) {
            case 'Cinematic Bars' | 'Cinematics':
                var upperBar:FlxSprite = new FlxSprite(-110, initialUpperY).makeGraphic(1500, 350, 0xFF000000);
                var lowerBar:FlxSprite = new FlxSprite(-110, initialLowerY).makeGraphic(1500, 350, 0xFF000000);
                upperBar.cameras = [PlayState.instance.camBlack];
                lowerBar.cameras = [PlayState.instance.camBlack];
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

                case 'Cinematics-A' | 'Cinematics-Angle':
                    var cmd:String = (value1 != null) ? value1.toLowerCase() : 'on';
                    var duration:Float = (value2 != null && value2 != '') ? Std.parseFloat(value2) : 0.6;

                    // Create persistent bars on 'on'
                    if (cmd == 'on') {
                        // Always destroy previous bars to ensure clean state on song reload
                        if (upperBar != null) {
                            upperBar.kill();
                            upperBar.destroy();
                            upperBar = null;
                        }
                        if (lowerBar != null) {
                            lowerBar.kill();
                            lowerBar.destroy();
                            lowerBar = null;
                        }

                        upperBar = new FlxSprite(-210, upperInitY).makeGraphic(1500, 350, 0xFF000000);
                        lowerBar = new FlxSprite(-10, lowerInitY).makeGraphic(1500, 350, 0xFF000000);
                        upperBar.cameras = [PlayState.instance.camBlack];
                        lowerBar.cameras = [PlayState.instance.camBlack];
                        upperBar.angle = -5;
                        lowerBar.angle = -5;
                        PlayState.instance.add(upperBar);
                        PlayState.instance.add(lowerBar);

                        FlxTween.tween(upperBar, { y: -275 }, duration, { ease: FlxEase.quadOut });
                        FlxTween.tween(lowerBar, { y: 645 }, duration, { ease: FlxEase.quadOut });

                    // Quick beat pop
                    } else if (cmd == 'beat') {
                        if (upperBar != null && lowerBar != null) {
                            upperBar.y = -255;
                            lowerBar.y = 625;
                            FlxTween.tween(upperBar, { y: -275 }, 0.2, { ease: FlxEase.quadOut });
                            FlxTween.tween(lowerBar, { y: 645 }, 0.2, { ease: FlxEase.quadOut });
                        }

                    // Remove and destroy on 'off'
                    } else if (cmd == 'off') {
                        if (upperBar != null) {
                            FlxTween.tween(upperBar, { y: upperInitY }, duration, { ease: FlxEase.quadIn,
                                onComplete: function(twn:FlxTween) {
                                    upperBar.kill();
                                    upperBar.destroy();
                                    upperBar = null;
                                }
                            });
                        }
                        if (lowerBar != null) {
                            FlxTween.tween(lowerBar, { y: lowerInitY }, duration, { ease: FlxEase.quadIn,
                                onComplete: function(twn:FlxTween) {
                                    lowerBar.kill();
                                    lowerBar.destroy();
                                    lowerBar = null;
                                }
                            });
                        }
                    }

            case 'Camera Fade':
                var duration:Float = Std.parseFloat(value1);
                if (gameTween != null) gameTween.cancel();
                if (hudTween != null) hudTween.cancel();
                if (blackcamTween != null) blackcamTween.cancel();
                if (value2.toLowerCase() == 'on') {
                    hudTween = FlxTween.tween(PlayState.instance.camHUD, {alpha: 1}, duration, {ease: FlxEase.expoOut});
                    blackcamTween = FlxTween.tween(PlayState.instance.camBlack, {alpha: 1}, duration, {ease: FlxEase.expoOut});
                    gameTween = FlxTween.tween(PlayState.instance.camGame, {alpha: 1}, duration, {ease: FlxEase.expoOut});
                } else if (value2.toLowerCase() == 'off') {
                    hudTween = FlxTween.tween(PlayState.instance.camHUD, {alpha: 0}, duration, {ease: FlxEase.expoOut});
                    blackcamTween = FlxTween.tween(PlayState.instance.camBlack, {alpha: 0}, duration, {ease: FlxEase.expoOut});
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
            default: 
                trace('Event $eventName doesn\'t exist.');
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