package states.stages;

import states.stages.objects.*;
import substates.GameOverSubstate;
import cutscenes.DialogueBox;
import torchsthings.shaders.*;
import torchsfunctions.functions.ShaderUtils;
import openfl.filters.ShaderFilter;
import torchsthings.shaders.AdjustColorShader;
import torchsthings.objects.SpeakerSkin;
import shaders.DropShadowShader;
import shaders.DropShadowScreenspace;

import openfl.utils.Assets as OpenFlAssets;

class SchoolErect extends BaseStage
{
	var bgGirls:BackgroundGirlsErect;
	var crt:CRT = new CRT();
	var shaderFilter:ShaderFilter;
	var speakerTest:SpeakerSkin = null;

	override function create() {
		ratingPos.set(500, 600);
        comboCountPos.set(400, 750);
		comboImage.set( 0, 750);

		var _song = PlayState.SONG;
		if(_song.gameOverSound == null || _song.gameOverSound.trim().length < 1) GameOverSubstate.deathSoundName = 'pixel/fnf_loss_sfx-pixel';
		if(_song.gameOverLoop == null || _song.gameOverLoop.trim().length < 1) GameOverSubstate.loopSoundName = 'pixel/gameOver-pixel';
		if(_song.gameOverEnd == null || _song.gameOverEnd.trim().length < 1) GameOverSubstate.endSoundName = 'pixel/gameOverEnd-pixel';
		if(_song.gameOverChar == null || _song.gameOverChar.trim().length < 1) GameOverSubstate.characterName = 'bf-pixel-dead';

		var bgSky:BGSprite = new BGSprite('weeb/Erect/weebSky', -500, -250, 0.1, 0.1);
		bgSky.setGraphicSize(Std.int(bgSky.width * 0.5));
		add(bgSky);
		bgSky.antialiasing = false;

		var repositionShit = -200;

		var bgSchool:BGSprite = new BGSprite('weeb/Erect/weebSchool', -720, -150, 0.9, 0.9);
		bgSchool.setGraphicSize(Std.int(bgSchool.width * 8.7));
		bgSchool.updateHitbox();
		add(bgSchool);
		bgSchool.antialiasing = false;

		var bgStreet:BGSprite = new BGSprite('weeb/Erect/weebStreet', -695, -150, 0.85, 0.85);
		bgStreet.setGraphicSize(Std.int(bgStreet.width * 8.5));
		bgStreet.updateHitbox();
		add(bgStreet);
		bgStreet.antialiasing = false;

		var widShit = Std.int(bgSky.width * PlayState.daPixelZoom);
		if(!ClientPrefs.data.lowQuality) {
			var fgTrees:BGSprite = new BGSprite('weeb/Erect/weebTreesBack', 400, 450, 0.9, 0.9);
			fgTrees.updateHitbox();
			add(fgTrees);
			fgTrees.antialiasing = false;
			fgTrees.setGraphicSize(Std.int(widShit * 1.5));
		}

		var bgTrees:FlxSprite = new FlxSprite(repositionShit - 1600, -1800);
		bgTrees.frames = Paths.getPackerAtlas('weeb/Erect/weebTrees');
		bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
		bgTrees.animation.play('treeLoop');
		bgTrees.scrollFactor.set(0.85, 0.85);
		add(bgTrees);
		bgTrees.antialiasing = false;

		if(!ClientPrefs.data.lowQuality) {
			var treeLeaves:BGSprite = new BGSprite('weeb/Erect/petals', repositionShit, -40, 0.85, 0.85, ['PETALS ALL'], true);
			treeLeaves.setGraphicSize(widShit);
			treeLeaves.updateHitbox();
			add(treeLeaves);
			treeLeaves.antialiasing = false;
		}

		bgSky.setGraphicSize(Std.int(widShit * 1.8));
		//bgSchool.setGraphicSize(widShit);
		//bgStreet.setGraphicSize(widShit);
		bgTrees.setGraphicSize(Std.int(widShit * 2.5));

		bgSky.updateHitbox();
		bgSchool.updateHitbox();
		bgStreet.updateHitbox();
		bgTrees.updateHitbox();

		if(!ClientPrefs.data.lowQuality) {
			bgGirls = new BackgroundGirlsErect(-750, 290);
			bgGirls.scrollFactor.set(0.9, 0.9);
			applyShader(bgGirls, "");
            if (bgGirls.shader != null && Std.isOfType(bgGirls.shader, DropShadowShader)) {
            cast(bgGirls.shader, DropShadowShader).threshold = 0.1;
			}
			add(bgGirls);
		}
		setDefaultGF('gf-pixel');

		switch(PlayState.SONG.song.toLowerCase()) {
			case 'senpai-pico-mix' | 'roses-pico-mix':
				bgGirls.visible = false;
				defaultSpeaker = 'abot-pixel';
				addSpeaker(gfGroup.x - 150, gfGroup.y + 95);
			/*
				speakerTest = new SpeakerSkin(0, 1000, '', true, 'ABot-pixel');
				add(speakerTest);
			case 'roses-pico-mix':
				bgGirls.visible = false;
				speakerTest = new SpeakerSkin(0, 1000, '', true, 'ABot-pixel');
				add(speakerTest);
			*/
		}

		switch (songName)
		{
			case 'senpai':
				FlxG.sound.playMusic(playWeekMusic('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'roses':
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));
		}
		if(isStoryMode && !seenCutscene)
		{
			if(songName == 'roses') FlxG.sound.play(Paths.sound('ANGRY'));
			initDoof();
			setStartCallback(schoolIntro);
		}
	}

