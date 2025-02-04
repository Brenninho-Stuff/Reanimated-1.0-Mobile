package objectsplus;

import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class CameraSwitchEvent
{
    public static function onEvent(value1:String, value2:String)
    {
        var duration:Float = Std.parseFloat(value1);
        
        if (value2.toLowerCase() == 'on')
        {
            FlxTween.tween(PlayState.instance.camHUD, {alpha: 1}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.instance.camGame, {alpha: 1}, duration, {ease: FlxEase.linear});
        }
        else if (value2.toLowerCase() == 'off')
        {
            FlxTween.tween(PlayState.instance.camHUD, {alpha: 0}, duration, {ease: FlxEase.linear});
            FlxTween.tween(PlayState.instance.camGame, {alpha: 0}, duration, {ease: FlxEase.linear});
        }
    }
}
