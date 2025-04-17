package states.stages;

import states.stages.objects.*;
import cutscenes.CutsceneHandler;
import substates.GameOverSubstate;
import objects.Character;

import objects.Note;
import flixel.util.FlxSignal;

class Tank extends BaseStage
{
	var tankWatchtower:BGSprite;
	var tankGround:BackgroundTank;
	var tankmanRun:FlxTypedGroup<TankmenBG>;
	var foregroundSprites:FlxTypedGroup<BGSprite>;

	// lol
	var tankleft1:BGSprite;
	var tankleft2:BGSprite;
	var tankmid:BGSprite;
	var tankright1:BGSprite;
	var tankright2:BGSprite;

	var picoStress:FlxSignal = new FlxSignal();

	//var abot:ABot;

	override function create()
	{
		ratingPos.set(550, 500);
        comboCountPos.set(450, 650);
        comboImage.set( 0, 600);

		var sky:BGSprite = new BGSprite('tankSky', -800, -800, 0, 0);
		sky.setGraphicSize(Std.int(1.6 * sky.width));
		sky.updateHitbox();
		add(sky);
	
		if(!ClientPrefs.data.lowQuality)
		{
			var clouds:BGSprite = new BGSprite('tankClouds', -300, -200, 0.1, 0.1);
			clouds.scale.set(1.2, 1.2);
			//clouds.active = true;
			//clouds.velocity.x = FlxG.random.float(3, 15);
			add(clouds);

			var right:BGSprite = new BGSprite('right smoke', 1300, -350, 0.3, 0.3, ['right smoke'], true);
			right.setGraphicSize(Std.int(1.2 * right.width));
			right.updateHitbox();
			add(right);

			var left:BGSprite = new BGSprite('left smoke', -650, -350, 0.3, 0.3, ['left smoke'], true);
			left.setGraphicSize(Std.int(1.2 * left.width));
			left.updateHitbox();
			add(left);
	
			var mountains:BGSprite = new BGSprite('tankMountains', -800, -300, 0.2, 0.2);
			mountains.setGraphicSize(Std.int(1.4 * mountains.width));
			mountains.updateHitbox();
			add(mountains);
	
			var buildings:BGSprite = new BGSprite('tankBuildings', -800, 80, 0.3, 0.3);
			buildings.setGraphicSize(Std.int(1.4 * buildings.width));
			buildings.updateHitbox();
			add(buildings);
		}
	
		var ruins:BGSprite = new BGSprite('tankRuins',-800, -20, 0.35, 0.35);
		ruins.setGraphicSize(Std.int(1.4 * ruins.width));
		ruins.updateHitbox();
		add(ruins);
	
		if(!ClientPrefs.data.lowQuality)
		{
			var smokeLeft:BGSprite = new BGSprite('smokeLeft', -400, -100, 0.4, 0.4, ['SmokeBlurLeft'], true);
			add(smokeLeft);
			var smokeRight:BGSprite = new BGSprite('smokeRight', 1100, -100, 0.4, 0.4, ['SmokeRight'], true);
			add(smokeRight);
	
			tankWatchtower = new BGSprite('tankWatchtower', -300, 20, 0.6, 0.6, ['watchtower']);
			tankWatchtower.scale.set(1.4, 1.4);
			add(tankWatchtower);
		}
	
		tankGround = new BackgroundTank();
		add(tankGround);
	
		tankmanRun = new FlxTypedGroup<TankmenBG>();
		add(tankmanRun);
	
		var ground:BGSprite = new BGSprite('tankGround',  -760, 550);
		ground.setGraphicSize(Std.int(1.4 * ground.width));
		ground.updateHitbox();
		add(ground);
	
		/*foregroundSprites = new FlxTypedGroup<BGSprite>();
		foregroundSprites.add(new BGSprite('tank0', -850, 550, 1.5, 1.5, ['fg']));
		if(!ClientPrefs.data.lowQuality) foregroundSprites.add(new BGSprite('tank1', -600, 900, 1.5, 1.5, ['fg']));
		foregroundSprites.add(new BGSprite('tank2', 20, 790, 1.5, 1.5, ['foreground']));
		if(!ClientPrefs.data.lowQuality) foregroundSprites.add(new BGSprite('tank1', 600, 900, 1.5, 1.5, ['fg']));
		foregroundSprites.add(new BGSprite('tank5', 1620, 680, 1.5, 1.5, ['fg']));
		if(!ClientPrefs.data.lowQuality) foregroundSprites.add(new BGSprite('tank3', 1200, 750, 1.5, 1.5, ['fg']));
		foregroundSprites.setGraphicSize(Std.int(foregroundSprites.width * 1.2));*/

		tankleft1 = new BGSprite('tank0', -1050, 600, 1.5, 1.5, ['fg']);
		tankleft1.setGraphicSize(Std.int(1.3 * tankleft1.width));
		tankleft1.updateHitbox();
		tankleft2 = new BGSprite('tank1', -600, 950, 1.5, 1.5, ['fg']);
		tankleft2.setGraphicSize(Std.int(1.3 * tankleft2.width));
		tankleft2.updateHitbox();
		tankmid = new BGSprite('tank2', 380, 920, 1.5, 1.5, ['foreground']);
		tankmid.setGraphicSize(Std.int(1.3 * tankmid.width));
		tankmid.updateHitbox();
		tankright1 = new BGSprite('tank1', 1050, 950, 1.5, 1.5, ['fg']);
		tankright1.setGraphicSize(Std.int(1.3 * tankright1.width));
		tankright1.updateHitbox();
		tankright2 = new BGSprite('tank5', 1820, 680, 1.5, 1.5, ['fg']);
		tankright2.setGraphicSize(Std.int(1.3 * tankright2.width));
		tankright2.updateHitbox();
	
		// Default GFs
		if(songName == 'stress') setDefaultGF('pico-speaker');
		else setDefaultGF('gf-tankmen');
		
        addAbot(100, 355);
		//abot = new ABotSpeaker(gfGroup.x, gfGroup.y + 310 /*+ 550*/);

		
		if (isStoryMode && !seenCutscene)
		{
			switch (songName)
			{
				case 'ugh':
					setStartCallback(ughIntro);
				case 'guns':
					setStartCallback(gunsIntro);
				case 'stress':
					setStartCallback(stressIntro);
			}
		}
	}
	override function createPost()
	{
		add(tankleft1);
		add(tankleft2);
		add(tankmid);
		add(tankright1);
		add(tankright2);

		if(!ClientPrefs.data.lowQuality)
		{
			for (daGf in gfGroup)
			{
				var gf:Character = cast daGf;
				if(gf.curCharacter == 'pico-speaker')
				{
					var firstTank:TankmenBG = new TankmenBG(20, 500, true);
					firstTank.resetShit(20, 1500, true);
					firstTank.strumTime = 10;
					firstTank.visible = false;
					tankmanRun.add(firstTank);

					for (i in 0...TankmenBG.animationNotes.length)
					{
						if(FlxG.random.bool(16)) {
							var tankBih = tankmanRun.recycle(TankmenBG);
							tankBih.strumTime = TankmenBG.animationNotes[i][0];
							tankBih.resetShit(500, 200 + FlxG.random.int(50, 100), TankmenBG.animationNotes[i][1] < 2);
							tankmanRun.add(tankBih);
						}
					}
					break;
				}
			}
		}
		addAbotPost();
	}
	override function sectionHit() {
		updateABotEye();
	}

