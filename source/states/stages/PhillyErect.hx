package states.stages;

import states.stages.objects.*;
import objects.Character;
import torchsthings.shaders.AdjustColorShader;

class PhillyErect extends BaseStage
{
    var phillyLightsColors:Array<FlxColor>;
	var phillyWindow:BGSprite;
    var sky:BGSprite;
    var city:BGSprite;
    var street:BGSprite;
    var street2:BGSprite;
    var phillyTrain:PhillyTrain;
    var railings:BGSprite;
    var bridge:BGSprite;
    var car:BGSprite;
	var curLight:Int = -1;

    //For Philly Glow events
	var blammedLightsBlack:FlxSprite;
	var phillyGlowGradient:PhillyGlowGradient;
	var phillyGlowParticles:FlxTypedGroup<PhillyGlowParticle>;
	var phillyWindowEvent:BGSprite;
	var curLightEvent:Int = -1;

    override function create() {
        ratingPos.set(400, 500);
        comboCountPos.set(300, 650);
        comboImage.set( 0, 600);

        if(!ClientPrefs.data.lowQuality) {
            sky = new BGSprite('philly/Erect/sky', -510, -300, 0.1, 0.1);
            sky.setGraphicSize(Std.int(sky.width * 1.05));
            sky.updateHitbox();
            add(sky);
        }

        city = new BGSprite('philly/Erect/city',-400, -130, 0.3, 0.3);
        city.scale.set(1.5, 1.1);
        add(city);
        
        phillyLightsColors = [0xFF03D9FF, 0xFF3AFF3A, 0xFFFF00C8, 0xFFFF0808, 0xFFFF7300, 0xFFFFE606, 0xFF7B08FF];
		phillyWindow = new BGSprite('philly/Erect/windows', city.x, city.y, 0.3, 0.3);
		phillyWindow.scale.set(1.5, 1.1);
		add(phillyWindow);
		phillyWindow.alpha = 0;

        street2 = new BGSprite('philly/Erect/street2', -550, -130, 0.9, 0.9);
        street2.scale.set(1.3, 1.1);
        add(street2);

        railings = new BGSprite('philly/Erect/railings', -510, -130, 0.9, 0.9);
        railings.scale.set(1.3, 1);
        add(railings);

        bridge = new BGSprite('philly/Erect/bridge', -510, -130, 0.9, 0.9);
        bridge.scale.set(1.3, 1);
        add(bridge);

        street = new BGSprite('philly/Erect/street', -810, -230, 0.9, 0.9);
        street.setGraphicSize(Std.int(street.width * 1.3));
        street.updateHitbox();
        add(street);

        car = new BGSprite('philly/Erect/car', -810, 730, 0.9, 0.9);
        car.setGraphicSize(Std.int(car.width * 1.2));
        car.updateHitbox();
    
		abot = new ABotSpeaker(gfGroup.x, gfGroup.y + 310 /*+ 550*/);
    }

    override function createPost() {
        add(car);
        addAbot();
        super.createPost();
		var colorShader = new AdjustColorShader();
        colorShader.hue = -26;
        colorShader.saturation = -16;
        colorShader.contrast = 0;
        colorShader.brightness = -5;

        boyfriend.shader = colorShader;
        gf.shader = colorShader;
        dad.shader = colorShader;
        car.shader = colorShader;
        abot.setShader(colorShader);
    }
    
    override function sectionHit() {
		updateABotEye();
	}

	override function startSong() {
		abotSongStart();
	}
    
