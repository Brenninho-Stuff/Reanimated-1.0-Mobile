package states.stages;

import flixel.util.FlxColor;
import flixel.FlxG;
import states.stages.objects.*;
import objects.VideoSprite;
import flixel.FlxSubState;

class TetoPear extends BaseStage {
    var bgVideo:VideoSprite;
	var blackScreen:FlxSprite;

    override function create() {
        super.create();

        // Replace "myBackgroundVideo" with the name of your video file (see Paths.video)
        var n = Paths.video("Machine Love");
        // last parameter `true` makes the video loop
        bgVideo = new VideoSprite(n, false, false, true);
        bgVideo.setPosition(0, 0);
        bgVideo.setSize(FlxG.width, FlxG.height); // Cover the entire screen
        bgVideo.updateHitbox();
        bgVideo.cameras = [camHUD]; // Use HUD camera so it doesn't move with game camera
        add(bgVideo);
        // don't play immediately — start after the countdown (see countdownTick override)
		blackScreen = new FlxSprite(-600,-570).makeGraphic(Std.int(FlxG.width * 3), Std.int(FlxG.height * 3), FlxColor.BLACK);
        blackScreen.alpha = 1;
		blackScreen.scrollFactor.set();
		if (camOther != null) blackScreen.cameras = [camOther];
		FlxTween.tween(blackScreen, {alpha: 0}, 10, {ease: FlxEase.expoInOut,startDelay: 0.5});

	}

	 override function createPost()
    { 
        // Hide opponent notes
		for (i in 0...4) {
		PlayState.instance.playerStrums.members[i].x = 365 + (110 * i);
		PlayState.instance.playerStrums.members[i].x += 50;
		PlayState.instance.defaultStrumPosition[i + 4][0] = 365 + (110 * i) + 50;
		PlayState.instance.opponentStrums.members[i].x = -5000;
		PlayState.instance.opponentStrums.members[i].visible = false;
		PlayState.instance.defaultStrumPosition[i][0] = -5000;
		}
		PlayState.instance.iconP1.visible = false;
        PlayState.instance.iconP2.visible = false;
		PlayState.instance.healthBar.visible = false;
		PlayState.instance.timeBar.visible = false;
		PlayState.instance.timeTxt.visible = false;

		if (blackScreen != null) add(blackScreen);
    }

	override function openSubState(SubState:FlxSubState) {
		if (bgVideo != null) bgVideo.pause();
		super.openSubState(SubState);
	}

	override function closeSubState() {
		super.closeSubState();
		if (bgVideo != null) bgVideo.resume();
	}

	override function startSong() {
		super.startSong();
		if (bgVideo == null) return;

		// ensure video uses HUD camera so it covers the screen without affecting game camera
		try {
			bgVideo.cameras = [camHUD];
		} catch(e:Dynamic) {}

		// try to mute video audio 
		#if hxvlc
		try {
			var bmp = bgVideo.videoSprite.bitmap;
			if (Reflect.hasField(bmp, "setVolume")) {
				var f = Reflect.field(bmp, "setVolume");
				Reflect.callMethod(bmp, f, [0]);
			}
		} catch(e:Dynamic) {}
		#end

		// attempt to sync video to music time
		try {
			var musicTime:Float = (FlxG.sound.music != null) ? FlxG.sound.music.time : 0;
			var bmp = bgVideo.videoSprite.bitmap;
			if (Reflect.hasField(bmp, "setTime")) {
				Reflect.callMethod(bmp, Reflect.field(bmp, "setTime"), [musicTime]);
			}
		} catch(e:Dynamic) {}

		// start playback
		try { bgVideo.play(); } catch(e:Dynamic) {}
	}

    override function destroy() {
        if (bgVideo != null) {
            bgVideo.destroy();
            bgVideo = null;
        }
        super.destroy();
    }
}