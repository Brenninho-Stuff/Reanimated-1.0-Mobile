package states.stages.objects;
import haxe.Constraints.FlatEnum;
import cutscenes.CutsceneHandler;
import objects.Character;


class NewPicoDopplegangerSprite extends Character
{

  public var cutsceneSounds:FlxSound = null; 
  var suffix:String = '';
  var lastOffsetX:Float = 0;
  var lastOffsetY:Float = 0;

  public function new(x:Float, y:Float, ?character:String = 'doplayer')
  {
    super(x, y);
    if (character == "doplayer") isPlayer = true;
    changeCharacter(character);

  }

  public function cancelSounds(){
    if(cutsceneSounds != null) {
      cutsceneSounds.destroy();
      cutsceneSounds = null;
    }
  }

  public function doAnim(_suffix:String, shoot:Bool = false, explode:Bool = false, cutsceneHandler:CutsceneHandler, player:Bool = true){

    suffix = _suffix;

    cutsceneHandler.timer(0.3, () -> {  
      playAnim("shock", true);
      //if (cutsceneSounds != null) cutsceneSounds.destroy();
      cutsceneSounds = FlxG.sound.load(Paths.sound('cutscene/picoGasp', 'week3'), 1.0, false, true, true);
      cutsceneSounds.play();
    });

  
    if (!shoot)
    {
      cutsceneHandler.timer(8.74, () -> {
        playAnim("prendido", true);
      });
    }

    if(shoot == true){
      cutsceneHandler.timer(6.29, () -> {
        animation.play("tiro", true);
        //if (cutsceneSounds != null) cutsceneSounds.destroy();
        cutsceneSounds = FlxG.sound.load(Paths.sound('cutscene/picoShoot', 'week3'), 1.0, false, true, true);
        cutsceneSounds.play();
      });
      cutsceneHandler.timer(10.33, () -> {
        if (cutsceneSounds != null) cutsceneSounds.destroy();
        cutsceneSounds = FlxG.sound.load(Paths.sound('cutscene/picoSpin', 'week3'), 1.0, false, true, true);
        cutsceneSounds.play();
      });
    }else{
      if(explode == true){

        cutsceneHandler.timer(8.74, () -> {
          playAnim("eplota", true);
        });

        cutsceneHandler.timer(3.7, () -> {
          animation.play("prende", true);
          if (cutsceneSounds != null) cutsceneSounds.destroy();
          //animation.play("explode" , true);
          cutsceneSounds = FlxG.sound.load(Paths.sound('cutscene/picoCigarette2', 'week3'), 1.0, false, true, true);
          cutsceneSounds.play();
        });
        cutsceneHandler.timer(8.75, () -> {
          if (cutsceneSounds != null) cutsceneSounds.destroy();
          cutsceneSounds = FlxG.sound.load(Paths.sound('cutscene/picoExplode', 'week3'), 1.0, false, true, true);
          cutsceneSounds.play();
        });
        cutsceneHandler.objects.remove(this);
      }else{

        cutsceneHandler.timer(3.7, () -> {
          animation.play("prende", true);
          if (cutsceneSounds != null) cutsceneSounds.destroy();
          cutsceneSounds = FlxG.sound.load(Paths.sound('cutscene/picoCigarette', 'week3'), 1.0, false, true, true);
          cutsceneSounds.play();
        });
      }
    }
  }

  override public function update(elapsed:Float):Void {
    super.update(elapsed);
    var realBaseX:Float = x - lastOffsetX;
    var realBaseY:Float = y - lastOffsetY;

    var offsetX:Float = 0;
    var offsetY:Float = 0;

    if (animation.curAnim != null) {
      switch (animation.curAnim.name) {
        case "tiro":
          if (isPlayer) { offsetX = -420; offsetY = -110; } else { offsetX = -40 ; offsetY = -110; }
        case "prende":
          if (isPlayer) { offsetX = -20; offsetY = 0; } else { offsetX = 0; offsetY = 0; }
      }
    }

    x = realBaseX + offsetX;
    y = realBaseY + offsetY;

    lastOffsetX = offsetX;
    lastOffsetY = offsetY;
  }

  /*function startLoop(x:String){
    playAnimation("loop" , true, false, true);
  }*/
}