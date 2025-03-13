package objectsplus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import states.PlayState;

class NotesTween
{
    public static var returnStep2:Int = 1;

    public static function onCreatePost():Void
    {
        var go:Float = 0;
        if (ClientPrefs.data.downScroll) 
        {
            go = FlxG.height + 200;
        } 
        else 
        {
            go = -200; // Ajusta este valor según sea necesario
        }
        for (i in 0...4)
        {
            Reflect.setField(PlayState.instance.playerStrums.members[i], "y", go);
            Reflect.setField(PlayState.instance.opponentStrums.members[i], "y", go);
        }

        // Add a timer to delay the movement of the notes
        var timer = new FlxTimer();
        timer.start(1.0, function(timer:FlxTimer):Void {
            moveNotes();
        });
    }

    private static function moveNotes():Void
    {
        var strumLine = Reflect.field(PlayState.instance, "strumLine");
        var strumLineY:Float;
        if (ClientPrefs.data.downScroll) 
        {
            strumLineY = Reflect.field(strumLine, "y") + 570; // Adjust this value as needed
        } 
        else 
        {
            strumLineY = Reflect.field(strumLine, "y") + 60; // Adjust this value as needed
        }
        
        for (i in 0...4)
        {
            FlxTween.tween(PlayState.instance.playerStrums.members[i], {y: strumLineY}, 0.3 + (0.2 + (0.1 * i)), {ease: FlxEase.backOut}).onComplete = function(twn:FlxTween):Void {
                moveNotesAfterAppearance();
            };
            FlxTween.tween(PlayState.instance.opponentStrums.members[i], {y: strumLineY}, 0.3 + (0.2 + (0.1 * i)), {ease: FlxEase.backOut}).onComplete = function(twn:FlxTween):Void {
                moveNotesAfterAppearance();
            };
        }
    }

    private static function moveNotesAfterAppearance():Void
    {
        var strumLine = Reflect.field(PlayState.instance, "strumLine");
        var strumLineY:Float;
        if (ClientPrefs.data.downScroll) 
        {
            strumLineY = Reflect.field(strumLine, "y") + 570; // Adjust this value as needed
        } 
        else 
        {
            strumLineY = Reflect.field(strumLine, "y") + 60; // Adjust this value as needed
        }
        
        for (i in 0...4)
        {
            FlxTween.tween(PlayState.instance.playerStrums.members[i], {y: strumLineY}, 0.3, {ease: FlxEase.backOut});
            FlxTween.tween(PlayState.instance.opponentStrums.members[i], {y: strumLineY}, 0.3, {ease: FlxEase.backOut});
        }
    }

    public static function onUpdatePost(elapsed:Float):Void
    {
        if (Reflect.field(PlayState.instance, "curStep") == returnStep2)
        {
            moveNotes();
        }
    }
}