	override function startSong() {
		abotSongStart();
	}

	override function countdownTick(count:Countdown, num:Int) if(num % 2 == 0) everyoneDance();
	override function beatHit() everyoneDance();
	function everyoneDance()
	{
		if(!ClientPrefs.data.lowQuality) tankWatchtower.dance();
		/*foregroundSprites.forEach(function(spr:BGSprite)
		{
			spr.dance();
		});*/
		tankleft1.dance();
		tankleft2.dance();
		tankmid.dance();
		tankright1.dance();
		tankright2.dance();
	}

	// Cutscenes
	var cutsceneHandler:CutsceneHandler;
	var tankman:FlxAnimate;
	var pico:FlxAnimate;
	var boyfriendCutscene:FlxSprite;
	var audioPlaying:FlxSound;
	function prepareCutscene()
	{
		cutsceneHandler = new CutsceneHandler();

		dadGroup.alpha = 0.00001;
		camHUD.visible = false;
		//inCutscene = true; //this would stop the camera movement, oops

		tankman = new FlxAnimate(dad.x + 419, dad.y + 225);
		tankman.showPivot = false;
		//Paths.loadAnimateAtlas(tankman, 'cutscenes/tankman');
		Paths.loadAnimateAtlasFromLibrary(tankman, 'cutscenes/tankman', Paths.currentLevel);
		tankman.antialiasing = ClientPrefs.data.antialiasing;
		addBehindDad(tankman);
		cutsceneHandler.push(tankman);

		cutsceneHandler.finishCallback = function()
		{
			game.isCameraOnForcedPos = false;
			var timeForStuff:Float = Conductor.crochet / 1000 * 4.5;
			FlxG.sound.music.fadeOut(timeForStuff);
			FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, timeForStuff, {ease: FlxEase.quadInOut});
			startCountdown();

			dadGroup.alpha = 1;
			camHUD.visible = true;
			boyfriend.animation.finishCallback = null;
			gf.animation.finishCallback = null;
			gf.dance();
		};

