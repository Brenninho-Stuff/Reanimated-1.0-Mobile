package states.stages;

import states.stages.objects.*;
import objects.Character;

////import backend.MathUtil;

import torchsthings.shaders.*;
import torchsfunctions.functions.ShaderUtils;
import shaders.RainShader;
import openfl.filters.ShaderFilter;
import torchsthings.objects.effects.ReflectedChar;

class Philly extends BaseStage
{
	var phillyLightsColors:Array<FlxColor>;
	var phillyWindow:BGSprite;
	var phillyStreet:BGSprite;
	var phillyTrain:PhillyTrain;
	var phillyBridge:BGSprite;
	var phillyDownton:BGSprite;
	var phillyPmg:BGSprite;
	var phillyRain:BGSprite;
	var curLight:Int = -1;

	//For Philly Glow events
	var blammedLightsBlack:FlxSprite;
	var phillyGlowGradient:PhillyGlowGradient;
	var phillyGlowParticles:FlxTypedGroup<PhillyGlowParticle>;
	var phillyWindowEvent:BGSprite;
	var curLightEvent:Int = -1;

	var rainShader:RainShader;
	var rainShaderStartIntensity:Float = 0;
	var rainShaderEndIntensity:Float = 0;

	override function create()
	{
		ratingPos.set(400, 500);
        comboCountPos.set(300, 650);
		comboImage.set( 0, 600);

		if(!ClientPrefs.data.lowQuality) {
			var bg:BGSprite = new BGSprite('philly/sky', -510, -300, 0.1, 0.1);
			bg.setGraphicSize(Std.int(bg.width * 1.1));
			bg.updateHitbox();
			add(bg);
			
			var city:BGSprite = new BGSprite('philly/city2',-510, -330, 0.3, 0.3);
			city.setGraphicSize(Std.int(city.width * 1.1));
			city.updateHitbox();
			add(city);
		}

		var edificio:BGSprite = new BGSprite('philly/city', -510, -130, 0.3, 0.3);
		edificio.setGraphicSize(Std.int(edificio.width * 1.1));
		edificio.updateHitbox();
		add(edificio);

		/*var ventanas:BGSprite = new BGSprite('philly/ventanas', -760, -280, 0.3, 0.3);
		ventanas.setGraphicSize(Std.int(ventanas.width * 0.85));
		ventanas.updateHitbox();
		add(ventanas);*/

		phillyLightsColors = [0xFF03D9FF, 0xFF3AFF3A, 0xFFFF00C8, 0xFFFF0808, 0xFFFF7300, 0xFFFFE606, 0xFF7B08FF];
		phillyWindow = new BGSprite('philly/window', edificio.x, edificio.y, 0.3, 0.3);
		phillyWindow.setGraphicSize(Std.int(phillyWindow.width * 1.1));
		phillyWindow.updateHitbox();
		add(phillyWindow);
		phillyWindow.alpha = 0;

		phillyTrain = new PhillyTrain(2000, -160);
		add(phillyTrain);

		phillyBridge = new BGSprite('philly/bridge',-880, -550);
		phillyBridge.setGraphicSize(Std.int(phillyBridge.width * 1.3));
		phillyBridge.updateHitbox();
		add(phillyBridge);
		
		if(!ClientPrefs.data.lowQuality) {
			phillyDownton = new BGSprite('philly/phillyDownton', 140, -380);
			phillyDownton.setGraphicSize(Std.int(phillyDownton.width * 1.3));
			phillyDownton.updateHitbox();
			add(phillyDownton);

			phillyPmg = new BGSprite('philly/car', -910, 660);
			phillyPmg.setGraphicSize(Std.int(phillyPmg.width * 1.2));
			phillyPmg.updateHitbox();
		}

		phillyStreet = new BGSprite('philly/street', -810, 500);
		phillyStreet.setGraphicSize(Std.int(phillyStreet.width * 1.3));
		phillyStreet.updateHitbox();
		add(phillyStreet);

		if(ClientPrefs.data.shaders)
			setupRainShader();
	}

