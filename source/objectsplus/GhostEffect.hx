package objectsplus;

import flixel.FlxSprite;
import objects.Note;

class GhostEffect extends FlxSprite
{
    private static var boyfriendGhostData:GhostData = new GhostData();
    private static var dadGhostData:GhostData = new GhostData();
    
    public static function onBoyfiendNoteHit(note:Note):Void 
    {
        if (boyfriendGhostData.strumTime == note.strumTime && !note.isSustainNote)
        {
            createGhost('boyfriend');
        }
        
        if (!note.isSustainNote)
        {
            boyfriendGhostData.strumTime = note.strumTime;
            updateGhostData('boyfriend');
        }
    }

    public static function onDadNoteHit(note:Note):Void
    {
        if (dadGhostData.strumTime == note.strumTime && !note.isSustainNote)
        {
            createGhost('dad');
        }
        
        if (!note.isSustainNote)
        {
            dadGhostData.strumTime = note.strumTime;
            updateGhostData('dad');
        }
    }

    private static function createGhost(char:String):Void
        {
            var character = (char == 'boyfriend') ? PlayState.instance.boyfriend : PlayState.instance.dad;
            var ghostSprite = new FlxSprite(character.x, character.y);
            
            ghostSprite.frames = character.frames;
            ghostSprite.scale.set(character.scale.x, character.scale.y);
            ghostSprite.flipX = character.flipX;
            ghostSprite.alpha = 1;
            
            var ghostData = (char == 'boyfriend') ? boyfriendGhostData : dadGhostData;
            ghostSprite.animation.frameName = ghostData.frameName;
            ghostSprite.offset.set(ghostData.offsetX, ghostData.offsetY);
            
            // Add to specific layer
            if (char == 'boyfriend') {
                PlayState.instance.addBehindBF(ghostSprite);
            } else {
                PlayState.instance.addBehindDad(ghostSprite);
            }
            
            FlxTween.tween(ghostSprite, {alpha: 0}, 0.4, {
                onComplete: function(twn:FlxTween) {
                    ghostSprite.destroy();
                }
            });
        }

    private static function updateGhostData(char:String):Void
    {
        var character = (char == 'boyfriend') ? PlayState.instance.boyfriend : PlayState.instance.dad;
        var ghostData = (char == 'boyfriend') ? boyfriendGhostData : dadGhostData;
        
        if(!character.isAnimateAtlas)
        {
            ghostData.frameName = character.animation.frameName;
        }
        else
        {
            character.atlas.anim.curFrame;
        }
        ghostData.offsetX = character.offset.x;
        ghostData.offsetY = character.offset.y;
    }
}

class GhostData
{
    public var strumTime:Float;
    public var frameName:String;
    public var offsetX:Float;
    public var offsetY:Float;

    public function new()
    {
        strumTime = 0;
        frameName = '';
        offsetX = 0;
        offsetY = 0;
    }
}
