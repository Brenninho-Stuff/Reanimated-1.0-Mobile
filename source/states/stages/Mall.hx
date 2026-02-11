package states.stages;

import states.stages.objects.*;

class Mall extends BaseStage
{

	var upperBoppers:BGSprite;
	var bottomBoppers:MallCrowd;
	var santa:BGSprite;
	
	override function create()
	{
		ratingPos.set(550, 450);
        comboCountPos.set(450, 600);
		comboImage.set( 0, 550);

		var bg:BGSprite = new BGSprite('christmas/bgWalls', -1900, -1000, 0.2, 0.2);
		bg.setGraphicSize(Std.int(bg.width * 1.2));
		bg.updateHitbox();
		add(bg);

		if(!ClientPrefs.data.lowQuality) {
			upperBoppers = new BGSprite('christmas/upperBop', -750, -260, 0.33, 0.33, ['Upper Crowd Bob']);
			upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 1.2));
			upperBoppers.updateHitbox();
			add(upperBoppers);

			var bgEscalator:BGSprite = new BGSprite('christmas/bgEscalator', -1800, -900, 0.3, 0.3);
			bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 1.2));
			bgEscalator.updateHitbox();
			add(bgEscalator);
		}

			var tree:BGSprite = new BGSprite('christmas/christmasTree', 200, -400, 0.40, 0.40);
			tree.setGraphicSize(Std.int(tree.width * 1.3));
			tree.updateHitbox();
			add(tree);

		bottomBoppers = new MallCrowd(-300, 140);
		bottomBoppers.scrollFactor.set(0.9, 0.9);
		bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1.1));
		bottomBoppers.updateHitbox();
		add(bottomBoppers);

		var fgSnow:BGSprite = new BGSprite('christmas/fgSnow', -2000, 880);
		fgSnow.scale.set(2.0, 3.0);
		add(fgSnow);

		santa = new BGSprite('christmas/santa', -840, 150, 1, 1, ['santa idle in fear']);

		Paths.sound('mall/Lights_Shut_off');
		setDefaultGF('gf-christmas');

		//addAbot(100, 355);
		if (PlayState.SONG.song.toLowerCase().contains('pico-mix')) {
			defaultSpeaker = 'abot';
			//addSpeaker(100, 355);
            addSpeaker(gfGroup.x + 100, gfGroup.y + 355);
		}
		
		if(isStoryMode && !seenCutscene)
			setEndCallback(eggnogEndCutscene);
	}

	override function createPost() {
		add(santa);
		super.createPost();
	}


	override function countdownTick(count:Countdown, num:Int) everyoneDance();
	override function beatHit() everyoneDance();

	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch(eventName)
		{
			case "Hey!":
				switch(value1.toLowerCase().trim()) {
					case 'bf' | 'boyfriend' | '0':
						return;
				}
				bottomBoppers.animation.play('hey', true);
				bottomBoppers.heyTimer = flValue2;
		}
	}

	function everyoneDance()
	{
		if(!ClientPrefs.data.lowQuality)
			upperBoppers.dance(true);

		bottomBoppers.dance(true);
		santa.dance(true);
	}

	function eggnogEndCutscene()
	{
		if(PlayState.storyPlaylist[1] == null)
		{
			endSong();
			return;
		}

		var nextSong:String = Paths.formatToSongPath(PlayState.storyPlaylist[1]);
		if(nextSong == 'winter-horrorland')
		{
			FlxG.sound.play(Paths.sound('mall/Lights_Shut_off'));

			var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
				-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
			blackShit.scrollFactor.set();
			add(blackShit);
			camHUD.visible = false;

			inCutscene = true;
			canPause = false;

			new FlxTimer().start(1.5, function(tmr:FlxTimer) {
				endSong();
			});
		}
		else endSong();
	}
}