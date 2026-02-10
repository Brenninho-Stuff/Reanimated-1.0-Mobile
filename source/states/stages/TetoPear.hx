package states.stages;

import states.stages.objects.*;
import objects.VideoSprite;
import flixel.FlxSubState;

class TetoPear extends BaseStage {
    var bgVideo:VideoSprite;

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