    override function eventPushed(event:objects.Note.EventNote) {
        switch(event.event) {
            case "Philly Glow":
                blammedLightsBlack = new FlxSprite(FlxG.width * -0.8, FlxG.height * -0.5).makeGraphic(Std.int(FlxG.width * 3), Std.int(FlxG.height * 2), FlxColor.BLACK);
                blammedLightsBlack.visible = false;
                insert(members.indexOf(street), blammedLightsBlack);

                phillyWindowEvent = new BGSprite('philly/Erect/windows', phillyWindow.x, phillyWindow.y, 0.3, 0.3);
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

    override function update(elapsed:Float) {
        phillyWindow.alpha -= (Conductor.crochet / 1000) * FlxG.elapsed * 1.5;
        if(phillyGlowParticles != null) {
            var i:Int = phillyGlowParticles.members.length-1;
            while (i > 0) {
                var particle = phillyGlowParticles.members[i];
                if(particle.alpha <= 0) {
                    particle.kill();
                    phillyGlowParticles.remove(particle, true);
                    particle.destroy();
                }
                --i;
            }
        }
    }

    override function countdownTick(count:Countdown, num:Int) if(num % 2 == 0) everyoneDance();

    override function beatHit() {       
        abotBeatHit();

        if (curBeat % 4 == 0) {
            curLight = FlxG.random.int(0, phillyLightsColors.length - 1, [curLight]);
            phillyWindow.color = phillyLightsColors[curLight];
            phillyWindow.alpha = 1;
        }
    }

    function everyoneDance() { 
    }

    override function eventCalled(eventName:String, value1:String, value2:String, flValue1:Null<Float>, flValue2:Null<Float>, strumTime:Float) {
        switch(eventName)
        {
            case "Philly Glow":
                if(flValue1 == null || flValue1 <= 0) flValue1 = 0;
                var lightId:Int = Math.round(flValue1);

                var chars:Array<FlxSprite> = [boyfriend, gf, dad];
                if (abot != null) chars.push(abot);
                switch(lightId) {
                    case 0:
                        if(phillyGlowGradient.visible) {
                            doFlash();
                            if(ClientPrefs.data.camZooms) {
                                FlxG.camera.zoom += 0.5;
                                camHUD.zoom += 0.1;
                            }

                            blammedLightsBlack.visible = false;
                            phillyWindowEvent.visible = false;
                            phillyGlowGradient.visible = false;
                            phillyGlowParticles.visible = false;
                            curLightEvent = -1;

                            for (who in chars) {
                                who.color = FlxColor.WHITE;
                            }
                            street.color = FlxColor.WHITE;
                            if(!ClientPrefs.data.lowQuality) {
                                car.color = FlxColor.WHITE;
                            }
                        }
                    case 1: //turn on
                        curLightEvent = FlxG.random.int(0, phillyLightsColors.length-1, [curLightEvent]);
                        var color:FlxColor = phillyLightsColors[curLightEvent];

                        if(!phillyGlowGradient.visible) {
                            doFlash();
                            if(ClientPrefs.data.camZooms) {
                                FlxG.camera.zoom += 0.5;
                                camHUD.zoom += 0.1;
                            }

                            blammedLightsBlack.visible = true;
                            blammedLightsBlack.alpha = 1;
                            phillyWindowEvent.visible = true;
                            phillyGlowGradient.visible = true;
                            phillyGlowParticles.visible = true;
                        } else if(ClientPrefs.data.flashing) {
                            var colorButLower:FlxColor = color;
                            colorButLower.alphaFloat = 0.25;
                            FlxG.camera.flash(colorButLower, 0.5, null, true);
                        }

                        var charColor:FlxColor = color;
                        if(!ClientPrefs.data.flashing) charColor.saturation *= 0.5;
                        else charColor.saturation *= 0.75;

                        for (who in chars) {
                            who.color = charColor;
                        }
                        phillyGlowParticles.forEachAlive(function(particle:PhillyGlowParticle) {
                            particle.color = color;
                        });
                        phillyGlowGradient.color = color;
                        phillyWindowEvent.color = color;

                        color.brightness *= 0.5;
                        street.color = color;
                        if(!ClientPrefs.data.lowQuality) {
                            car.color = color;
                        }
                                
                    case 2: // spawn particles
                        if(!ClientPrefs.data.lowQuality) {
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
        
    function doFlash() {
        var color:FlxColor = FlxColor.WHITE;
        if(!ClientPrefs.data.flashing) color.alphaFloat = 0.5;

        FlxG.camera.flash(color, 0.15, null, true);
    }
}