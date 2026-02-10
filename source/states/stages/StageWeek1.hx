package states.stages;

import states.stages.objects.*;
import objects.Character;
import torchsthings.shaders.*;
import torchsthings.shaders.AdjustColorShader;
import torchsfunctions.functions.ShaderUtils;
import openfl.filters.ShaderFilter;
import torchsthings.objects.effects.ReflectedChar;
import torchsthings.objects.SpeakerSkin;
import substates.GameOverSubstate;

class StageWeek1 extends BaseStage
{
	var dadbattleLight:BGSprite;
	var dadbattleFog:DadBattleFog;
	var crt:CRT = new CRT(false, true);
	var shaderFilter:ShaderFilter;
	var gfPixel:Character = null;
	var offsetState:Bool = false; // Literally only here to prevent a crash I found - Torch
	//var reflectedBF:ReflectedChar;
	//var reflectedDad:ReflectedChar;

	//base
	var bg:BGSprite;
	var stageFront:BGSprite;
	var stagelittlelights:BGSprite;
	var stageCurtains:BGSprite;
	var stageColumns:BGSprite;
	//event
	var bgGlow:BGSprite;
	var stageFrontGlow:BGSprite;
	var stagelittlelightsGlow:BGSprite;
	var stageCurtainsGlow:BGSprite;
	var stageColumnsGlow:BGSprite;
	var colorShader:AdjustColorShader;

	override function create()
	{
		ratingPos.set(850, 450);
        comboCountPos.set(750, 600);
		comboImage.set( 0, 550);

		offsetState = Std.isOfType(FlxG.state, options.NoteOffsetState);

		bgGlow = new BGSprite('rework/event/stageback', -650, -300, 0.9, 0.9);
		bgGlow.setGraphicSize(Std.int(bgGlow.width * 1.5));
		bgGlow.updateHitbox();
		bgGlow.visible = false;
		add(bgGlow);

		bg = new BGSprite('rework/stageback', -650, -300, 0.9, 0.9);
		bg.setGraphicSize(Std.int(bg.width * 1.5));
		bg.updateHitbox();
		bg.visible = true;
		add(bg);

		stageFrontGlow = new BGSprite('rework/event/stagefront', -650, -300, 0.9, 0.9);
		stageFrontGlow.setGraphicSize(Std.int(stageFrontGlow.width * 1.5));
		stageFrontGlow.updateHitbox();
		stageFrontGlow.visible = false;
		add(stageFrontGlow);

		stageFront = new BGSprite('rework/stagefront', -650, -300, 0.9, 0.9);
		stageFront.setGraphicSize(Std.int(stageFront.width * 1.5));
		stageFront.updateHitbox();
		stageFront.visible = true;
		add(stageFront);
		if(!ClientPrefs.data.lowQuality) {
					/*var stageHorns:BGSprite = new BGSprite('Altavoces', -200, 400, 0.9, 0.9);
					stageHorns.setGraphicSize(Std.int(stageHorns.width * 2.1));
					stageHorns.updateHitbox();
					add(stageHorns);*/

					stagelittlelightsGlow = new BGSprite('rework/event/stage_light',  -550, -500, 1.0, 1.0);
					stagelittlelightsGlow.scale.set(1.45, 1.5);
					stagelittlelightsGlow.updateHitbox();
					stagelittlelightsGlow.visible = false;
					add(stagelittlelightsGlow);

					stagelittlelights = new BGSprite('rework/stage_light',  -550, -500, 1.0, 1.0);
					stagelittlelights.scale.set(1.45, 1.5);
					stagelittlelights.updateHitbox();
					stagelittlelights.visible = true;
					add(stagelittlelights);

					stageCurtainsGlow = new BGSprite('rework/event/stagecurtains',  -550, -460, 1.1, 1.1);
					stageCurtainsGlow.scale.set(1.4, 1.5);
					stageCurtainsGlow.updateHitbox();
					stageCurtainsGlow.visible = false;
					add(stageCurtainsGlow);

					stageCurtains = new BGSprite('rework/stagecurtains',  -550, -460, 1.1, 1.1);
					stageCurtains.scale.set(1.4, 1.5);
					stageCurtains.updateHitbox();
					stageCurtains.visible = true;
					add(stageCurtains);
		}
		
		stageColumnsGlow = new BGSprite('rework/event/stagecolumns', -550, -250, 1.2, 1.2);
		stageColumnsGlow.scale.set(1.4, 1.3);
		stageColumnsGlow.updateHitbox();
		stageColumnsGlow.visible = false;
		add(stageColumnsGlow);

		stageColumns = new BGSprite('rework/stagecolumns', -550, -250, 1.2, 1.2);
		stageColumns.scale.set(1.4, 1.3);
		stageColumns.updateHitbox();
		stageColumns.visible = true;
		add(stageColumns);

		if (!offsetState) {
			switch(PlayState.SONG.song.toLowerCase()) {
				case 'test':
					gfPixel = new Character(330, 335, 'gf-pixel', true); // Made her a "player" so she would face the other way
					add(gfPixel);
					gfPixel.dance();
			}
		}
	}

