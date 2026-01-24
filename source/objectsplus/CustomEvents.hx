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

    // Color Transform state
    static var colorTransformActive:Bool = false;
    static var colorTransformChars:Array<Character> = [];
    static var colorTransformBlackScreen:FlxSprite;

    public static function onEvent(eventName:String, value1:String, value2:String) {
        switch (eventName) {
            case 'Cinematic Bars' | 'Cinematics':
                var cmd:String = (value1 != null) ? value1.toLowerCase() : 'on';
                var duration:Float = (value2 != null && value2 != '') ? Std.parseFloat(value2) : 0.6;
                var distance:Float = 100;  // distancia por defecto

                 // Parsear value2: "duration,distance"
    if (value2 != null && value2 != '') {
        var parts:Array<String> = value2.split(",");
        if (parts[0] != null) duration = Std.parseFloat(parts[0].trim());
        if (parts[1] != null) distance = Std.parseFloat(parts[1].trim());
    }
    
                // Crear barras persistentes en 'on'
                if (cmd == 'on') {
                    // Destruir barras anteriores para asegurar estado limpio al recargar la canción
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

                    upperBar = new FlxSprite(-110, initialUpperY).makeGraphic(1500, 350, 0xFF000000);
                    lowerBar = new FlxSprite(-110, initialLowerY).makeGraphic(1500, 350, 0xFF000000);
                    upperBar.cameras = [PlayState.instance.camBlack];
                    lowerBar.cameras = [PlayState.instance.camBlack];
                    PlayState.instance.add(upperBar);
                    PlayState.instance.add(lowerBar);

                    FlxTween.tween(upperBar, { y: initialUpperY + distance }, duration, { ease: FlxEase.quadOut });
                    FlxTween.tween(lowerBar, { y: initialLowerY - distance }, duration, { ease: FlxEase.quadOut });

                // Pop rápido en beat
                } else if (cmd == 'beat') {
                    if (upperBar != null && lowerBar != null) {
                        upperBar.y = initialUpperY + distance - 10;
                        lowerBar.y = initialLowerY - distance + 10;
                        FlxTween.tween(upperBar, { y: initialUpperY + distance }, 0.2, { ease: FlxEase.quadOut });
                        FlxTween.tween(lowerBar, { y: initialLowerY - distance }, 0.2, { ease: FlxEase.quadOut });
                    }

                // Remover y destruir en 'off'
                } else if (cmd == 'off') {
                    if (upperBar != null) {
                        FlxTween.tween(upperBar, { y: initialUpperY }, duration, { ease: FlxEase.quadIn,
                            onComplete: function(twn:FlxTween) {
                                upperBar.kill();
                                upperBar.destroy();
                                upperBar = null;
                            }
                        });
                    }
                    if (lowerBar != null) {
                        FlxTween.tween(lowerBar, { y: initialLowerY }, duration, { ease: FlxEase.quadIn,
                            onComplete: function(twn:FlxTween) {
                                lowerBar.kill();
                                lowerBar.destroy();
                                lowerBar = null;
                            }
                        });
                    }
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
                var cmd:String = (value1 != null) ? value1.toLowerCase() : 'on';
                var durationStr:String = (value2 != null && value2 != '') ? value2 : '0.6';
                var duration:Float = 0.6;
                var skipColorTransform:Bool = false;
                var reverseImmediate:Bool = false;
                var delay:Float = 0;

                // Parse value2 for duration and options
                if (durationStr != null && durationStr.trim() != '') {
                    var value2Parts:Array<String> = durationStr.split(",");
                    for (i in 0...value2Parts.length) {
                        var part:String = value2Parts[i].trim();
                        if (i == 0 && ~/^-?\d+(\.\d+)?$/.match(part)) {
                            duration = Std.parseFloat(part);
                        } else if (part.toLowerCase() == "nocolor") {
                            skipColorTransform = true;
                        } else if (~/^-?\d+(\.\d+)?$/.match(part)) {
                            delay = Std.parseFloat(part);
                        } else {
                            reverseImmediate = true;
                        }
                    }
                }

                if (cmd == 'on') {
                    colorTransformActive = true;
                    colorTransformChars = [PlayState.instance.boyfriend, PlayState.instance.gf, PlayState.instance.dad];
                    colorTransformBlackScreen = PlayState.instance.blackScreen;

                    FlxTween.tween(colorTransformBlackScreen, {alpha: 0.6}, duration, {ease: FlxEase.linear});

                    for (char in colorTransformChars) {
                        if (char == null || !char.visible || char.alpha <= 0) continue;

                        if (!skipColorTransform) {
                            FlxTween.cancelTweensOf(char.colorTransform);

                            var rgbColors:Array<Int> = char.healthColorArray;
                            FlxTween.tween(char.colorTransform, { 
                                redOffset: rgbColors[0], greenOffset: rgbColors[1], blueOffset: rgbColors[2], 
                                redMultiplier: 0, greenMultiplier: 0, blueMultiplier: 0 
                            }, duration, {ease: FlxEase.linear});
                        }

                        if (reverseImmediate) {
                            revertColorTransform(char, duration);
                            fadeOutBlackScreen(colorTransformBlackScreen, duration);
                        } else if (delay > 0) {
                            new FlxTimer().start(delay, function(tmr:FlxTimer) {
                                revertColorTransform(char, duration);
                                fadeOutBlackScreen(colorTransformBlackScreen, duration);
                            });
                        }
                    }

                } else if (cmd == 'off') {
                    colorTransformActive = false;

                    for (char in colorTransformChars) {
                        if (char == null) continue;
                        revertColorTransform(char, duration);
                    }
                    if (colorTransformBlackScreen != null) {
                        fadeOutBlackScreen(colorTransformBlackScreen, duration);
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