	override function createPost()
		{
			add(phillyPmg);	
			//FlxG.camera.setFilters([new ShaderFilter(rain)]); //I don't know what I did but it worked lol (I do know xd)
			reflectedBF = new ReflectedChar(boyfriend, 0.35);
			addBehindBF(reflectedBF);
			reflectedGF = new ReflectedChar(gf, 0.35);
			addBehindGF(reflectedGF);
			reflectedDad = new ReflectedChar(dad, 0.35);
			addBehindDad(reflectedDad);
		
	}

	function setupRainShader()
		{
			rainShader = new RainShader();
			rainShader.scale = FlxG.height / 200;
			switch (songName)
			{
				case 'pico':
					rainShaderStartIntensity = 0.05;
					rainShaderEndIntensity = 0.1;
				case 'philly-nice':
					rainShaderStartIntensity = 0.1;
					rainShaderEndIntensity = 0.2;
				case 'blammed':
					rainShaderStartIntensity = 0.2;
					rainShaderEndIntensity = 0.35;
			}
			rainShader.intensity = rainShaderStartIntensity;
			FlxG.camera.setFilters([new ShaderFilter(rainShader)]);
		}

	override function eventPushed(event:objects.Note.EventNote)
	{
		switch(event.event)
		{
			case "Philly Glow":
				blammedLightsBlack = new FlxSprite(FlxG.width * -0.8, FlxG.height * -0.5).makeGraphic(Std.int(FlxG.width * 3), Std.int(FlxG.height * 2), FlxColor.BLACK);
				blammedLightsBlack.visible = false;
				insert(members.indexOf(phillyStreet), blammedLightsBlack);

				phillyWindowEvent = new BGSprite('philly/window', phillyWindow.x, phillyWindow.y, 0.3, 0.3);
				phillyWindowEvent.setGraphicSize(Std.int(phillyWindowEvent.width * 1.1));
				phillyWindowEvent.updateHitbox();
				phillyWindowEvent.visible = false;
				insert(members.indexOf(blammedLightsBlack) + 1, phillyWindowEvent);

				phillyGlowGradient = new PhillyGlowGradient(-400, 375); //This shit was refusing to properly load FlxGradient so fuck it
				phillyGlowGradient.visible = false;
				insert(members.indexOf(blammedLightsBlack) + 1, phillyGlowGradient);
				if(!ClientPrefs.data.flashing) phillyGlowGradient.intendedAlpha = 0.7;

				Paths.image('philly/particle'); //precache philly glow particle image
				phillyGlowParticles = new FlxTypedGroup<PhillyGlowParticle>();
				phillyGlowParticles.visible = false;
				insert(members.indexOf(phillyGlowGradient) + 1, phillyGlowParticles);
		}
	}


	override function update(elapsed:Float)
	{
		phillyWindow.alpha -= (Conductor.crochet / 1000) * FlxG.elapsed * 1.5;
		if(phillyGlowParticles != null)
		{
			var i:Int = phillyGlowParticles.members.length-1;
			while (i > 0)
			{
				var particle = phillyGlowParticles.members[i];
				if(particle.alpha <= 0)
				{
					particle.kill();
					phillyGlowParticles.remove(particle, true);
					particle.destroy();
				}
				--i;
			}
		}
		
		if(rainShader != null)
			{
				var remappedIntensityValue:Float = FlxMath.remapToRange(Conductor.songPosition, 0, (FlxG.sound.music != null ? FlxG.sound.music.length : 0), rainShaderStartIntensity, rainShaderEndIntensity);
				rainShader.intensity = remappedIntensityValue;
				rainShader.updateViewInfo(FlxG.width, FlxG.height, FlxG.camera);
				rainShader.update(elapsed);
			}

	}

