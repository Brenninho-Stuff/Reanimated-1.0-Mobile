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

    public static function setStrumsY():Void
    {
        var go:Float = ClientPrefs.data.downScroll ? FlxG.height + 200 : -200;
        for (i in 0...4)
        {
            PlayState.instance.playerStrums.members[i].y = go;
            PlayState.instance.opponentStrums.members[i].y = go;
        }

        // Add a timer to delay the movement of the notes
        var timer = new FlxTimer();
        timer.start(1.0, function(timer:FlxTimer):Void {
            moveNotes();
        });
    }

    private static function moveNotes():Void
    {
        var strumLineY:Float = ClientPrefs.data.downScroll ? (FlxG.height - 150) : 50;
        
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
        var strumLineY:Float = ClientPrefs.data.downScroll ? (FlxG.height - 150) : 50;
        
        for (i in 0...4)
        {
            FlxTween.tween(PlayState.instance.playerStrums.members[i], {y: strumLineY}, 0.3, {ease: FlxEase.backOut});
            FlxTween.tween(PlayState.instance.opponentStrums.members[i], {y: strumLineY}, 0.3, {ease: FlxEase.backOut});
        }
    }

    public static function onUpdatePost(elapsed:Float):Void
    {
        @:privateAccess
        if (PlayState.instance.curStep == returnStep2) {moveNotes();}
    }
}