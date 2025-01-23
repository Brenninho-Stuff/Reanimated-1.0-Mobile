package states.stages;

import flixel.FlxBasic;
import states.stages.objects.*;
import substates.GameOverSubstate;
import objects.Character;
import flixel.addons.display.FlxBackdrop;
import cutscenes.CutsceneHandler;
import objects.Character;
import backend.MathUtil;
import objects.Note;
import flash.display.BlendMode;
import torchsthings.shaders.*;
//import torchsthings.utils.ShaderUtils;
import torchsthings.objects.ReflectedChar;
import openfl.filters.ShaderFilter;
import shaders.RainShader;
import flixel.addons.display.FlxTiledSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class PhillyStreets extends BaseStage
{
    //Stage Objects
    var scrollingSky:FlxBackdrop;
    var phillySpray:BGSprite;
    var skyline:BGSprite;
    var foregroundcity:BGSprite;
    var highwaylight:BGSprite;
    var construction:BGSprite;
    var smog:BGSprite;
    var highway:BGSprite;
    var foreground:BGSprite;
    var puddle:BGSprite;
	var phillyTrafficLightmap:BGSprite;

    //Cars And Traffic Lights
    var phillyTraffic:FlxSprite;
	var phillyCars:FlxSprite;
	var phillyCarsBack:FlxSprite;
	var lastChange:Int = 0;
	var changeInterval:Int = 8; // make sure it doesnt change until AT LEAST this many beats
	var carWaiting:Bool = false; // if the car is waiting at the lights and is ready to go on green
	var carInterruptable:Bool = true; // if the car can be reset
	var car2Interruptable:Bool = true;
    var lightsStop:Bool = false; // state of the traffic lights

    //Shader
	/*var rain:Rain;
	var rainFilter:ShaderFilter;
	var useShader:Bool = false;
    var rainTimeScale:Float = 1.0;
	var rainScaler:Float = 0.55;*/

    //Cutscene Bools
    var inCutsceneDarnell:Bool = false;
	var seenDarnellCutscene:Bool = true;

    //Cutscene objects
    var cutsceneHandler:CutsceneHandler;
    var blackScreen:FlxSprite;
    var picoIntro1:Character;
	var picoIntro2:Character;

    //Cutscene Values
    var dadPos:Array<Float>;
    var picoPos:Array<Float>;

    //Sounds
    var gunPrepSnd:FlxSound;
    var bonkSnd:FlxSound;
    var lightCanSnd:FlxSound;
    var kickCanSnd:FlxSound;
    var kneeCanSnd:FlxSound;
    var cutsceneSnd:FlxSound = new FlxSound().loadEmbedded(Paths.sound('darnellCanCutscene'));

    //Nene and Speaker
    //var abot:ABot;
	//var abotLookDir:Bool = false;	
    var knifeRaised:Bool = false;
    var blinkTime:Float = 0;
    final BLINK_MIN:Float = 1;
    final BLINK_MAX:Float = 3;

    //Notes And Events
	var didReload:Bool = false;
    var spraycan:SpraycanAtlasSprite;
	var picoFade:FlxSprite;
    var darkenable:Array<FlxSprite> = [];
    var casingFrames:FlxAtlasFrames;
    var casingGroup:FlxSpriteGroup;

	var rainShader:RainShader;
	var rainShaderStartIntensity:Float = 0;
	var rainShaderEndIntensity:Float = 0;

    override function create() {

		ratingPos.set(1400, 800); // Just used random numbers for example
		comboCountPos.set(1300, 950);
		comboImage.set( 0, 900);

//		if (ClientPrefs.data.shaders) rain = new Rain();
        //Game Over
        var _song = PlayState.SONG;
		var startingSong = game.startingSong;
		if(_song.gameOverSound == null || _song.gameOverSound.trim().length < 1) GameOverSubstate.deathSoundName = 'pico_loss_sfx';
		if(_song.gameOverLoop == null || _song.gameOverLoop.trim().length < 1) GameOverSubstate.loopSoundName = 'GameoverPico';
		if(_song.gameOverEnd == null || _song.gameOverEnd.trim().length < 1) GameOverSubstate.endSoundName = 'gameOverEnd';
		if(_song.gameOverChar == null || _song.gameOverChar.trim().length < 1) GameOverSubstate.characterName = 'pico-dead';

        //Adding Sounds
        lightCanSnd = new FlxSound();
		FlxG.sound.list.add(lightCanSnd);
		lightCanSnd.loadEmbedded(playWeekSound('Darnell_Lighter'));
		kickCanSnd = new FlxSound();
		FlxG.sound.list.add(kickCanSnd);
		kickCanSnd.loadEmbedded(playWeekSound('Kick_Can_UP'));
		kneeCanSnd = new FlxSound();
		FlxG.sound.list.add(kneeCanSnd);
		kneeCanSnd.loadEmbedded(playWeekSound('Kick_Can_FORWARD'));
		gunPrepSnd = new FlxSound();
		FlxG.sound.list.add(gunPrepSnd);
		gunPrepSnd.loadEmbedded(playWeekSound('Gun_Prep'));
        bonkSnd = new FlxSound();
        FlxG.sound.list.add(bonkSnd);
        bonkSnd.loadEmbedded(playWeekSound('Pico_Bonk'));
        for (i in 1...5) playWeekSound('shots/shot$i');

        //Adding Stage Objects
        scrollingSky = new FlxBackdrop(Paths.image("phillyStreets/phillySkybox"), X);
		scrollingSky.setPosition(-650, -375);
		scrollingSky.scrollFactor.set(0.1, 0.1);
		scrollingSky.scale.set(0.65, 0.65);
		scrollingSky.velocity.x = -22;
		scrollingSky.antialiasing = ClientPrefs.data.antialiasing;
		addAndDark(scrollingSky);

        skyline = new BGSprite('phillyStreets/phillySkyline', -545, -273, 0.2, 0.2);
        skyline.setGraphicSize(Std.int(skyline.width * 1));
		skyline.updateHitbox();
		addAndDark(skyline);

        foregroundcity = new BGSprite('phillyStreets/phillyForegroundCity', 625, 94, 0.3, 0.3);
        foregroundcity.setGraphicSize(Std.int(foregroundcity.width * 1));
		foregroundcity.updateHitbox();
		addAndDark(foregroundcity);

        highwaylight = new BGSprite('phillyStreets/phillyHighwayLights', 284, 305, 1.0, 1.0);
        highwaylight.setGraphicSize(Std.int(highwaylight.width * 1));
		highwaylight.updateHitbox();
		addAndDark(highwaylight);

        construction  = new BGSprite('phillyStreets/phillyConstruction', 1800, 364, 0.7, 1.0);
        construction.setGraphicSize(Std.int(construction.width * 1));
		construction.updateHitbox();
		addAndDark(construction);

        var smog = new BGSprite('phillyStreets/phillySmog',  -6, 245, 1.0, 1.0);
        smog.setGraphicSize(Std.int(smog.width * 1));
		smog.updateHitbox();
		addAndDark(smog);

        highway = new BGSprite('phillyStreets/phillyHighway', 139, 209, 1.0, 1.0);
        highway.setGraphicSize(Std.int(highway.width * 1));
		highway.updateHitbox();
		addAndDark(highway);

		phillyCarsBack = new FlxSprite(1748, 818);
		phillyCarsBack.frames = Paths.getSparrowAtlas("phillyStreets/phillyCars");
		phillyCarsBack.scrollFactor.set(0.9, 1);
		phillyCarsBack.antialiasing = true;
		phillyCarsBack.flipX = true;
		phillyCarsBack.animation.addByPrefix("car1", "car1", 0, false);
		phillyCarsBack.animation.addByPrefix("car2", "car2", 0, false);
		phillyCarsBack.animation.addByPrefix("car3", "car3", 0, false);
		phillyCarsBack.animation.addByPrefix("car4", "car4", 0, false);
		addAndDark(phillyCarsBack);

        phillyCars = new FlxSprite(1748, 818);
		phillyCars.frames = Paths.getSparrowAtlas("phillyStreets/phillyCars");
		phillyCars.scrollFactor.set(0.9, 1);
		phillyCars.antialiasing = true;
		phillyCars.animation.addByPrefix("car1", "car1", 0, false);
		phillyCars.animation.addByPrefix("car2", "car2", 0, false);
		phillyCars.animation.addByPrefix("car3", "car3", 0, false);
		phillyCars.animation.addByPrefix("car4", "car4", 0, false);
		addAndDark(phillyCars);

        phillyTraffic = new FlxSprite(1840, 608);
		phillyTraffic.frames = Paths.getSparrowAtlas("phillyStreets/phillyTraffic");
		phillyTraffic.scrollFactor.set(0.9, 1);
		phillyTraffic.antialiasing = true;
		phillyTraffic.animation.addByPrefix("togreen", "redtogreen", 24, false);
		phillyTraffic.animation.addByPrefix("tored", "greentored", 24, false);
		addAndDark(phillyTraffic);

        phillyTrafficLightmap = new BGSprite('phillyStreets/phillyTraffic_lightmap', 1840, 608, 0.9, 1.0, "add");
		phillyTrafficLightmap.setGraphicSize(Std.int(phillyTrafficLightmap.width * 1));
		phillyTrafficLightmap.updateHitbox();
		addAndDark(phillyTrafficLightmap);
        
        var foreground = new BGSprite('phillyStreets/phillyForeground', 88, 317, 1.0, 1.0);
        foreground.setGraphicSize(Std.int(foreground.width * 1));
		foreground.updateHitbox();
		addAndDark(foreground);

        phillySpray = new BGSprite('phillyStreets/SpraycanPile', 920, 1045, 1, 1);
		phillySpray.setGraphicSize(Std.int(phillySpray.width * 1));
		phillySpray.updateHitbox();

        spraycan = new SpraycanAtlasSprite(phillySpray.x + 530, phillySpray.y - 240);

        casingFrames = Paths.getSparrowAtlas('PicoBullet'); //precache
		casingGroup = new FlxSpriteGroup();

        //Adding Speaker
       // abot = new ABot(1100, 740);
		//add(abot);

        //Adding picoFade
        picoFade = new FlxSprite();
		picoFade.antialiasing = ClientPrefs.data.antialiasing;
		picoFade.alpha = 0;
		addAndDark(picoFade);

        //Setting Up Shader And Starting Cutscene
		/*if(ClientPrefs.data.shaders)
		{
			switch(PlayState.SONG.song.toLowerCase()) {
				case 'darnell':
				rain.setIntenseValues(0.0, 0.1);
				useShader = true;
				case 'lit-up':
				rain.setIntenseValues(0.1, 0.2);
				useShader = true;
				case '2hot':
				rain.setIntenseValues(0.2, 0.4);
				useShader = true;
			}
		}*/
		if(ClientPrefs.data.shaders)
			setupRainShader();

		if(PlayState.SONG.song.toLowerCase() == "darnell")
		{
			if(isStoryMode && !seenCutscene)
			{
				setStartCallback(darnellIntro);
			}
		}

        //Functions
        resetCar(true, true);
        //updateABotEye(true);

    }

	
	function setupRainShader()
	{
		rainShader = new RainShader();
		rainShader.scale = FlxG.height / 200;
		switch (songName)
		{
			case 'darnell':
				rainShaderStartIntensity = 0;
				rainShaderEndIntensity = 0.1;
			case 'lit-up':
				rainShaderStartIntensity = 0.1;
				rainShaderEndIntensity = 0.2;
			case '2hot':
				rainShaderStartIntensity = 0.2;
				rainShaderEndIntensity = 0.4;
		}
		rainShader.intensity = rainShaderStartIntensity;
		FlxG.camera.setFilters([new ShaderFilter(rainShader)]);
	}

    override function createPost()
    {
       // if (useShader) 
		//{
		//	rainFilter = new ShaderFilter(rain);
		//	ShaderUtils.applyFiltersToCams([camGame, camHUD], [rainFilter]);
			//FlxG.game.setFilters([rainFilter]);
			
			/*
			This comment is only here to explain the reflection.

			It should look like this:
			reflectedChar = new ReflectedChar(character, alpha, shader);

			What it does is takes the data from the character and technically makes a new character. Then it flips it, applies an offset
			to not look weird with the animations, applies the alpha value to make it more transparent/opaque, and then it stores the main 
			character as a variable so that it can update it's animations to match the reflected character.

			Make sure to use "addBehindBF", "addBehindGF", and "addBehindDad" instead of "add" so that the reflected character is below the proper character it needs to be.
			*/

		//	reflectedBF = new ReflectedChar(boyfriend, 0.35);
			//addBehindBF(reflectedBF);
		//}
		addAbot();

        add(phillySpray);
        add(spraycan);
        add(casingGroup);
		createCan();

    }

	override function sectionHit() {
		updateABotEye();
	}

	override function startSong() {
		abotSongStart();
	}

    function prepareCutscene()
	{
		reflectedBF = new ReflectedChar(boyfriend, 0.35);
		addBehindBF(reflectedBF);
		inCutsceneDarnell = true;
		seenDarnellCutscene = false;
		picoPos = [boyfriend.getMidpoint().x -400 - boyfriend.cameraPosition[0] - game.boyfriendCameraOffset[0],  boyfriend.getMidpoint().y - 100 + boyfriend.cameraPosition[1] + game.boyfriendCameraOffset[1]];
		dadPos = [dad.getMidpoint().x + 150 + dad.cameraPosition[0] + game.opponentCameraOffset[0], dad.getMidpoint().y - 100 + dad.cameraPosition[1] + game.opponentCameraOffset[1]];

		game.isCameraOnForcedPos = true;
		cutsceneHandler = new CutsceneHandler();

		//boyfriendGroup.alpha = 0.00001;
		camHUD.visible = false;

		/*picoIntro1 = new Character(1939, 454, "pico-intro", true);
		picoIntro1.x += picoIntro1.positionArray[0];
		picoIntro1.y += picoIntro1.positionArray[1];
		add(picoIntro1);

		picoIntro2 = new Character(1939, 454, "pico-intro2", true);
		picoIntro2.x += picoIntro2.positionArray[0];
		picoIntro2.y += picoIntro2.positionArray[1];
		add(picoIntro2);
		picoIntro2.alpha = 0.00001;
		*/

		/*if (useShader)
		{
			reflectedBF.destroy();
			reflectedBF = new ReflectedChar(picoIntro1, 0.35);
			addBehindBF(reflectedBF);
		}*/

		camFollow.setPosition(picoPos[0] + 250, picoPos[1]);

		cutsceneHandler.finishCallback = function()
		{
			game.tweenCameraZoom(0.77, 2, true, FlxEase.sineInOut);
			game.tweenCameraToPosition(dadPos[0]+180, dadPos[1], 2, FlxEase.sineInOut);
			var timeForStuff:Float = Conductor.crochet / 1000 * 4.5;
			FlxG.sound.music.fadeOut(timeForStuff);
			spraycan.cutscene = false;
			spraycan.destroy();
			startCountdown();

			camHUD.visible = true;
			boyfriend.animation.finishCallback = null;
			dad.animation.finishCallback = null;
		};

	}

	function darnellIntro()
	{

		prepareCutscene();

		var cutsceneMusic:FlxSound = new FlxSound().loadEmbedded(playWeekMusic('darnellCanCutscene'));
		cutsceneMusic.looped = true;
		FlxG.sound.list.add(cutsceneMusic);

		var darnellLaugh:FlxSound = new FlxSound().loadEmbedded(playWeekSound('cutscene/darnell_laugh'));
		darnellLaugh.volume = 0.6;
		FlxG.sound.list.add(darnellLaugh);

		var neneLaugh:FlxSound = new FlxSound().loadEmbedded(playWeekSound('cutscene/nene_laugh'));
		neneLaugh.volume = 0.6;
		FlxG.sound.list.add(neneLaugh);

		blackScreen = new FlxSprite(-300,-170).makeGraphic(Std.int(FlxG.width * 3), Std.int(FlxG.height * 3), FlxColor.BLACK);
		blackScreen.scrollFactor.set();
		add(blackScreen);

		cutsceneHandler.endTime = 10;
		cutsceneHandler.timer(0.1, function()
		{
			game.tweenCameraZoom(1.3, 0, true, FlxEase.quadInOut);
			game.tweenCameraToPosition(picoPos[0] + 250, picoPos[1], 0, FlxEase.sineInOut);
			//picoIntro1.playAnim("pissed", true);
			boyfriend.playAnim("Intro", true);
			gf.animation.finishCallback = function(name:String)
				{
					switch(name)
						{
							case 'danceLeft', 'danceRight':
							gf.dance();
						}
					}
				gf.dance();
			dad.animation.finishCallback = function(name:String)
				{
					switch(name)
						{
							case 'idle':
							dad.dance();
						}
					}
				dad.dance();
		});
		
		var cutsceneSnd:FlxSound = new FlxSound().loadEmbedded(Paths.sound('darnellCanCutscene'));
		FlxG.sound.list.add(cutsceneSnd);
		cutsceneHandler.timer(0.7, function()
		{
			cutsceneSnd.play(true);
			FlxTween.tween(blackScreen, { alpha: 0}, 2, {startDelay: 0.3});
		});

		cutsceneHandler.timer(2, function()
		{
			game.tweenCameraToPosition(dadPos[0]+150, dadPos[1], 2.5);
			FlxTween.tween(FlxG.camera, {zoom: 0.66}, 2.5, {ease: FlxEase.quadInOut});
		});

		cutsceneHandler.timer(5, function()
		{
			dad.playAnim("lightCan", true);
			lightCanSnd.play(true);
		});
		
		cutsceneHandler.timer(6.3, function()
		{
			// picoIntro1.alpha = 0.00001;
			// picoIntro2.alpha = 1;
			// reflectedBF.destroy();
			// reflectedBF = new ReflectedChar(picoIntro2, 0.35);
			addBehindBF(reflectedBF);
			boyfriend.playAnim("reload", true);
			gunPrepSnd.play(true);
			game.tweenCameraToPosition(dadPos[0]+180, dadPos[1], 0.4, FlxEase.backOut);
		});
		cutsceneHandler.timer(6.466, function() createCasing());

		cutsceneHandler.timer(6.65, function()
		{
			dad.playAnim("kickCan", true);
			spraycan.playCanStart();
			kickCanSnd.play(true);
		});

		cutsceneHandler.timer(6.97, function()
		{
/*			if (useShader)
			{
				reflectedBF.destroy();
				reflectedBF = new ReflectedChar(picoIntro1, 0.35);
				addBehindBF(reflectedBF);
			}*/
		});

		cutsceneHandler.timer(7.0, function()
		{
			dad.playAnim("kneeCan", true);
			kneeCanSnd.play(true);
			boyfriend.playAnim("Return", true);
		});

		cutsceneHandler.timer(7.1, function()
		{
			game.tweenCameraToPosition(dadPos[0]+100, dadPos[1], 1, FlxEase.quadInOut);
			FlxG.sound.play(randomWeekSound('shots/shot', 1, 4));			spraycan.playCanShot();
			new FlxTimer().start(1/24, function(_)
			{
				darkenStageProps();
			});
		});

		cutsceneHandler.timer(7.9, function()
		{
			dad.playAnim("laughCutscene", true);
			darnellLaugh.play(true);

			//FlxG.sound.play(Paths.sound('darnell_laugh'));
		});
		
		cutsceneHandler.timer(8.2, function()
		{
			gf.playAnim("laughCutscene", true);
			neneLaugh.play(true);

			//FlxG.sound.play(Paths.sound('nene_laugh'));
		});

		cutsceneHandler.timer(8.7, function()
		{
			inCutsceneDarnell = false;
		});

	}

    override function update(elapsed:Float)
	{
		//rain.shader.update(elapsed * rainTimeScale);
		/*if(ClientPrefs.data.shaders)
			rain.update(elapsed * rainTimeScale, Math.max(0, Conductor.songPosition - ClientPrefs.data.noteOffset) / FlxG.sound.music.length);
		    rainTimeScale = MathUtil.coolLerp(rainTimeScale, rainScaler, 0.05);*/
	    if(rainShader != null)
		{
			var remappedIntensityValue:Float = FlxMath.remapToRange(Conductor.songPosition, 0, (FlxG.sound.music != null ? FlxG.sound.music.length : 0), rainShaderStartIntensity, rainShaderEndIntensity);
			rainShader.intensity = remappedIntensityValue;
			rainShader.updateViewInfo(FlxG.width, FlxG.height, FlxG.camera);
			rainShader.update(elapsed);
		}
		if(gf.animation.curAnim.name == "Idle-alt"){
            blinkTime -= elapsed;

            if(blinkTime <= 0){
                gf.playAnim("idle-alt", true);
                blinkTime = FlxG.random.float(BLINK_MIN, BLINK_MAX);
            }
        }

		if (inCutsceneDarnell)
		{
			if (dad.isAnimationFinished() && dad.animation.curAnim.name != 'lightCan') {
				dad.playAnim('intro');
			}
	
			if (gf.isAnimationFinished()) {
				gf.playAnim('intro');
			}
		}

		abotUpdate();
		super.update(elapsed);
	}

    override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch(eventName)
		{
			case "Change Character":
				if (value1.toLowerCase() == "bf" || value1.toLowerCase() == "boyfriend" || value1.toLowerCase() == "player") {
					//if (useShader)
					{
						reflectedBF.destroy();
						reflectedBF = new ReflectedChar(boyfriend, 0.35);
						addBehindBF(reflectedBF);
					}
				} 
				if (value1.toLowerCase() == "dad" || value1.toLowerCase() == "enemy" || value1.toLowerCase() == "opponent") {
					reflectedDad.destroy();
					reflectedDad = new ReflectedChar(dad, 0.35);
					addBehindDad(reflectedDad);
				}
				if (value1.toLowerCase() == 'gf' || value1.toLowerCase() == 'girlfriend') {
					reflectedGF.destroy();
					reflectedGF = new ReflectedChar(gf, 0.35);
					addBehindGF(reflectedGF);
				} 
		}
	}

	override function countdownTick(count:Countdown, num:Int) {
		if (isStoryMode && !seenDarnellCutscene)
		{
			if (num == 3)
			{
				new FlxTimer().start(0.5, function(tmr)
				{
					game.isCameraOnForcedPos = false;
				});
			}
		}
	}

    override function beatHit() 
	{
		abotBeatHit();

		// Try driving a car when its possible
		if (FlxG.random.bool(10) && curBeat != (lastChange + changeInterval) && carInterruptable == true)
		{
			if(lightsStop == false){
				driveCar(phillyCars);
			}
			else{
				driveCarLights(phillyCars);
			}
		}
		
		// try driving one on the right too. in this case theres no red light logic, it just can only spawn on green lights
		if(FlxG.random.bool(10) && curBeat != (lastChange + changeInterval) && car2Interruptable == true && lightsStop == false) driveCarBack(phillyCarsBack);
	
		// After the interval has been hit, change the light state.
		if (curBeat == (lastChange + changeInterval)) changeLights(curBeat);

		if(PlayState.SONG.song.toLowerCase() != "blazin"){
            if(game.health < 0.4 && !knifeRaised){
                knifeRaised = true;
				gf.idleSuffix = "-alt";
				gf.recalculateDanceIdle();
                blinkTime = FlxG.random.float(BLINK_MIN, BLINK_MAX);
                gf.playAnim("raiseKnife", true);

            } 
            else if(game.health >= 0.4 && knifeRaised && gf.animation.curAnim.name == "idle-alt"){
                knifeRaised = false;
                gf.playAnim("lowerKnife", true);
				gf.idleSuffix = "";
				gf.recalculateDanceIdle();
            }
        }
	}

	function changeLights(beat:Int):Void{

		lastChange = beat;
		lightsStop = !lightsStop;

		if(lightsStop){
			phillyTraffic.animation.play('tored');
			changeInterval = 20;
		} else {
			phillyTraffic.animation.play('togreen');
			changeInterval = 30;

			if(carWaiting == true) finishCarLights(phillyCars);
		}
	}

	function resetCar(left:Bool, right:Bool){
		if(left){
			carWaiting = false;
			carInterruptable = true;
			if (phillyCars != null) {
				FlxTween.cancelTweensOf(phillyCars);
				phillyCars.x = 1200;
				phillyCars.y = 400;
				phillyCars.angle = 0;
			}
		}

		if(right){
			car2Interruptable = true;
			if (phillyCarsBack != null) {
				FlxTween.cancelTweensOf(phillyCarsBack);
				phillyCarsBack.x = 1200;
				phillyCarsBack.y = 400;
				phillyCarsBack.angle = 0;
			}
		}
	}

	function finishCarLights(sprite:FlxSprite):Void	{
		carWaiting = false;
		var duration:Float = FlxG.random.float(1.8, 3);
		var rotations:Array<Int> = [-5, 18];
		var offset:Array<Float> = [306.6, 168.3];
		var startdelay:Float = FlxG.random.float(0.2, 1.2);

		var path:Array<FlxPoint> = [
			FlxPoint.get(1950 - offset[0] - 80, (980 - offset[1] + 15) - 265),
			FlxPoint.get(2400 - offset[0], (980 - offset[1] - 50) - 265),
			FlxPoint.get(3102 - offset[0], (1127 - offset[1] + 40) - 265)
		];

		FlxTween.angle(sprite, rotations[0], rotations[1], duration, {ease: FlxEase.sineIn, startDelay: startdelay} );
		FlxTween.quadPath(sprite, path, duration, true,
		{
			ease: FlxEase.sineIn,
			startDelay: startdelay,
			onComplete: function(_) {
				carInterruptable = true;
			}
		});
	}

	function driveCarLights(sprite:FlxSprite):Void {
		carInterruptable = false;
		FlxTween.cancelTweensOf(sprite);
		var variant:Int = FlxG.random.int(1,4);
		sprite.animation.play('car' + variant);
		var extraOffset = [0, 0];
		var duration:Float = 2;

		switch(variant){
			case 1:
				duration = FlxG.random.float(1, 1.7);
			case 2:
				extraOffset = [20, -15];
				duration = FlxG.random.float(0.9, 1.5);
			case 3:
				extraOffset = [30, 50];
				duration = FlxG.random.float(1.5, 2.5);
			case 4:
				extraOffset = [10, 60];
				duration = FlxG.random.float(1.5, 2.5);
		}
		
		var rotations:Array<Int> = [-7, -5];
		var offset:Array<Float> = [306.6, 168.3];
		sprite.offset.set(extraOffset[0], extraOffset[1]);

		var path:Array<FlxPoint> = [
			FlxPoint.get(1500 - offset[0] - 20, (1049 - offset[1] - 20) - 265),
			FlxPoint.get(1770 - offset[0] - 80, (994 - offset[1] + 10) - 265),
			FlxPoint.get(1950 - offset[0] - 80, (980 - offset[1] + 15) - 265)
		];
		// debug shit!!! keeping it here just in case
		// for(point in path){
		// 	var debug:FlxSprite = new FlxSprite(point.x - 5, point.y - 5).makeGraphic(10, 10, 0xFFFF0000);
		// 	add(debug);
		// }
		FlxTween.angle(sprite, rotations[0], rotations[1], duration, {ease: FlxEase.cubeOut} );
		FlxTween.quadPath(sprite, path, duration, true,
		{
			ease: FlxEase.cubeOut,
			onComplete: function(_) {
				carWaiting = true;
				if(lightsStop == false) finishCarLights(phillyCars);
			}
		});
	}

	/**
	* Drives a car across the screen without stopping.
	* Used when the lights are green.
	*/
	function driveCar(sprite:FlxSprite):Void {
		carInterruptable = false;
		FlxTween.cancelTweensOf(sprite);
		var variant:Int = FlxG.random.int(1,4);
		sprite.animation.play('car' + variant);
		// setting an offset here because the current implementation of stage prop offsets was not working at all for me
		// if possible id love to not have to do this but im keeping this for now
		var extraOffset = [0, 0];
		var duration:Float = 2;
		// set different values of speed for the car types (and the offset)
		switch(variant){
			case 1:
				duration = FlxG.random.float(1, 1.7);
			case 2:
				extraOffset = [20, -15];
				duration = FlxG.random.float(0.6, 1.2);
			case 3:
				extraOffset = [30, 50];
				duration = FlxG.random.float(1.5, 2.5);
			case 4:
				extraOffset = [10, 60];
				duration = FlxG.random.float(1.5, 2.5);
		}
		// random arbitrary values for getting the cars in place
		// could just add them to the points but im LAZY!!!!!!
		var offset:Array<Float> = [306.6, 168.3];
		sprite.offset.set(extraOffset[0], extraOffset[1]);
		// start/end rotation
		var rotations:Array<Int> = [-8, 18];
		// the path to move the car on
		var path:Array<FlxPoint> = [
			FlxPoint.get(1570 - offset[0], (1049 - offset[1] - 30) - 265),
			FlxPoint.get(2400 - offset[0], (980 - offset[1] - 50) - 265),
			FlxPoint.get(3102 - offset[0], (1127 - offset[1] + 40) - 265)
		];

		FlxTween.angle(sprite, rotations[0], rotations[1], duration, null );
		FlxTween.quadPath(sprite, path, duration, true,
		{
			ease: null,
			onComplete: function(_) {
				carInterruptable = true;
			}
		});
	}

	function driveCarBack(sprite:FlxSprite):Void {
		car2Interruptable = false;
		FlxTween.cancelTweensOf(sprite);
		var variant:Int = FlxG.random.int(1,4);
		sprite.animation.play('car' + variant);
		// setting an offset here because the current implementation of stage prop offsets was not working at all for me
		// if possible id love to not have to do this but im keeping this for now
		var extraOffset = [0, 0];
		var duration:Float = 2;
		// set different values of speed for the car types (and the offset)
		switch(variant){
			case 1:
				duration = FlxG.random.float(1, 1.7);
			case 2:
				extraOffset = [20, -15];
				duration = FlxG.random.float(0.6, 1.2);
			case 3:
				extraOffset = [30, 50];
				duration = FlxG.random.float(1.5, 2.5);
			case 4:
				extraOffset = [10, 60];
				duration = FlxG.random.float(1.5, 2.5);
		}
		var offset:Array<Float> = [306.6, 168.3];
		sprite.offset.set(extraOffset[0], extraOffset[1]);
		var rotations:Array<Int> = [18, -8];
		var path:Array<FlxPoint> = [
				FlxPoint.get(3102 - offset[0], (1127 - offset[1] + 60) - 265),
				FlxPoint.get(2400 - offset[0], (980 - offset[1] - 30) - 265),
				FlxPoint.get(1570 - offset[0], (1049 - offset[1] - 10) - 265)

		];

		FlxTween.angle(sprite, rotations[0], rotations[1], duration, null );
		FlxTween.quadPath(sprite, path, duration, true,
		{
			ease: null,
			onComplete: function(_) {
				car2Interruptable = true;
			}
		});
	}

    override function goodNoteHit(note:Note)
	{
		switch(game.combo)
		{
			case 50:
				gf.playAnim('comboCheer', true);
				gf.specialAnim = true;
				trace("yeiii");
			case 100:
				gf.playAnim('comboCheerHigh', true);
				gf.specialAnim = true;
				trace("yeii?");
				
		}

		switch(note.noteType)
		{
			case 'weekend-1-reload':
				boyfriend.holdTimer = 0;
				boyfriend.playAnim('cock', true);
				boyfriend.specialAnim = true;
				gunPrepSnd.play();
				
				boyfriend.animation.callback = function(name:String, frameNumber:Int, frameIndex:Int)
				{
					switch(name)
					{
						case 'cock':
							if(frameNumber == 3)
							{
								boyfriend.animation.callback = null;
								createCasing();
							}
						default: boyfriend.animation.callback = null;
					}
				}
				didReload = true;
				game.notes.forEachAlive(function(note:Note)
				{
					if(note.noteType == 'weekend-1-firegun')
						note.blockHit = false;
				});
				showPicoFade();

			case 'weekend-1-firegun':
				if (!didReload)
					note.blockHit = true;
				camFollow.x -= 100;
				camFollow.y -= 100;
				boyfriend.holdTimer = 0;
				boyfriend.playAnim('shoot', true);
				boyfriend.specialAnim = true;
				FlxG.sound.play(randomWeekSound('shots/shot', 1, 4));
				spraycan.playCanShot();

				new FlxTimer().start(1/24, function(tmr)
				{
					darkenStageProps();
				});
		}
	}

	override function noteMiss(note:Note)
	{
		switch(note.noteType)
		{
			case 'weekend-1-firegun':
				boyfriend.playAnim('shootMISS', true);
				boyfriend.specialAnim = true;
				spraycan.playHitPico();
				bonkSnd.play();
			
			case 'weekend-1-reload':
				didReload = false;

		}
	}

	override function opponentNoteHit(note:Note)
	{
		var sndTime:Float = note.strumTime - Conductor.songPosition;
		switch(note.noteType)
		{
			//Funciones para las notas de la weekend1 (Darnell)
			case 'weekend-1-lightcan':

				dad.holdTimer = 0;
				dad.playAnim('lightCan', true);
				dad.specialAnim = true;
				//lightCanSnd.play(true, sndTime - 65);
				
				game.isCameraOnForcedPos = true;
				game.defaultCamZoom += 0.1;
				game.focusedChar = game.dad;
				game.cameraSpeed = 2;
				camFollow.x -= 100;

			case 'weekend-1-kickcan':
				createCan();
				dad.holdTimer = 0;
				dad.playAnim('kickCan', true);
				dad.specialAnim = true;
				kickCanSnd.play(true, sndTime - 50);
				spraycan.playCanStart();
				camFollow.x += 250;
				game.cameraSpeed = 1.5;
				game.defaultCamZoom -= 0.1;
				
				new FlxTimer().start(1.1, function(_) {
					game.isCameraOnForcedPos = false;
					game.focusedChar = game.boyfriend;
					game.cameraSpeed = 1;
				});

			case 'weekend-1-kneecan':

				dad.holdTimer = 0;
				dad.playAnim('kneeCan', true);
				dad.specialAnim = true;
				kneeCanSnd.play(true, sndTime - 22);
		}
	}

	function darkenStageProps()
	{
		// Darken the background, then fade it back.
		for (sprite in darkenable)
		{
			// If not excluded, darken.
			sprite.color = 0xFF111111;
			new FlxTimer().start(1/24, (tmr) ->
			{
				sprite.color = 0xFF222222;
				FlxTween.color(sprite, 1.4, 0xFF222222, 0xFFFFFFFF);
			});
		}
	}

	var didCreateCan = false;
	function createCan()
	{
		if(didCreateCan) return;
		spraycan = new SpraycanAtlasSprite(phillySpray.x + 530, phillySpray.y - 240);
		spraycan.cutscene = false;
		add(spraycan);
		didCreateCan = true;
	}

	function createCasing()
	{
		var casing:FlxSprite = new FlxSprite(boyfriend.x + 175, boyfriend.y + 150);
		casing.frames = casingFrames;
		casing.animation.addByPrefix('pop', 'Pop0', 24, false);
		casing.animation.addByPrefix('idle', 'Bullet0', 24, true);
		casing.animation.play('pop', true);
		
		casing.animation.callback = function(name:String, frameNumber:Int, frameIndex:Int)
		{
			if (name == 'pop' && frameNumber == 40)
			{
				// Get the end position of the bullet dynamically.
				casing.x = casing.x + casing.frame.offset.x - 1;
				casing.y = casing.y + casing.frame.offset.y + 1;
		
				casing.angle = 125.1; // Copied from FLA
		
				// Okay this is the neat part, we can set the velocity and angular acceleration to make it roll without editing update().
				var randomFactorA:Float = FlxG.random.float(3, 10);
				var randomFactorB:Float = FlxG.random.float(1.0, 2.0);
				casing.velocity.x = 20 * randomFactorB;
				casing.drag.x = randomFactorA * randomFactorB;
		
		
				casing.angularVelocity = 100;
				// Calculated to ensure angular acceleration is maintained through the whole roll.
				casing.angularDrag = (casing.drag.x / casing.velocity.x) * 100;
		
				casing.animation.play('idle');
				casing.animation.callback = null; // Save performance.
			}
		};
		casingGroup.add(casing);
	}

	function showPicoFade()
	{
		if(ClientPrefs.data.lowQuality) return;

		picoFade.setPosition(boyfriend.x, boyfriend.y);
		picoFade.frames = boyfriend.frames;
		picoFade.frame = boyfriend.frame;
		picoFade.alpha = 0.3;
		picoFade.scale.set(1, 1);
		picoFade.updateHitbox();
		picoFade.visible = true;

		FlxTween.cancelTweensOf(picoFade.scale);
		FlxTween.cancelTweensOf(picoFade);
		FlxTween.tween(picoFade.scale, {x: 1.3, y: 1.3}, 0.4);
		FlxTween.tween(picoFade, {alpha: 0}, 0.4, {onComplete: (_) -> (picoFade.visible = false)});
	}

    function addAndDark(object:FlxSprite) {
		add(object); 
		darkenable.push(object);
	}
}