	override function beatHit()
	{
		phillyTrain.beatHit(curBeat);
		if (curBeat % 4 == 0)
		{
			curLight = FlxG.random.int(0, phillyLightsColors.length - 1, [curLight]);
			phillyWindow.color = phillyLightsColors[curLight];
			phillyWindow.alpha = 1;
		}
	}

	override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float)
	{
		switch(eventName)
		{
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
			case "Philly Glow":
				PlayState.instance.eventExisted = true;
				if(flValue1 == null || flValue1 <= 0) flValue1 = 0;
				var lightId:Int = Math.round(flValue1);

				var chars:Array<Character> = [boyfriend, gf, dad];
				switch(lightId)
				{
					case 0:
						if(phillyGlowGradient.visible)
						{
							doFlash();
							if(ClientPrefs.data.camZooms)
							{
								FlxG.camera.zoom += 0.5;
								camHUD.zoom += 0.1;
							}

							blammedLightsBlack.visible = false;
							phillyWindowEvent.visible = false;
							phillyGlowGradient.visible = false;
							phillyGlowParticles.visible = false;
							curLightEvent = -1;

							for (who in chars)
							{
								who.color = FlxColor.WHITE;
							}
							phillyStreet.color = FlxColor.WHITE;
							reflectedBF.color = FlxColor.WHITE;
                            reflectedGF.color = FlxColor.WHITE;
                            reflectedDad.color = FlxColor.WHITE;
							if(!ClientPrefs.data.lowQuality){
							phillyPmg.color = FlxColor.WHITE;
						}
					}
					case 1: //turn on
						curLightEvent = FlxG.random.int(0, phillyLightsColors.length-1, [curLightEvent]);
						var color:FlxColor = phillyLightsColors[curLightEvent];

						if(!phillyGlowGradient.visible)
						{
							doFlash();
							if(ClientPrefs.data.camZooms)
							{
								FlxG.camera.zoom += 0.5;
								camHUD.zoom += 0.1;
							}

							blammedLightsBlack.visible = true;
							blammedLightsBlack.alpha = 1;
							phillyWindowEvent.visible = true;
							phillyGlowGradient.visible = true;
							phillyGlowParticles.visible = true;
						}
						else if(ClientPrefs.data.flashing)
						{
							var colorButLower:FlxColor = color;
							colorButLower.alphaFloat = 0.25;
							FlxG.camera.flash(colorButLower, 0.5, null, true);
						}

						var charColor:FlxColor = color;
						if(!ClientPrefs.data.flashing) charColor.saturation *= 0.5;
						else charColor.saturation *= 0.75;

						for (who in chars)
						{
							who.color = charColor;
						}
						phillyGlowParticles.forEachAlive(function(particle:PhillyGlowParticle)
						{
							particle.color = color;
						});
						phillyGlowGradient.color = color;
						phillyWindowEvent.color = color;

						color.brightness *= 0.5;
						phillyStreet.color = color;
						reflectedBF.color = color;
                        reflectedGF.color = color;
                        reflectedDad.color = color;
						if(!ClientPrefs.data.lowQuality){
						phillyPmg.color = color;
					}
						

					case 2: // spawn particles
						if(!ClientPrefs.data.lowQuality)
						{
							var particlesNum:Int = FlxG.random.int(8, 12);
							var width:Float = (2000 / particlesNum);
							var color:FlxColor = phillyLightsColors[curLightEvent];
							for (j in 0...3)
							{
								for (i in 0...particlesNum)
								{
									var particle:PhillyGlowParticle = new PhillyGlowParticle(-400 + width * i + FlxG.random.float(-width / 5, width / 5), phillyGlowGradient.originalY + 200 + (FlxG.random.float(0, 125) + j * 40), color);
									phillyGlowParticles.add(particle);
								}
							}
						}
						phillyGlowGradient.bop();
				}

		}
	}

	function doFlash()
	{
		var color:FlxColor = FlxColor.WHITE;
		if(!ClientPrefs.data.flashing) color.alphaFloat = 0.5;

		FlxG.camera.flash(color, 0.15, null, true);
	}
}