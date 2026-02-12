package states.stages.cutscenes;

import states.stages.TankErect;
import cutscenes.CutsceneHandler;
import objects.Character;
import flixel.util.FlxSignal;
import flash.display.BlendMode;
import flixel.FlxObject;
import backend.BaseStage;
import shaders.DropShadowScreenspace;

class CutsceneTankErect {

    //PreloadCutscene 
    var stage:TankErect;
    var camFollow:FlxObject;
    var audioPlaying:FlxSound;
    var seenCutscene:Bool = false;

    //Tankmens
    var speakerFront:FlxAnimate;
    var speakerBack:FlxAnimate;

    public function new (stage:TankErect) {
        this.stage = stage;
        this.camFollow = stage.camFollow;
    }
    
    var cutsceneHandler:CutsceneHandler;

    function prepareCutscenePico() {
        var game = PlayState.instance;
        cutsceneHandler = new CutsceneHandler(false);
        cutsceneHandler.useCurLevel = true;
        game.isCameraOnForcedPos = true;
        game.inCutscene = true;
        
        Paths.sound('Tank/stressPicoCutscene');

        speakerBack = new FlxAnimate(1170, 640);
        Paths.loadAnimateAtlasFromLibrary(speakerBack, "Erect/cutscene/speakerBack", Paths.currentLevel);
        speakerBack.antialiasing = ClientPrefs.data.antialiasing;
        stage.addBehindSpeaker(speakerBack);
        cutsceneHandler.push(speakerBack);
        
        speakerFront = new FlxAnimate(1170, 640);
        Paths.loadAnimateAtlasFromLibrary(speakerFront, "Erect/cutscene/speakerFront", Paths.currentLevel);
        speakerFront.antialiasing = ClientPrefs.data.antialiasing;
        stage.addBehindDadAndBF(speakerFront);
        cutsceneHandler.push(speakerFront);

        game.inCutscene = true;
        game.isCameraOnForcedPos = true;
        stage.camHUD.visible = false;
    }

    public function PlayCutscenePico() {
            var game = PlayState.instance;
            prepareCutscenePico();
            cutsceneHandler.endTime = 33;

            game.tweenCameraToPosition(game.dad.x + 850, game.dad.y + 200, 0.1);

            var cutsceneSnd:FlxSound = new FlxSound().loadEmbedded(Paths.sound('Tank/stressPicoCutscene'));
		    FlxG.sound.list.add(cutsceneSnd);
            speakerBack.anim.addBySymbol('cutscene', 'Tankmens 2', 24, false);
            speakerBack.anim.play("cutscene", true);
            applyAbotShader(speakerBack);

            speakerFront.anim.addBySymbol('cutscene', 'Tankmens 2', 24, false);
            speakerFront.anim.play("cutscene", true);
            applyAbotShader(speakerFront);
            
            cutsceneHandler.onStart = function()
                {
                    cutsceneSnd.play(true);
                    audioPlaying = cutsceneSnd;
                };
            
            game.dad.playAnim("Cutscene1");
            game.gf.playAnim("Cutscene");
            game.boyfriend.animation.finishCallback = function(name:String) {
                if (name == "alone") {
                    game.boyfriend.playAnim("alone");
                }
            };
            game.boyfriend.playAnim("alone");

            cutsceneHandler.timer (6.5, function () 
                {                    
                    game.tweenCameraZoom(1.3, 1, true, FlxEase.quadInOut);
                    game.tweenCameraToPosition(game.dad.x + 850, game.dad.y + 40, 2, FlxEase.sineOut);
                });
            cutsceneHandler.timer (8, function () 
                {                    
                    game.tweenCameraToPosition(game.dad.x + 750, game.dad.y + 40, 0.7, FlxEase.sineOut);
                });
            cutsceneHandler.timer (11.75, function () 
                {                    
                    game.tweenCameraZoom(0.75, 0.65, true, FlxEase.expoOut);
                    game.tweenCameraToPosition(game.dad.x + 750, game.dad.y + -400, 0.9, FlxEase.sineOut);
                });
            cutsceneHandler.timer (13, function () 
                {                    
                    game.tweenCameraZoom(0.8, 1.5, true, FlxEase.quadInOut);
                    game.tweenCameraToPosition(game.dad.x + 900, game.dad.y + -100, 1.05, FlxEase.expoInOut);
                });

            cutsceneHandler.timer (13.7, function () 
                {   
                    game.tweenCameraZoom(1.05, 2, true, FlxEase.expoOut);
                    game.tweenCameraToPosition(game.dad.x + 1350, game.dad.y + 300, 0.3, FlxEase.sineOut);         
                    game.boyfriend.playAnim("catch nene", true);
                });

            cutsceneHandler.timer (24.7, function () 
                {
                    game.boyfriend.animation.finishCallback = function(name:String)
                        {
                            switch(name)
                                {
                                    case 'idle':
                                        game.boyfriend.dance();
                                }
                            }
                            game.boyfriend.dance();
                });

            cutsceneHandler.timer (24.2, function () 
                {                    
                    game.tweenCameraZoom(0.75, 1, true, FlxEase.quadInOut);
                    game.tweenCameraToPosition(game.dad.x + 480, game.dad.y + 250, 1, FlxEase.sineOut);
                });

            cutsceneHandler.timer (27.8, function () 
                {                    
                    game.tweenCameraToPosition(game.dad.x + 440, game.dad.y + 250, 0.2, FlxEase.sineOut);
                    FlxG.camera.shake(0.02, 0.1);
                });
            cutsceneHandler.timer (30, function () 
                {                    
                    game.tweenCameraZoom(0.65, 1, true, FlxEase.quadInOut);
                    game.tweenCameraToPosition(game.dad.x + 800, game.dad.y + 250, 1, FlxEase.sineOut);
                });

            cutsceneHandler.finishCallback = function() {
                game.isCameraOnForcedPos = false;
                game.inCutscene = false;
                stage.seenCutscene = true;
                stage.camHUD.visible = true;
                FlxTween.tween(stage.camHUD, {alpha: 1}, 2, {ease: FlxEase.sineInOut});
                game.startCountdown();
            };

            cutsceneHandler.skipCallback = function () {
                cutsceneSnd.stop();
                cutsceneHandler.finishCallback();

                //otis.visible = false;
                //tankmanIntro.visible = false;
                game.gf.visible = true;
                game.dad.visible = true;
                game.dad.dance();
                game.gf.dance();
                game.boyfriend.dance();
                game.dad.animation.finishCallback = null;
                game.gf.animation.finishCallback = null;
            }
        }
        function applyAbotShader(sprite:FlxSprite){
		var rim = new DropShadowScreenspace();
		rim.setAdjustColor(-60, -45, -20, -30);
		rim.color =  0xFF1E17FF;
        rim.threshold = 0.7;
		rim.antialiasAmt = 0;
		rim.attachedSprite = sprite;
		rim.angle = 135;
		sprite.shader = rim;
		sprite.animation.callback = function(anim, frame, index)
		{
			rim.updateFrameInfo(sprite.frame);
		};
	}
}