		cutsceneHandler.skipCallback = function()
		{
			dadGroup.alpha = 1;
			gfGroup.alpha = 1;
			boyfriendGroup.alpha = 1;
			camHUD.visible = true;

			if(audioPlaying != null)
				audioPlaying.stop();

			boyfriend.animation.finishCallback = null;
			gf.animation.finishCallback = null;
			gf.dance();
			dad.dance();
			boyfriend.dance();

			FlxTween.cancelTweensOf(FlxG.camera);
			FlxTween.cancelTweensOf(camFollow);
			game.moveCameraSection();
			FlxG.camera.scroll.set(camFollow.x - FlxG.width/2, camFollow.y - FlxG.height/2);
			FlxG.camera.zoom = defaultCamZoom;
			startCountdown();
		};
		camFollow.setPosition(dad.x + 280, dad.y + 170);
	}

	function ughIntro()
	{
		game.isCameraOnForcedPos = true;
		prepareCutscene();
		cutsceneHandler.endTime = 12;
		cutsceneHandler.useCurLevel = true;
		cutsceneHandler.music = 'DISTORTO';
		playWeekSound('wellWellWell');
		playWeekSound('killYou');
		playWeekSound('bfBeep');

		var wellWellWell:FlxSound = new FlxSound().loadEmbedded(playWeekSound('wellWellWell'));
		FlxG.sound.list.add(wellWellWell);
		var killYou:FlxSound = new FlxSound().loadEmbedded(playWeekSound('killYou'));
		FlxG.sound.list.add(killYou);

		tankman.anim.addBySymbol('wellWell', 'TANK TALK 1 P1', 24, false);
		tankman.anim.addBySymbol('killYou', 'TANK TALK 1 P2', 24, false);
		tankman.anim.play('wellWell', true);
		FlxG.camera.zoom *= 1.2;

		// Well well well, what do we got here?
		cutsceneHandler.timer(0.1, function()
		{
			wellWellWell.play(true);
			audioPlaying = wellWellWell;
		});

		// Move camera to BF
		cutsceneHandler.timer(3, function()
		{
			camFollow.x += 750;
			camFollow.y += 100;
		});

		// Beep!
		cutsceneHandler.timer(4.5, function()
		{
			boyfriend.playAnim('singUP', true);
			boyfriend.specialAnim = true;
			FlxG.sound.play(playWeekSound('bfBeep'));
		});

		// Move camera to Tankman
		cutsceneHandler.timer(6, function()
		{
			camFollow.x -= 750;
			camFollow.y -= 100;

			// We should just kill you but... what the hell, it's been a boring day... let's see what you've got!
			tankman.anim.play('killYou', true);
			killYou.play(true);
			audioPlaying = killYou;
		});
	}
	function gunsIntro()
	{
		game.isCameraOnForcedPos = true;
		prepareCutscene();
		cutsceneHandler.endTime = 11.5;
		cutsceneHandler.useCurLevel = true;
		cutsceneHandler.music = 'DISTORTO';
		playWeekSound('tankSong2');

		var tightBars:FlxSound = new FlxSound().loadEmbedded(playWeekSound('tankSong2'));
		FlxG.sound.list.add(tightBars);

		tankman.anim.addBySymbol('tightBars', 'TANK TALK 2', 24, false);
		tankman.anim.play('tightBars', true);
		boyfriend.animation.curAnim.finish();

		cutsceneHandler.onStart = function()
		{
			tightBars.play(true);
			audioPlaying = tightBars;
			FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom * 1.2}, 4, {ease: FlxEase.quadInOut});
			FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom * 1.2 * 1.2}, 0.5, {ease: FlxEase.quadInOut, startDelay: 4});
			FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom * 1.2}, 1, {ease: FlxEase.quadInOut, startDelay: 4.5});
		};

		cutsceneHandler.timer(4, function()
		{
			gf.playAnim('sad', true);
			gf.animation.finishCallback = function(name:String)
			{
				gf.playAnim('sad', true);
			};
		});
	}
	var dualWieldAnimPlayed = 0;
	function stressIntro()
	{
		game.isCameraOnForcedPos = true;
		prepareCutscene();
		
		cutsceneHandler.endTime = 35.5;
		gfGroup.alpha = 0.00001;
		boyfriendGroup.alpha = 0.00001;
		camFollow.setPosition(dad.x + 400, dad.y + 170);
		FlxTween.tween(FlxG.camera, {zoom: 0.9 * 1.2}, 1, {ease: FlxEase.quadInOut});
		/*foregroundSprites.forEach(function(spr:BGSprite)
		{
			spr.y += 100;
		});*/
		playWeekSound('stressCutscene');

		pico = new FlxAnimate(gf.x + 150, gf.y + 450);
		pico.showPivot = false;
		//Paths.loadAnimateAtlas(pico, 'cutscenes/picoAppears');
		Paths.loadAnimateAtlasFromLibrary(pico, 'cutscenes/picoAppears', Paths.currentLevel);
		pico.antialiasing = ClientPrefs.data.antialiasing;
		pico.anim.addBySymbol('dance', 'GF Dancing at Gunpoint', 24, true);
		pico.anim.addBySymbol('dieBitch', 'GF Time to Die sequence', 24, false);
		pico.anim.addBySymbol('picoAppears', 'Pico Saves them sequence', 24, false);
		pico.anim.addBySymbol('picoEnd', 'Pico Dual Wield on Speaker idle', 24, false);
		pico.anim.play('dance', true);
		addBehindGF(pico);
		cutsceneHandler.push(pico);

		// prepare pico animation cycle

		picoStress.add(function() {
			switch (pico.anim.curInstance.symbol.name) {
				case "dieBitch", "GF Time to Die sequence":
					pico.anim.play('picoAppears', true);
					boyfriendGroup.alpha = 1;
					boyfriendCutscene.visible = false;
					boyfriend.playAnim('bfCatch', true);
					boyfriend.animation.finishCallback = function(name:String)
					{
						if(name != 'idle')
						{
							boyfriend.playAnim('idle', true);
							boyfriend.animation.curAnim.finish(); //Instantly goes to last frame
						}
					};
				case "picoAppears", "Pico Saves them sequence":
					pico.anim.play('picoEnd', true);
				case "picoEnd", "Pico Dual Wield on Speaker idle":
					gfGroup.alpha = 1;
					pico.visible = false;
					if (pico.anim.onComplete == picoStress) pico.anim.onComplete = new FlxSignal();
			}
		});

		/*
		function picoStressCycle() {
			switch (pico.anim.curInstance.symbol.name) {
				case "dieBitch", "GF Time to Die sequence":
					pico.anim.play('picoAppears', true);
					boyfriendGroup.alpha = 1;
					boyfriendCutscene.visible = false;
					boyfriend.playAnim('bfCatch', true);
					boyfriend.animation.finishCallback = function(name:String)
					{
						if(name != 'idle')
						{
							boyfriend.playAnim('idle', true);
							boyfriend.animation.curAnim.finish(); //Instantly goes to last frame
						}
					};
				case "picoAppears", "Pico Saves them sequence":
					pico.anim.play('picoEnd', true);
				case "picoEnd", "Pico Dual Wield on Speaker idle":
					gfGroup.alpha = 1;
					pico.visible = false;
					if (pico.anim.onComplete == picoStressCycle) pico.anim.onComplete = function() {};
			}
		}
		*/
		pico.anim.onComplete = picoStress;

		boyfriendCutscene = new FlxSprite(boyfriend.x + 5, boyfriend.y + 20);
		boyfriendCutscene.antialiasing = ClientPrefs.data.antialiasing;
		boyfriendCutscene.frames = Paths.getSparrowAtlas('characters/BOYFRIEND');
		boyfriendCutscene.animation.addByPrefix('idle', 'BF idle dance', 24, false);
		boyfriendCutscene.animation.play('idle', true);
		boyfriendCutscene.animation.curAnim.finish();
		addBehindBF(boyfriendCutscene);
		cutsceneHandler.push(boyfriendCutscene);

		var cutsceneSnd:FlxSound = new FlxSound().loadEmbedded(playWeekSound('stressCutscene'));
		FlxG.sound.list.add(cutsceneSnd);

		tankman.anim.addBySymbol('godEffingDamnIt', 'TANK TALK 3 P1 UNCUT', 24, false);
		tankman.anim.addBySymbol('lookWhoItIs', 'TANK TALK 3 P2 UNCUT', 24, false);
		tankman.anim.play('godEffingDamnIt', true);

		cutsceneHandler.onStart = function()
		{
			cutsceneSnd.play(true);
			audioPlaying = cutsceneSnd;
		};

		cutsceneHandler.timer(15.2, function()
		{
			FlxTween.tween(camFollow, {x: 650, y: 300}, 1, {ease: FlxEase.sineOut});
			FlxTween.tween(FlxG.camera, {zoom: 0.9 * 1.2 * 1.2}, 2.25, {ease: FlxEase.quadInOut});
			pico.anim.play('dieBitch', true);
		});

		cutsceneHandler.timer(17.5, function()
		{
			zoomBack();
		});

		cutsceneHandler.timer(19.5, function()
		{
			tankman.anim.play('lookWhoItIs', true);
		});

		cutsceneHandler.timer(20, function()
		{
			camFollow.setPosition(dad.x + 500, dad.y + 170);
		});

		cutsceneHandler.timer(31.2, function()
		{
			boyfriend.playAnim('singUPmiss', true);
			boyfriend.animation.finishCallback = function(name:String)
			{
				if (name == 'singUPmiss')
				{
					boyfriend.playAnim('idle', true);
					boyfriend.animation.curAnim.finish(); //Instantly goes to last frame
				}
			};

			camFollow.setPosition(boyfriend.x + 280, boyfriend.y + 200);
			FlxG.camera.snapToTarget();
			game.cameraSpeed = 12;
			FlxTween.tween(FlxG.camera, {zoom: 0.9 * 1.2 * 1.2}, 0.25, {ease: FlxEase.elasticOut});
		});

		cutsceneHandler.timer(32.2, function()
		{
			zoomBack();
		});
	}

	function zoomBack()
	{
		var calledTimes:Int = 0;
		camFollow.setPosition(630, 425);
		FlxG.camera.snapToTarget();
		FlxG.camera.zoom = 0.8;
		game.cameraSpeed = 1;

		calledTimes++;
		if (calledTimes > 1)
		{
			foregroundSprites.forEach(function(spr:BGSprite)
			{
				spr.y -= 100;
			});
		}
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
	}
