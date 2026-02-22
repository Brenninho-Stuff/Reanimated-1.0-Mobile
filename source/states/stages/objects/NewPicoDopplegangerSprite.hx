package states.stages.objects;
import cutscenes.CutsceneHandler;

class NewPicoDopplegangerSprite extends FlxSprite
{

  public var isPlayer:Bool = false;
  public var cutsceneSounds:FlxSound = null; 
  var suffix:String = '';

  public function new(x:Float, y:Float)
  {
    super(x, y);
    frames = Paths.getSparrowAtlas("philly/Erect/cutscene/PicoDoppleganguer");
    antialiasing = ClientPrefs.data.antialiasing; 

    animation.addByPrefix("cigarette", "pico cigarette lit", 24, false);
    animation.addByPrefix("explode", "pico fucking killed", 24, false);
    animation.addByPrefix("shoot", "pico takes aim", 24, false);
  }

  public function cancelSounds(){
    if(cutsceneSounds != null) {
      cutsceneSounds.destroy();
      cutsceneSounds = null;
    }
  }

  public function doAnim(_suffix:String, shoot:Bool = false, explode:Bool = false, cutsceneHandler:CutsceneHandler){
    suffix = _suffix;

    trace('Doppelganger: doAnim(' + suffix + ', ' + shoot + ', ' + explode + ')');

    cutsceneHandler.timer(0.3, () -> {
      //if (cutsceneSounds != null) cutsceneSounds.destroy();
      cutsceneSounds = FlxG.sound.load(Paths.sound('cutscene/picoGasp', 'week3'), 1.0, false, true, true);
      cutsceneSounds.play();
    });

    if(shoot == true){
      animation.play("shoot" + suffix, true);

      cutsceneHandler.timer(6.29, () -> {
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
        animation.play("explode" + suffix, true);

        //onAnimationComplete.add(startLoop);

        cutsceneHandler.timer(3.7, () -> {
          if (cutsceneSounds != null) cutsceneSounds.destroy();
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
        animation.play("cigarette" + suffix, true);

        cutsceneHandler.timer(3.7, () -> {
          if (cutsceneSounds != null) cutsceneSounds.destroy();
          cutsceneSounds = FlxG.sound.load(Paths.sound('cutscene/picoCigarette', 'week3'), 1.0, false, true, true);
          cutsceneSounds.play();
        });
      }
    }
  }

  /*function startLoop(x:String){
    playAnimation("loop" + suffix, true, false, true);
  }*/
}