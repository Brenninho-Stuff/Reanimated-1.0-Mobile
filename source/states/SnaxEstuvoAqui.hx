package states;

import flixel.FlxSubState;

import flixel.effects.FlxFlicker;
import lime.app.Application;
import options.VisualsSettingsSubState;

class SnaxEstuvoAqui extends MusicBeatState
{
    public static var leftState:Bool = false;

    var warnText:FlxText;
    override function create()
    {
        super.create();

        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        add(bg);

        warnText = new FlxText(0, 0, FlxG.width,
            "Customize Your Experience!\nVisit the Visual Options menu to personalize your interface.\nPress ENTER or ESCAPE to skip this message.\n",
            32);
        warnText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER);
        warnText.screenCenter();
        add(warnText);
    }

    override function update(elapsed:Float)
    {
        if(!leftState) {
            var back:Bool = controls.BACK;
            if (controls.ACCEPT || back) {
                leftState = true;
                FlxTransitionableState.skipNextTransIn = true;
                FlxTransitionableState.skipNextTransOut = true;
                if(!back) {
                    FlxG.sound.play(Paths.sound('confirmMenu'));
                    FlxFlicker.flicker(warnText, 1, 0.1, false, true, function(flk:FlxFlicker) {
                        new FlxTimer().start(0.5, function (tmr:FlxTimer) {
                            MusicBeatState.switchState(new JeyzelEstuvoAca());
                        });
                    });
                } else {
                    FlxG.sound.play(Paths.sound('cancelMenu'));
                    FlxTween.tween(warnText, {alpha: 0}, 1, {
                        onComplete: function (twn:FlxTween) {
                            MusicBeatState.switchState(new JeyzelEstuvoAca());
                        }
                    });
                }
            }
        }
        super.update(elapsed);
    }
}