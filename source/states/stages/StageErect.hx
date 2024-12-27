package states.stages;

import states.stages.objects.*;
import objects.Character;
import torchsthings.shaders.AdjustColorShader;
import flash.display.BlendMode;
import substates.GameOverSubstate;
import torchsthings.shaders.*;
import torchsfunctions.functions.ShaderUtils;
import openfl.filters.ShaderFilter;
import torchsthings.objects.ReflectedChar;
class StageErect extends BaseStage
{
    var background:BGSprite;
    var crowd:BGSprite;
    var orange:BGSprite;
    var bg:BGSprite;
    var speaker:BGSprite;
    var lightsmall:BGSprite;
    var light:BGSprite;
    var lightAbove:BGSprite;
    var crt:CRT = new CRT(false, true);
	var shaderFilter:ShaderFilter;
	var gfPixel:Character = null;
	var offsetState:Bool = false; // Literally only here to prevent a crash I found - Torch
    override function create() {

        ratingPos.set(850, 450);
        comboCountPos.set(750, 600);

        offsetState = Std.isOfType(FlxG.state, options.NoteOffsetState);
        background = new BGSprite('rework/Erect/background', 989, -370, 1, 1);
        background.antialiasing =  ClientPrefs.data.antialiasing;
        background.setGraphicSize(Std.int(background.width * 1));
        background.updateHitbox();
        add(background);

        crowd = new BGSprite('rework/Erect/crowd', 700, 190, 0.8, 0.8, ['Symbol 2 instance'], true);
        crowd.antialiasing =  ClientPrefs.data.antialiasing;
        crowd.setGraphicSize(Std.int(crowd.width * 1.2));
        crowd.updateHitbox();
        add(crowd);

        bg = new BGSprite('rework/Erect/bg', -600, -400, 0.9, 0.9);
        bg.antialiasing =  ClientPrefs.data.antialiasing;
        bg.setGraphicSize(Std.int(bg.width * 1.3));
        bg.updateHitbox();
        add(bg);

        orange = new BGSprite('rework/Erect/orangeLight', 100, -200, 1, 1);
        orange.antialiasing =  ClientPrefs.data.antialiasing;
        orange.setGraphicSize(Std.int(orange.width * 1.2));
        orange.updateHitbox();
        add(orange);

        speaker = new BGSprite('rework/Erect/speaker', -201, 205, 1, 1);
        speaker.antialiasing =  ClientPrefs.data.antialiasing;
        speaker.setGraphicSize(Std.int(speaker.width * 0.9));
        speaker.updateHitbox();
        add(speaker);

        lightsmall = new BGSprite('rework/Erect/brightLightSmall', 1500, -200, 0.9, 0.9);
        lightsmall.antialiasing =  ClientPrefs.data.antialiasing;
        lightsmall.setGraphicSize(Std.int(lightsmall.width * 1.2));
        lightsmall.updateHitbox();

        light = new BGSprite('rework/Erect/lights', -401, -247, 0.9, 0.9);
        light.antialiasing =  ClientPrefs.data.antialiasing;
        light.setGraphicSize(Std.int(light.width * 1.2));
        light.updateHitbox();

        lightAbove = new BGSprite('rework/Erect/lightAbove', 1201, -267, 0.9, 0.9);
        lightAbove.antialiasing =  ClientPrefs.data.antialiasing;
        lightAbove.blend = ADD;
        lightAbove.setGraphicSize(Std.int(lightAbove.width * 1.2));
        lightAbove.updateHitbox();
        
        if (!offsetState) {
            switch(PlayState.SONG.song.toLowerCase()) {
                case 'test':
                    gfPixel = new Character(330, 405, 'gf-pixel', true); // Made her a "player" so she would face the other way
                    add(gfPixel);
                    gfPixel.shader = makeCoolShader(-32,0,-33,-23);
                    gfPixel.dance();
            }
        }
     
    }
 
    override function createPost() {
        add(lightsmall);
        add(light);
        add(lightAbove);
        super.createPost();
            gf.shader = makeCoolShader(-9,0,-30,-4);
            dad.shader = makeCoolShader(-32,0,-33,-23);
            boyfriend.shader = makeCoolShader(12,0,-23,7);
            
            if (!offsetState) {
                switch(PlayState.SONG.song.toLowerCase()) {
                    case 'test':
                        gf.x += 450;
                        shaderFilter = new ShaderFilter(crt);
                        ShaderUtils.applyFiltersToCams([camGame, camHUD, camOther], [shaderFilter]);
                        reflectedBF = new ReflectedChar(boyfriend, 0.35);
                        reflectedDad = new ReflectedChar(dad, 0.35);
                        addBehindBF(reflectedBF);
                        addBehindDad(reflectedDad);
                }
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
    var tween:FlxTween;

    override function update(elapsed:Float) {
		crt.update(elapsed);
		if (gfPixel != null) {
			if (gfPixel.animation.name != gf.animation.name) {
				gfPixel.animation.play(gf.animation.name, true);
			}
		}
		if (!offsetState) {
			if (PlayState.SONG.song.toLowerCase() == 'test') {
				if (game.focusedChar == boyfriend) {
					if (tween != null) {
						tween.cancel();
					}
					tween = FlxTween.tween(crt, {middle:0.425}, 2.7, {ease: FlxEase.elasticOut});
				} else {
					if (tween != null) {
						tween.cancel();
					}
					tween = FlxTween.tween(crt, {middle:0.57}, 2.7, {ease: FlxEase.elasticOut});
				}
			}
		}
	}
}
