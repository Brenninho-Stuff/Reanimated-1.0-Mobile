package states.stages;

import states.stages.objects.*;
import cutscenes.CutsceneHandler;
import substates.GameOverSubstate;
import objects.Character;

import objects.Note;
import flixel.util.FlxSignal;
import shaders.DropShadowShader;

import torchsthings.shaders.AdjustColorShader;


class TankErect extends BaseStage
{
    var bg:BGSprite;
    var guy:FlxSprite;
    var sniper:FlxSprite;
    var tankCutscene:Character;
    var cutsceneHandler:CutsceneHandler;
    var blackScreen:FlxSprite;
    var tankmanRun:FlxTypedGroup<TankmenBG>;

    // InitialCutscene
    var tankmanIntro:Character;
    var otis:Character;
    var audioPlaying:FlxSound;
    var hasPlayedInitialCutscene:Bool = false;

override function create()
    {
        ratingPos.set(550, 500);
        comboCountPos.set(450, 650);
        comboImage.set( 0, 600);
        
        bg = new BGSprite('Erect/bg', -1085, -805);
        bg.setGraphicSize(Std.int(bg.width * 1.15));
        bg.updateHitbox();
        add(bg);

        guy = new FlxSprite(1300, 410);
        guy.frames = Paths.getSparrowAtlas("Erect/guy");
        guy.setGraphicSize(Std.int(guy.width * 1.15));
        guy.updateHitbox();
        guy.animation.addByPrefix("idle", "BLTank2 instance 1", 24, false);
		guy.animation.play("idle");
        add(guy);

        sniper = new FlxSprite(-207, 339);
		sniper.frames = Paths.getSparrowAtlas("Erect/sniper");
		sniper.antialiasing = true;
		sniper.scale.set(1.15, 1.15);
		sniper.updateHitbox();
		sniper.animation.addByPrefix("idle", "Tankmanidlebaked instance 1", 24, false);
		sniper.animation.addByPrefix("sip", "tanksippingBaked instance 1", 24, false);
		sniper.animation.play("idle");
		add(sniper);

        tankmanRun = new FlxTypedGroup<TankmenBG>();
		add(tankmanRun);

        // objets for the cutscene

        otis = new Character(gfGroup.x, gfGroup.y, "nene-otis", false);
        otis.x += otis.positionArray[0];
        otis.y += otis.positionArray[1];
        otis.visible = false;
        add(otis);

        tankmanIntro = new Character(dadGroup.x, dadGroup.y, "tankmanIntro", false);
        tankmanIntro.x += tankmanIntro.positionArray[0];
        tankmanIntro.y += tankmanIntro.positionArray[1];
        tankmanIntro.visible = false;

        tankCutscene = new Character(dadGroup.x, dadGroup.y, "tankman-cutscene", false);
		tankCutscene.x += tankCutscene.positionArray[0];
		tankCutscene.y += tankCutscene.positionArray[1];
		tankCutscene.visible = false;

        if (PlayState.SONG.song.toLowerCase().contains('pico-mix')) {
			defaultSpeaker = 'abot';
            //addSpeaker(98, 351);
            addSpeaker(gfGroup.x + 98, gfGroup.y + 351);
		}

        	// Default GFs
		switch(songName.toLowerCase()) {
			case 'stress':
				setDefaultGF('pico-speaker');
			case 'stress-pico-mix':
				setDefaultGF('otis-speaker');
				//trace('otis set');
			default:
				setDefaultGF('nene');
		}
        super.create();
        if (!isStoryMode && PlayState.SONG.song.toLowerCase() == "stress-pico-mix") {
            if (!hasPlayedInitialCutscene) {
                setStartCallback(PlayInitialCutscene);
            }
            setEndCallback(StressErectCutscene);
        }

    }
    override function createPost() {   
        add(tankmanIntro);
        add(tankCutscene);

        if(!ClientPrefs.data.lowQuality) {
            for (daGf in gfGroup)
			{
				var gf:Character = cast daGf;
				if (gf.curCharacter == 'pico-speaker')
				{
					//GameOverSubstate.characterName = 'pico-holding-nene-dead';
					var firstTank:TankmenBG = new TankmenBG(20, 500, true);
					firstTank.resetShit(30, 1900, true,false);
					firstTank.strumTime = 10;
					firstTank.visible = false;
					tankmanRun.add(firstTank);

					for (i in 0...TankmenBG.animationNotes.length)
					{
						if (FlxG.random.bool(16))
						{
							var tankBih = tankmanRun.recycle(TankmenBG);
                            applyShader(tankBih, "");
                            if (tankBih.shader != null && Std.isOfType(tankBih.shader, DropShadowShader)) {
                            cast(tankBih.shader, DropShadowShader).threshold = 0.3;
                            }
							tankBih.strumTime = TankmenBG.animationNotes[i][0];
							tankBih.scale.set(1.05, 1.05);
							tankBih.updateHitbox();
							tankBih.resetShit(600, 300, TankmenBG.animationNotes[i][1] < 2,false);
							// @:privateAccess
							// tankBih.endingOffset = 
							tankmanRun.add(tankBih);
						}
					}
					break;
				} else if (gf.curCharacter == 'otis-speaker') {
					var firstTank:TankmenBG = new TankmenBG(20, 500, true);
					firstTank.resetShit(30, 1900, true,false);
					firstTank.strumTime = 10;
					firstTank.visible = false;
					tankmanRun.add(firstTank);

					for (i in 0...TankmenBG.animationNotes.length)
					{
						if (FlxG.random.bool(16))
						{
							var tankBih = tankmanRun.recycle(TankmenBG);
                            applyShader(tankBih, "");
                            if (tankBih.shader != null && Std.isOfType(tankBih.shader, DropShadowShader)) {
                            cast(tankBih.shader, DropShadowShader).threshold = 0.3;
                            }   
							tankBih.strumTime = TankmenBG.animationNotes[i][0];
							tankBih.scale.set(1.05, 1.05);
							tankBih.updateHitbox();
							tankBih.resetShit(600, 300, TankmenBG.animationNotes[i][1] < 2,false);
							// @:privateAccess
							// tankBih.endingOffset = 
							tankmanRun.add(tankBih);
						}
					}
					break;
				}
            }
        }

        super.createPost();
        var colorShader = new AdjustColorShader();
        colorShader.hue = -38;
        colorShader.saturation = -20;
        colorShader.contrast = -25;
        colorShader.brightness = -46;
        applyShader(boyfriend, boyfriend.curCharacter);
		applyShader(gf, gf.curCharacter);
		applyShader(dad, dad.curCharacter);
        tankCutscene.shader = colorShader;
        //tankmanIntro.shader = colorShader;
        otis.shader = colorShader;
        /*for (tankman in tankmanRun.members) {
            if (tankman != null) {
                tankman.setShader(colorShader); //I'll do this tomorrow, Monday. I barely understand shaders, bruh, lol.
            }
        }*/
        if (speaker != null) speaker.setShader(colorShader);
    }