	function makeCoolShader(hue:Float,sat:Float,bright:Float,contrast:Float) {
        var coolShader = new AdjustColorShader();
        coolShader.hue = hue;
        coolShader.saturation = sat;
        coolShader.brightness = bright;
        coolShader.contrast = contrast;
        return coolShader;
    }
	// For events
	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch(eventName)
		{
			case "BG Freaks Expression":
				PlayState.instance.eventExisted = true;
				if(bgGirls != null) bgGirls.swapDanceType();
		}
	}

	var doof:DialogueBox = null;
	function initDoof()
	{
		var file:String = Paths.txt('$songName/${songName}Dialogue_${ClientPrefs.data.language}'); //Checks for vanilla/Senpai dialogue
		#if MODS_ALLOWED
		if (!FileSystem.exists(file))
		#else
		if (!OpenFlAssets.exists(file))
		#end
		{
			file = Paths.txt('$songName/${songName}Dialogue');
		}

		#if MODS_ALLOWED
		if (!FileSystem.exists(file))
		#else
		if (!OpenFlAssets.exists(file))
		#end
		{
			startCountdown();
			return;
		}

		doof = new DialogueBox(false, CoolUtil.coolTextFile(file));
		doof.cameras = [camHUD];
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;
		doof.nextDialogueThing = PlayState.instance.startNextDialogue;
		doof.skipDialogueThing = PlayState.instance.skipDialogue;
	}
	
	function schoolIntro():Void
	{
		inCutscene = true;
		var black:FlxSprite = new FlxSprite(-400, -500).makeGraphic(FlxG.width * 10, FlxG.height * 10, FlxColor.BLACK);
		black.scrollFactor.set();
		FlxG.camera.focusOn(new FlxPoint(650, 600));
		if(songName == 'senpai') add(black);

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha <= 0)
			{
				if (doof != null)
					add(doof);
				else
					startCountdown();

				remove(black);
				black.destroy();
			}
			else tmr.reset(0.3);
		});
	}
	override function createPost() {
		super.createPost();
		/*gf.shader = makeCoolShader(6,15,-30,-16);
        dad.shader = makeCoolShader(6,15,-30,-16);
        boyfriend.shader = makeCoolShader(6,15,-30,-16);*/
		//bgGirls.shader = makeCoolShader(-10,-23,-66, 24);
		applyShader(boyfriend,boyfriend.curCharacter);
		applyShader(gf,gf.curCharacter);
		applyShader(dad,dad.curCharacter);
		if (speaker != null) speaker.setShader(makeCoolShader(-10,-23,-66, 24)); 
		shaderFilter = new ShaderFilter(crt);
		ShaderUtils.applyFiltersToCams([camGame, camHUD, camOther], [shaderFilter]);
	}
	override function beatHit() {
		super.beatHit();
		if(bgGirls != null) bgGirls.dance();
	}
	

	function applyShader(sprite:FlxSprite, char_name:String)
	{
		var rim = new DropShadowShader();
		rim.setAdjustColor(-66, -10, 24, -23);
		rim.color = 0xFF52351d;
		rim.antialiasAmt = 0;
		rim.attachedSprite = sprite;
		rim.distance = 5;
		switch (char_name)
		{
			/*case "bf-pixel":
				{
					rim.angle = 90;
					sprite.shader = rim;

					// rim.loadAltMask('assets/week6/images/weeb/erect/masks/bfPixel_mask.png');
					rim.altMaskImage = Paths.image("weeb/erect/masks/bfPixel_mask").bitmap;
					rim.maskThreshold = 1;
					rim.useAltMask = true;

					sprite.animation.callback = function(anim, frame, index)
					{
						rim.updateFrameInfo(sprite.frame);
					};
				}*/
			case "pico-pixel":
				{
					rim.angle = 90;
					sprite.shader = rim;
					rim.altMaskImage = Paths.image("weeb/Erect/masks/picoPixel_mask").bitmap;
					rim.maskThreshold = 1;
					rim.useAltMask = true;

					sprite.animation.callback = function(anim, frame, index)
					{
						rim.updateFrameInfo(sprite.frame);
					};
				}
			/*case "gf-pixel":
				{
					rim.setAdjustColor(-42, -10, 5, -25);
					rim.angle = 90;
					sprite.shader = rim;
					rim.distance = 3;
					rim.threshold = 0.3;
					rim.altMaskImage = Paths.image("weeb/erect/masks/gfPixel_mask").bitmap;
					rim.maskThreshold = 1;
					rim.useAltMask = true;

					sprite.animation.callback = function(anim, frame, index)
					{
						rim.updateFrameInfo(sprite.frame);
					};
				}*/
			case "nene-pixel":
				{
					rim.setAdjustColor(-42, -10, 5, -25);
					rim.angle = 90;
					sprite.shader = rim;
					rim.distance = 3;
					rim.threshold = 0.3;
					rim.altMaskImage = Paths.image("weeb/Erect/masks/nenePixel_mask").bitmap;
					rim.useAltMask = true;
					sprite.animation.callback = function(anim, frame, index)
					{
						rim.updateFrameInfo(sprite.frame);
					};
				}

			case "senpai" | "senpai-angry":
				{
					rim.angle = 90;
					sprite.shader = rim;
					//rim.altMaskImage = Paths.image("weeb/erect/masks/senpai_mask").bitmap;
					rim.maskThreshold = 1;

					sprite.animation.callback = function(anim, frame, index)
					{
						rim.updateFrameInfo(sprite.frame);
					};
				}
			default:
				{
					rim.angle = 90;
					rim.threshold = 0.1;
					sprite.shader = rim;
					sprite.animation.callback = function(anim, frame, index)
					{
						rim.updateFrameInfo(sprite.frame);
					};
				}
		}
	}
		override function update(elapsed:Float) {
		crt.update(elapsed);
	}

}