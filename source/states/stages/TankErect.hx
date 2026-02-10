package states.stages;

import states.stages.objects.*;
import cutscenes.CutsceneHandler;
import substates.GameOverSubstate;
import objects.Character;

import objects.Note;
import flixel.util.FlxSignal;
import shaders.DropShadowShader;
import shaders.DropShadowScreenspace;
import torchsthings.shaders.AdjustColorShader;
import flash.display.BlendMode;


class TankErect extends BaseStage
{
    var bg:BGSprite;
    var ceiling:BGSprite;
    var bus:BGSprite;
    var mountain:BGSprite;
    var city:BGSprite;
    var street:BGSprite;
    var bar:BGSprite;
    var lights:BGSprite;
    var sky:BGSprite;
    var guy:FlxSprite;
    var sniper:FlxSprite;
    var tankCutscene:Character;
    var cutsceneHandler:CutsceneHandler;
    var blackScreen:FlxSprite;
    var tankmanRun:FlxTypedGroup<TankmenBG>;
    // InitialCutscene
    var audioPlaying:FlxSound;
    var hasPlayedInitialCutscene:Bool = false;

    var tankmenSpeaker:TankmenSpeaker;


override function create()
    {
        ratingPos.set(550, 500);
        comboCountPos.set(450, 650);
        comboImage.set( 0, 600);
        
        sky = new BGSprite('Erect/sky', -900, -650);
        sky.setGraphicSize(Std.int(sky.width * 1));
        sky.updateHitbox();
        sky.antialiasing = ClientPrefs.data.antialiasing;
        add(sky);

        city = new BGSprite('Erect/city', -600, -300);
        city.setGraphicSize(Std.int(city.width * 0.9));
        city.updateHitbox();
        city.antialiasing = ClientPrefs.data.antialiasing;
        add(city);

        mountain = new BGSprite('Erect/mountains', 600, -500);
        mountain.setGraphicSize(Std.int(mountain.width * 0.9));
        mountain.updateHitbox();
        mountain.antialiasing = ClientPrefs.data.antialiasing;
        add(mountain);

        street = new BGSprite('Erect/street', -900, 570);
        street.antialiasing = ClientPrefs.data.antialiasing;
        street.setGraphicSize(Std.int(street.width * 0.8));
        street.updateHitbox();
        add(street);

        tankmanRun = new FlxTypedGroup<TankmenBG>();
		add(tankmanRun);

        bus = new BGSprite('Erect/bus', -1050, 10);
        bus.antialiasing = ClientPrefs.data.antialiasing;
        bus.setGraphicSize(Std.int(bus.width * 1));
        bus.updateHitbox();
        add(bus);

        bar = new BGSprite('Erect/bar', 1250, 520);
        bar.antialiasing = ClientPrefs.data.antialiasing;
        bar.setGraphicSize(Std.int(bar.width * 0.9));
        bar.updateHitbox();
        add(bar);

        lights = new BGSprite('Erect/light', 700, 260);
        lights.blend = ADD;
        lights.alpha = 0.9;
        lights.antialiasing = ClientPrefs.data.antialiasing;
        lights.setGraphicSize(Std.int(lights.width * 0.9));
        lights.updateHitbox();

        ceiling = new BGSprite('Erect/ceiling', 1450, -280);
        ceiling.antialiasing = ClientPrefs.data.antialiasing;
        ceiling.setGraphicSize(Std.int(ceiling.width * 0.9));
        ceiling.updateHitbox();

        /*bg = new BGSprite('Erect/bg', -1085, -805);
        bg.setGraphicSize(Std.int(bg.width * 1.15));
        bg.updateHitbox();
        add(bg);*/

        guy = new FlxSprite(1300, 410);
        guy.frames = Paths.getSparrowAtlas("Erect/guy");
        guy.setGraphicSize(Std.int(guy.width * 1.15));
        guy.updateHitbox();
        guy.animation.addByPrefix("idle", "BLTank2 instance 1", 24, false);
		guy.animation.play("idle");
        guy.visible = false;
        add(guy);

        sniper = new FlxSprite(-207, 339);
		sniper.frames = Paths.getSparrowAtlas("Erect/sniper");
		sniper.antialiasing = true;
		sniper.scale.set(1.15, 1.15);
		sniper.updateHitbox();
		sniper.animation.addByPrefix("idle", "Tankmanidlebaked instance 1", 24, false);
		sniper.animation.addByPrefix("sip", "tanksippingBaked instance 1", 24, false);
		sniper.animation.play("idle");
        sniper.visible = false;
		add(sniper);

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
        add(lights);
        add(ceiling);
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
                            cast(tankBih.shader, DropShadowShader).threshold = 0.5;
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
                            cast(tankBih.shader, DropShadowShader).threshold = 0.5;
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
        colorShader.hue = -45;
        colorShader.saturation = -30;
        colorShader.contrast = -20;
        colorShader.brightness = -60;
        applyShader(boyfriend, boyfriend.curCharacter);
		applyShader(gf, gf.curCharacter);
		applyShader(dad, dad.curCharacter);
        if (speaker != null)
        {
        speaker.setShader(colorShader);
        tankmenSpeaker = new TankmenSpeaker(speaker.tankmen, speaker.thugmen, this);
		addBehindDadAndBF(tankmenSpeaker); //Pagen la pensión por favor, me muero de hambre :"v
        }
        //tankmanIntro.shader = colorShader;
        /*for (tankman in tankmanRun.members) {
            if (tankman != null) {
                tankman.setShader(colorShader); //I'll do this tomorrow, Monday. I barely understand shaders, bruh, lol.
            }
        }*/
    }