    var isSipping:Bool = false;

    override function beatHit() {
        super.beatHit();
        if (!isSipping) {
            sniper.animation.play("idle", false);
        }
        guy.animation.play("idle", false);
    
        if (!isSipping && FlxG.random.bool(2)) {  
            sipAnimation();
        }
    }
    
    function sipAnimation():Void {
        isSipping = true; 
        sniper.animation.play("sip", false, true);
    
        var timer = new FlxTimer();
        timer.start(3.48, function(_) {
            sniper.animation.play("idle", true, true);
            isSipping = false;
        });
    }

    override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float) {
		if(eventName == "Change Character" && ClientPrefs.data.shaders){
			switch(value1.toLowerCase().trim()) {
				case 'gf' | 'girlfriend' | '2':
					applyShader(gf, gf.curCharacter);
				case 'dad' | 'opponent' | '1':
					applyShader(dad, dad.curCharacter);
				default:
					applyShader(boyfriend, boyfriend.curCharacter);
			}
		}
	}

    function prepareCutsceneIntro() {
        cutsceneHandler = new CutsceneHandler();
        //tankmanIntro.visible = true;
        otis.visible = true;
        gf.visible = false;
        speaker.visible = false;
        game.inCutscene = true;
        game.isCameraOnForcedPos = true;
        camHUD.visible = false;
    }

    function prepareStressCutscene()
        {
            cutsceneHandler = new CutsceneHandler();

            game.inCutscene = true;
            game.isCameraOnForcedPos = true;
    
            Paths.sound('Tank/endCutscene');
    
            FlxTween.tween(camHUD, {alpha: 0}, 1,  {ease: FlxEase.sineInOut});
            
            blackScreen = new FlxSprite(-600,-570).makeGraphic(Std.int(FlxG.width * 3), Std.int(FlxG.height * 3), FlxColor.BLACK);
            blackScreen.alpha = 0;
		    blackScreen.scrollFactor.set();
            blackScreen.cameras = [camOther];
		    add(blackScreen);

            cutsceneHandler.finishCallback = cutsceneHandler.skipCallback = function() {
                game.inCutscene = false;
                camHUD.fade(0xFF000000, 0.5, true, null, true);
                new FlxTimer().start(0.5, function(tmr)
                {
                    endSong();
                });
            }

        }
        

        function PlayInitialCutscene()
        {
            hasPlayedInitialCutscene = true;
            prepareCutsceneIntro();
            cutsceneHandler.endTime = 32;

            game.tweenCameraToPosition(dad.x + 850, dad.y + 200, 0.1);

            var cutsceneSnd:FlxSound = new FlxSound().loadEmbedded(playWeekSound('stressPicoCutscene'));
		    FlxG.sound.list.add(cutsceneSnd);

            cutsceneHandler.onStart = function()
                {
                    cutsceneSnd.play(true);
                    audioPlaying = cutsceneSnd;
                };
            
            dad.playAnim("Cutscene");
            otis.playAnim("PlayCutscene");
            boyfriend.animation.finishCallback = function(name:String) {
                if (name == "alone") {
                    boyfriend.playAnim("alone");
                }
            };
            boyfriend.playAnim("alone");

            cutsceneHandler.timer (6.5, function () 
                {                    
                    game.tweenCameraZoom(1.3, 1, true, FlxEase.quadInOut);
                    game.tweenCameraToPosition(dad.x + 850, dad.y + 40, 2, FlxEase.sineOut);
                });
            cutsceneHandler.timer (8, function () 
                {                    
                    game.tweenCameraToPosition(dad.x + 750, dad.y + 40, 0.7, FlxEase.sineOut);
                });
            cutsceneHandler.timer (11.75, function () 
                {                    
                    game.tweenCameraZoom(0.75, 0.65, true, FlxEase.expoOut);
                    game.tweenCameraToPosition(dad.x + 750, dad.y + -400, 0.9, FlxEase.sineOut);
                });
            cutsceneHandler.timer (13, function () 
                {                    
                    game.tweenCameraZoom(0.8, 1, true, 1.5,FlxEase.quadInOut);
                    game.tweenCameraToPosition(dad.x + 900, dad.y + -100, 1.05, FlxEase.expoInOut);
                });

            cutsceneHandler.timer (13.7, function () 
                {   
                    game.tweenCameraZoom(1.05, 2, true, FlxEase.expoOut);
                    game.tweenCameraToPosition(dad.x + 1350, dad.y + 300, 0.3, FlxEase.sineOut);         
                    boyfriend.playAnim("catch nene", true);
                });

            cutsceneHandler.timer (24.7, function () 
                {
                    boyfriend.animation.finishCallback = function(name:String)
                        {
                            switch(name)
                                {
                                    case 'idle':
                                        boyfriend.dance();
                                }
                            }
                            boyfriend.dance();
                });

            cutsceneHandler.timer (24.2, function () 
                {                    
                    game.tweenCameraZoom(0.75, 1, true, FlxEase.quadInOut);
                    game.tweenCameraToPosition(dad.x + 480, dad.y + 250, 1, FlxEase.sineOut);
                });

            cutsceneHandler.timer (27.8, function () 
                {                    
                    game.tweenCameraToPosition(dad.x + 440, dad.y + 250, 0.2, FlxEase.sineOut);
                    FlxG.camera.shake(0.02, 0.1);
                });
            cutsceneHandler.timer (30, function () 
                {                    
                    game.tweenCameraZoom(0.65, 1, true, FlxEase.quadInOut);
                    game.tweenCameraToPosition(dad.x + 800, dad.y + 250, 1, FlxEase.sineOut);
                });
            cutsceneHandler.timer (32, function () 
                {
                    gf.visible = true;
                    otis.visible = false;
                    speaker.visible = true;
                });

            cutsceneHandler.finishCallback = function() {
                game.isCameraOnForcedPos = false;
                game.inCutscene = false;
                camHUD.visible = true;
                FlxTween.tween(camHUD, {alpha: 1}, 2, {ease: FlxEase.sineInOut});
                startCountdown();
                otis.destroy();
                tankmanIntro.destroy();
            };

            cutsceneHandler.skipCallback = function () {
                cutsceneSnd.stop();
                cutsceneHandler.finishCallback();

                //otis.visible = false;
                //tankmanIntro.visible = false;
                gf.visible = true;
                dad.visible = true;
                speaker.visible = true;
                dad.dance();
                gf.dance();
                boyfriend.dance();
                dad.animation.finishCallback = null;
                gf.animation.finishCallback = null;
            }
    
        }
        function StressErectCutscene()
        {
            prepareStressCutscene();
            cutsceneHandler.endTime = 12;
    
            canPause = false;
    
            dad.playAnim("Cutscene");   
    
            game.tweenCameraToPosition(tankCutscene.x + 580, tankCutscene.y + 400);
            game.tweenCameraZoom(0.65, 0.8, true, FlxEase.smoothStepOut);
            FlxG.sound.play(Paths.sound('Tank/endCutscene'));
            
            cutsceneHandler.timer(0.1, function()
                {
                    gf.animation.finishCallback = function(name:String) {
                        if (name == "idle") {
                            gf.playAnim("idle");
                        }
                    };
                    gf.playAnim("idle");
                        boyfriend.animation.finishCallback = function(name:String)
                        {
                            switch(name)
                                {
                                    case 'idle':
                                        boyfriend.dance();
                                }
                            }
                            boyfriend.dance();
                });

            cutsceneHandler.timer(7, function()
            {
                boyfriend.playAnim("laugh", true);
                boyfriend.specialAnim = true;
            });
            cutsceneHandler.timer(10.9, function()
            {
                FlxTween.tween(blackScreen, { alpha: 1}, 1, {startDelay: 0.3});
            });
            cutsceneHandler.timer (11.1, function () 
            {
                    game.tweenCameraToPosition(tankCutscene.x + 450, tankCutscene.y + 100, 4.3, FlxEase.smoothStepOut);
            });
        }

    override function opponentNoteHit(note:Note)
		{
			var sndTime:Float = note.strumTime - Conductor.songPosition;
			switch(note.noteType)
				{
			case 'Dodge Tankman':
				{
					dad.playAnim('dodge', true);
					dad.specialAnim = true;
					//FlxG.sound.play(Paths.sound(''));		
				}
					gf.playAnim('shootTankman', true);
					gf.specialAnim = true;
					FlxG.camera.shake(0.01, 0.2);
			}
		}
        function applyShader(sprite:FlxSprite, char_name:String)
	{
		var rim = new DropShadowShader();
		rim.color = 0xFFDFEF3C;
        rim.setAdjustColor(-46, -38, -25, -20);
		rim.threshold = 0.1;
		rim.attachedSprite = sprite;
		rim.distance = 15;
		rim.strength = 1;
		rim.angle = 90;
		switch (char_name)
		{
			case "bf":
				{
					sprite.animation.callback = function(anim, frame, index)
					{
						rim.updateFrameInfo(sprite.frame);
					};
				}

			case "nene":
				{
					rim.angle = 90;
					sprite.animation.callback = function(anim, frame, index)
					{
						rim.updateFrameInfo(sprite.frame);
					};
				}
            case "tankman":
				{
					rim.threshold = 0.3;
					rim.angle = 130;
					sprite.animation.callback = function(anim, frame, index)
					{
						rim.updateFrameInfo(sprite.frame);
					};
				}
            case "tankman-blody":
				{
					rim.angle = 130;
					rim.altMaskImage = Paths.image("Erect/masks/tankmanCaptainBloody_mask").bitmap;
					rim.maskThreshold = 1;
					rim.threshold = 0.3;
					rim.useAltMask = true;

					sprite.animation.callback = function(anim, frame, index)
					{
						rim.updateFrameInfo(sprite.frame);
					};
				}
			default:
				{
					rim.angle = 90;
					sprite.animation.callback = function(anim, frame, index)
					{
						rim.updateFrameInfo(sprite.frame);
					};
				}
		}
		sprite.shader = rim;
	}

    }

    


