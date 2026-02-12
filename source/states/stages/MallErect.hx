package states.stages;

import states.stages.objects.*;
import torchsthings.shaders.AdjustColorShader;
import cutscenes.CutsceneHandler;
import objects.Character;
import states.stages.cutscenes.CutsceneMallErect;

class MallErect extends BaseStage
{
	var upperBoppers:BGSprite;
	var bottomBoppers:MallCrowdErect;
	var tree:BGSprite;
	public var santa:BGSprite;
	var snowfallin:BGSprite;
    var blackScreen:FlxSprite;

	var colorShader:AdjustColorShader;
	override function create()
	{
		ratingPos.set(550, 450);
        comboCountPos.set(450, 600);
		comboImage.set(0, 550);

		var bg:BGSprite = new BGSprite('christmas/erect/bgWalls', -1150, -850, 0.2, 0.2);
		bg.setGraphicSize(Std.int(bg.width * 1.8));
		bg.updateHitbox();
		add(bg);

		var ceiling:BGSprite = new BGSprite('christmas/erect/Ceiling', -1150, -850, 0.2, 0.2);
		ceiling.setGraphicSize(Std.int(ceiling.width * 1.8));
		ceiling.updateHitbox();
		add(ceiling);

		if(!ClientPrefs.data.lowQuality) {
			upperBoppers = new BGSprite('christmas/erect/upperBop', -600, -320, 0.33, 0.33, ['upperBop0']);
			upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 1.05));
			upperBoppers.updateHitbox();
			add(upperBoppers);

			var bgEscalator:BGSprite = new BGSprite('christmas/erect/bgEscalator', -1100, -400, 0.3, 0.3);
			bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 1.9));
			bgEscalator.updateHitbox();
			add(bgEscalator);

			snowfallin = new BGSprite('christmas/erect/snowfallin_bg', -1120, -650, 0.9, 0.9, ['snowfallin0'], true);
			snowfallin.setGraphicSize(Std.int(snowfallin.width * 2.6));
			snowfallin.updateHitbox();
	
		}

		var blanck:BGSprite = new BGSprite('christmas/erect/white', -1250, -350, 0.9, 0.9);
		//blanck.blend = ADD;
		blanck.setGraphicSize(Std.int(blanck.width * 1.8));
		blanck.updateHitbox();
		add(blanck);

		var fgSnow:BGSprite = new BGSprite('christmas/erect/fgSnow', -1500, 440, 0.9, 0.9);
		fgSnow.setGraphicSize(Std.int(fgSnow.width * 2));
		fgSnow.updateHitbox();
		add(fgSnow);

		tree = new BGSprite('christmas/erect/christmasTree', 370, -650, 0.9, 0.9, ['Christmas Tree']);
		tree.scale.set(1.3, 1.3);
		add(tree);

		bottomBoppers = new MallCrowdErect(-400, 100);
		add(bottomBoppers);

		santa = new BGSprite('christmas/erect/santa', -840, 150, 1, 1, ['santa idle in fear']);
		Paths.sound('mall/Lights_Shut_off');

		setDefaultGF('gf-christmas');

		//addAbot(100, 355);
		if (PlayState.SONG.song.toLowerCase().contains('pico-mix')) {
			defaultSpeaker = 'abot';
            addSpeaker(gfGroup.x + 100, gfGroup.y + 355);
		}
		if (!isStoryMode)
			if (PlayState.SONG.song.toLowerCase() == "eggnog")
			{
				setEndCallback(new CutsceneMallErect(this).eggnogErectCutscene);
			}
		if(isStoryMode && !seenCutscene)
			setEndCallback(eggnogEndCutscene);
	}

	override function createPost() {	
		add(santa);
		add(snowfallin);
		super.createPost();

		boyfriend.shader = makecolorShader(-20,-15,0,-10);
		gf.shader = makecolorShader(-20,-15,0,-10);
		dad.shader = makecolorShader(-20,-15,0,-10);
		if (speaker != null) speaker.setShader(makecolorShader(-20,-15,0,-10)); 
	}
	override function countdownTick(count:Countdown, num:Int) everyoneDance();
	override function beatHit() {
		super.beatHit();
		everyoneDance();
	}
	function setShader(char:FlxSprite, charName:String)
{
    if (ClientPrefs.data.shaders) {
        switch(charName.toLowerCase()) {
            case 'gf', 'girlfriend', '2':
                char.shader = makecolorShader(-20,-15,0,-10);
            case 'dad', 'opponent', '1':
                char.shader = makecolorShader(-20,-15,0,-10);
            default:
                char.shader = makecolorShader(-20,-15,0,-10);
        }
    } else {
        char.shader = null;
    }
}
	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float) {
		switch(eventName) {
			case "Change Character":
            ClientPrefs.data.shaders;
			switch(value1.toLowerCase().trim()) {
				case 'gf' | 'girlfriend' | '2':
					setShader(gf, gf.curCharacter);
				case 'dad' | 'opponent' | '1':
					setShader(dad, dad.curCharacter);
				default:
					setShader(boyfriend, boyfriend.curCharacter);
			}
			case "Hey!":
				switch(value1.toLowerCase().trim()) {
					case 'bf' | 'boyfriend' | '0':
						return;
				}
		}
	}

	function everyoneDance() {
		if(!ClientPrefs.data.lowQuality)
			bottomBoppers.dance(true);
			upperBoppers.dance(true);
			tree.dance(true);
			santa.dance(true);
	}

	function eggnogEndCutscene() {
		if(PlayState.storyPlaylist[1] == null) {
			endSong();
			return;
		}

		var nextSong:String = Paths.formatToSongPath(PlayState.storyPlaylist[1]);
		if(nextSong == 'winter-horrorland') {
			FlxG.sound.play(Paths.sound('mall/Lights_Shut_off'));

			var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
                -FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
			blackShit.scrollFactor.set();
			add(blackShit);
			snowfallin.visible = false;
			santa.visible = false;
			camHUD.visible = false;

			inCutscene = true;
			canPause = false;

			new FlxTimer().start(1.5, function(tmr:FlxTimer) {
				endSong();
			});
		}
		else endSong();
	}

	public function makecolorShader(hue:Float,sat:Float,bright:Float,contrast:Float) {
        colorShader = new AdjustColorShader();
        colorShader.hue = hue;
        colorShader.saturation = sat;
        colorShader.brightness = bright;
        colorShader.contrast = contrast;
        return colorShader;
    }
}