	override function createPost() {
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
		super.createPost();
	}

	var tween:FlxTween;

	function makecolorShader(hue:Float, sat:Float, bright:Float, contrast:Float) {
		colorShader = new AdjustColorShader();
		colorShader.hue = hue;
		colorShader.saturation = sat;
		colorShader.brightness = bright;
		colorShader.contrast = contrast;
		return colorShader;
	}

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
				if (!torchsthings.objects.CustomEvents.stageEvents.contains("Dadbattle Spotlight")) torchsthings.objects.CustomEvents.stageEvents.push("Dadbattle Spotlight");

				dadbattleLight = new BGSprite('spotlight', 400, 100);
				dadbattleLight.alpha = 0.375;
				dadbattleLight.blend = ADD;
				dadbattleLight.visible = false;
				add(dadbattleLight);

				dadbattleFog = new DadBattleFog();
				dadbattleFog.visible = false;
				add(dadbattleFog);
		}
	}

	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch(eventName)
		{
			case "Dadbattle Spotlight":
				PlayState.instance.eventExisted = true;
				if(flValue1 == null) flValue1 = 0;
				var val:Int = Math.round(flValue1);

				switch(val)
				{
					case 1, 2, 3: //enable and target dad
						if(val == 1) //enable
						{
							dadbattleLight.visible = true;
							dadbattleFog.visible = true;
							bgGlow.visible = true;
							stageFrontGlow.visible = true;
							stagelittlelightsGlow.visible = true;
							stageCurtainsGlow.visible = true;
							stageColumnsGlow.visible = true;

							bg.visible = false;
							stageFront.visible = false;
							stagelittlelights.visible = false;
							stageCurtains.visible = false;
							stageColumns.visible = false;
							defaultCamZoom += 0.12;
							
							// Cambiar colores con AdjustColorShader
							gf.shader = makecolorShader(-35, -35, -60, 10);
							dad.shader = makecolorShader(-35, -35, -60, 10);
							boyfriend.shader = makecolorShader(-35, -35, -60, 10);
							if (speaker != null) speaker.setShader(makecolorShader(-35, -35, -60, 10));
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
						FlxTween.tween(dadbattleFog, {alpha: 0.7}, 1.5, {ease: FlxEase.quadInOut});

					default:
						dadbattleLight.visible = false;
						bgGlow.visible = false;
						stageFrontGlow.visible = false;
						stagelittlelightsGlow.visible = false;
						stageCurtainsGlow.visible = false;
						stageColumnsGlow.visible = false;

						bg.visible = true;
						stageFront.visible = true;
						stagelittlelights.visible = true;
						stageCurtains.visible = true;
						stageColumns.visible = true;
						defaultCamZoom -= 0.12;
						FlxTween.tween(dadbattleFog, {alpha: 0}, 0.7, {onComplete: function(twn:FlxTween) dadbattleFog.visible = false});
						
						// Restaurar colores originales
						gf.shader = null;
						dad.shader = null;
						boyfriend.shader = null;
						if (speaker != null) speaker.setShader(null);
				}
			case "Change Character":
				if (value1.toLowerCase() == "bf" || value1.toLowerCase() == "boyfriend" || value1.toLowerCase() == "player") {
					reflectedBF.destroy();
					reflectedBF = new ReflectedChar(boyfriend, 0.35);
					addBehindBF(reflectedBF);
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
}