package objectsplus;

import flixel.FlxSprite;
import objects.Note;

class GhostEffect extends FlxSprite
{
    private static var boyfriendGhostData:GhostData = new GhostData();
    private static var dadGhostData:GhostData = new GhostData();
    private static var boyfriendNoteCount:Int = 0;
    private static var dadNoteCount:Int = 0;
    
    public static function onBoyfiendNoteHit(note:Note):Void 
    {
        if (!note.isSustainNote)
        {
            if (boyfriendGhostData.strumTime == note.strumTime)
            {
                boyfriendNoteCount++;
                if (boyfriendNoteCount >= 2)
                {
                    updateGhostData('boyfriend');
                    createGhost('boyfriend');
                }
            }
            else
            {
                boyfriendNoteCount = 1; // Reset count if the note is not consecutive
            }
            boyfriendGhostData.strumTime = note.strumTime;
        }
    }

    public static function onDadNoteHit(note:Note):Void
    {
        if (!note.isSustainNote)
        {
            if (dadGhostData.strumTime == note.strumTime)
            {
                dadNoteCount++;
                if (dadNoteCount >= 2)
                {
                    updateGhostData('dad');
                    createGhost('dad');
                }
            }
            else
            {
                dadNoteCount = 1; // Reset count if the note is not consecutive
            }
            dadGhostData.strumTime = note.strumTime;
        }
    }

    private static function createGhost(char:String):Void
    {
        var character = (char == 'boyfriend') ? PlayState.instance.boyfriend : PlayState.instance.dad;
        var ghostSprite = new FlxSprite(character.x, character.y);
        
        ghostSprite.frames = character.frames;
        ghostSprite.animation.add(character.animation.curAnim.name, character.animation.curAnim.frames, character.animation.curAnim.frameRate, character.animation.curAnim.looped);
        ghostSprite.scale.set(character.scale.x, character.scale.y);
        ghostSprite.flipX = character.flipX;
        ghostSprite.alpha = 1;
        ghostSprite.color = character.color;
        
        var ghostData = (char == 'boyfriend') ? boyfriendGhostData : dadGhostData;
        ghostSprite.animation.frameName = ghostData.frameName;
        ghostSprite.offset.set(ghostData.offsetX, ghostData.offsetY);
        
        ghostSprite.animation.play(character.animation.curAnim.name, true);

        // Apply the same shader as the character
        ghostSprite.shader = character.shader;
        
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
