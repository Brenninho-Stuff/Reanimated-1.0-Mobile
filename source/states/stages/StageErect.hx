package states.stages;

import states.stages.objects.*;
import objects.Character;
import torchsthings.shaders.AdjustColorShader;
import flash.display.BlendMode;
import substates.GameOverSubstate;
import torchsthings.shaders.*;
import torchsfunctions.functions.ShaderUtils;
import openfl.filters.ShaderFilter;
import torchsthings.objects.effects.ReflectedChar;
import flixel.addons.display.FlxBackdrop;
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

    //event lol
    var dadbattleLight:BGSprite;
	var dadbattleBlack:BGSprite;
    var mist1:FlxBackdrop;
    var mist2:FlxBackdrop;

    override function create() {

        ratingPos.set(850, 450);
        comboCountPos.set(750, 600);
		comboImage.set( 0, 550);

        offsetState = Std.isOfType(FlxG.state, options.NoteOffsetState);
        background = new BGSprite('rework/Erect/background', 989, -370, 1, 1);
        background.antialiasing =  ClientPrefs.data.antialiasing;
        background.setGraphicSize(Std.int(background.width * 1));
        background.updateHitbox();
        add(background);

        crowd = new BGSprite('rework/Erect/crowd', 700, 190, 0.8, 0.8, ['Symbol 2 instance'], true);
        crowd.antialiasing =  ClientPrefs.data.antialiasing;
        crowd.animation.curAnim.frameRate = 12;
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
        
        addAbot(100, 355);
        //abot = new ABotSpeaker(gfGroup.x, gfGroup.y + 310 /*+ 550*/);

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
        addAbotPost();
        //Color Shader2 es Para el Abot lol
        gf.shader = makeCoolShader(-9,0,-30,-4);
        dad.shader = makeCoolShader(-32,0,-33,-23);
        boyfriend.shader = makeCoolShader(12,0,-23,7);
        if (abot != null) abot.setShader(makeCoolShader(-9, 0, -30, -4));
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
    override function sectionHit() {
        updateABotEye();
    }
    
     override function startSong() {
         abotSongStart();
    }

    override function countdownTick(count:Countdown, num:Int) if(num % 2 == 0) everyoneDance();
    override function beatHit()
        {       
            abotBeatHit();
        }
        function everyoneDance()
            { 
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
    override function eventPushed(event:objects.Note.EventNote)
        {
            switch(event.event)
            {
                case "Dadbattle Spotlight":
                    dadbattleBlack = new BGSprite(null, -800, -400, 0, 0);
                    dadbattleBlack.makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
                    dadbattleBlack.alpha = 0.45;
                    dadbattleBlack.visible = false;
                    add(dadbattleBlack);
    
                    dadbattleLight = new BGSprite('rework/spotlight_Alt', 400);
                    dadbattleLight.alpha = 0.375;
                    dadbattleLight.blend = ADD;
                    dadbattleLight.visible = false;
                    add(dadbattleLight);

                    mist2 = new FlxBackdrop(Paths.image("rework/Erect/mistMid"), X);
                    mist2.setPosition(0, 25);
                    mist2.blend = ADD;
                    mist2.scrollFactor.set(0.9, 0.9);
                    mist2.scale.set(0.9, 0.9);
                    mist2.velocity.x = 30;
                    mist2.alpha = 0.8;
                    mist2.visible = false;
                    mist2.antialiasing = ClientPrefs.data.antialiasing;
                    add(mist2);
            }
        }
    
        override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
        {
            switch(eventName)
            {
                case "Dadbattle Spotlight":
                    if(flValue1 == null) flValue1 = 0;
                    var val:Int = Math.round(flValue1);
    
                    switch(val)
                    {
                        case 1, 2, 3: //enable and target dad
                            if(val == 1) //enable
                            {
                                dadbattleBlack.visible = true;
                                dadbattleLight.visible = true;
                                mist2.visible = true;
                                defaultCamZoom += 0.12;
                            }
    
                            var who:Character = dad;
                            if(val > 2) who = boyfriend;
                            //2 only targets dad
                            dadbattleLight.alpha = 0;
                            new FlxTimer().start(0.12, function(tmr:FlxTimer) {
                                dadbattleLight.alpha = 0.375;
                            });
                            // frameHeight grabs the proper pixel height for the frame, not just the actual height of the object
                            dadbattleLight.setPosition(who.getGraphicMidpoint().x - dadbattleLight.width / 2, who.y + /*who.height*/ who.frameHeight - dadbattleLight.height + 50);   
                            FlxTween.tween(mist2, {alpha: 0.7}, 1.5, {ease: FlxEase.quadInOut});
                        default:
                            dadbattleBlack.visible = false;
                            dadbattleLight.visible = false;
                            mist2.visible = false;
                            defaultCamZoom -= 0.12;
                            FlxTween.tween(mist2, {alpha: 0}, 0.7, {onComplete: function(twn:FlxTween) mist2.visible = false});

                    }
                }
            }
}