    var isSipping:Bool = false;

    override function beatHit() {
        super.beatHit();
        if (!isSipping) {
            sniper.animation.play("idle", false);
        }
        guy.animation.play("idle", false);
        if (tankmenSpeaker != null) {
            tankmenSpeaker.dance();
        }
    
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
    var otis:FlxAnimate;
    var speakerFront:FlxAnimate;
    var speakerBack:FlxAnimate;

    function prepareCutsceneIntro() {
        cutsceneHandler = new CutsceneHandler();
        /*otis = new FlxAnimate(gf.x + -200, gf.y + -700);
        Paths.loadAnimateAtlasFromLibrary(otis, "Erect/cutscene/Nene_Otis", Paths.currentLevel);
        otis.antialiasing = ClientPrefs.data.antialiasing;
        addBehindBF(otis);
        cutsceneHandler.push(otis);*/ //Example
        
        speakerBack = new FlxAnimate(1170, 640);
        Paths.loadAnimateAtlasFromLibrary(speakerBack, "Erect/cutscene/speakerBack", Paths.currentLevel);
        speakerBack.antialiasing = ClientPrefs.data.antialiasing;
        addBehindSpeaker(speakerBack);
        cutsceneHandler.push(speakerBack);
        
        speakerFront = new FlxAnimate(1170, 640);
        Paths.loadAnimateAtlasFromLibrary(speakerFront, "Erect/cutscene/speakerFront", Paths.currentLevel);
        speakerFront.antialiasing = ClientPrefs.data.antialiasing;
        addBehindDadAndBF(speakerFront);
        cutsceneHandler.push(speakerFront);

        //tankmanIntro.visible = true;
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
            speakerBack.anim.addBySymbol('cutscene', 'Tankmens 2', 24, false);
            speakerBack.anim.play("cutscene", true);
            applyAbotShader(speakerBack);

            speakerFront.anim.addBySymbol('cutscene', 'Tankmens 2', 24, false);
            speakerFront.anim.play("cutscene", true);
            applyAbotShader(speakerFront);
            
            //otis.anim.addBySymbol('cutscene', 'Nene Idle Otis', 24, false);
            //otis.anim.play("cutscene", true);
            //applyAbotShader(otis);


            cutsceneHandler.onStart = function()
                {
                    cutsceneSnd.play(true);
                    audioPlaying = cutsceneSnd;
                };
            
            dad.playAnim("Cutscene1");
            gf.playAnim("Cutscene");
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

            cutsceneHandler.finishCallback = function() {
                game.isCameraOnForcedPos = false;
                game.inCutscene = false;
                camHUD.visible = true;
                FlxTween.tween(camHUD, {alpha: 1}, 2, {ease: FlxEase.sineInOut});
                startCountdown();
            };

            cutsceneHandler.skipCallback = function () {
                cutsceneSnd.stop();
                cutsceneHandler.finishCallback();

                //otis.visible = false;
                //tankmanIntro.visible = false;
                gf.visible = true;
                dad.visible = true;
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
    
            dad.playAnim("CutsceneEnd");   
    
            game.tweenCameraToPosition(dad.x + 800, dad.y + 200);
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
                    game.tweenCameraToPosition(dad.x + 800, dad.y + 0, 4.3, FlxEase.smoothStepOut);
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
			rim.curZoom = camGame.zoom;
		};
	}
        function applyShader(sprite:FlxSprite, char_name:String)
	{
		var rim = new DropShadowShader();
		rim.color = 0xFF1E17FF;
        rim.setAdjustColor(-60, -45, -20, -30);
		rim.threshold = 0.1;
		rim.attachedSprite = sprite;
		rim.distance = 15;
		rim.strength = 1;
		rim.angle = 135;
		switch (char_name)
		{
			case "bf":
				{
                    rim.angle = 135;
					sprite.animation.callback = function(anim, frame, index)
					{
						rim.updateFrameInfo(sprite.frame);
					};
				}

			case "nene":
				{
					rim.angle = 135;
					sprite.animation.callback = function(anim, frame, index)
					{
						rim.updateFrameInfo(sprite.frame);
					};
				}
            case "tankman":
				{
					rim.threshold = 0.3;
					rim.angle = 135;
					sprite.animation.callback = function(anim, frame, index)
					{
						rim.updateFrameInfo(sprite.frame);
					};
				}
            case "tankman-bloody":
				{
					rim.angle = 135;
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
					rim.angle = 135;
					sprite.animation.callback = function(anim, frame, index)
					{
						rim.updateFrameInfo(sprite.frame);
					};
				}
		}
		sprite.shader = rim;
	}
 }




