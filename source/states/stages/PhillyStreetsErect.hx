package states.stages;

import flixel.FlxBasic;
import states.stages.objects.*;
import flixel.addons.display.FlxBackdrop;
import backend.MathUtil;
import flash.display.BlendMode;
import torchsthings.shaders.*;
import torchsfunctions.functions.ShaderUtils;
import torchsthings.objects.ReflectedChar;
import openfl.filters.ShaderFilter;
import torchsthings.shaders.AdjustColorShader;

class PhillyStreetsErect extends BaseStage
{

    //Stage Objects
    var scrollingSky:FlxBackdrop;
    var mistMid:FlxBackdrop;
    var mistBack:FlxBackdrop;
    var phillySpray:BGSprite;
    var skyline:BGSprite;
    var foregroundcity:BGSprite;
    var highwaylight:BGSprite;
    var construction:BGSprite;
    var highway:BGSprite;
    var foreground:BGSprite;
	var phillyTrafficLightmap:BGSprite;
    var periodicoRandom:FlxSprite;
    var overlay:BGSprite;

    //Cars And Traffic Lights
    var phillyTraffic:FlxSprite;
	var phillyCars:FlxSprite;
	var phillyCarsBack:FlxSprite;
	var lastChange:Int = 0;
	var changeInterval:Int = 8; // make sure it doesnt change until AT LEAST this many beats
	var carWaiting:Bool = false; // if the car is waiting at the lights and is ready to go on green
	var carInterruptable:Bool = true; // if the car can be reset
	var car2Interruptable:Bool = true;
    var lightsStop:Bool = false; // state of the traffic lights
    var greyGradient:BGSprite;

    //Shader
	var rain:Rain;
	var rainFilter:ShaderFilter;
	var useShader:Bool = false;
    var rainTimeScale:Float = 1.0;
	var rainScaler:Float = 0.55;

    override function create() {

        ratingPos.set(1400, 800);
		comboCountPos.set(1300, 950);
		comboImage.set( 0, 900);

		if (ClientPrefs.data.shaders) rain = new Rain();

        //Adding Stage Objects
        scrollingSky = new FlxBackdrop(Paths.image("phillyStreets/erect/phillySkybox"), X);
        scrollingSky.setPosition(-650, -375);
        scrollingSky.scrollFactor.set(0.1, 0.1);
        scrollingSky.scale.set(0.65, 0.65);
        scrollingSky.velocity.x = -22;
        scrollingSky.antialiasing = ClientPrefs.data.antialiasing;
        add(scrollingSky);
 
        skyline = new BGSprite('phillyStreets/erect/phillySkyline', -245, -173, 0.2, 0.2);
        skyline.setGraphicSize(Std.int(skyline.width * 1));
        skyline.updateHitbox();
        add(skyline);
 
        foregroundcity = new BGSprite('phillyStreets/erect/phillyForegroundCity', 825, 94, 0.3, 0.3);
        foregroundcity.setGraphicSize(Std.int(foregroundcity.width * 1));
        foregroundcity.updateHitbox();
        add(foregroundcity);
 
        highwaylight = new BGSprite('phillyStreets/erect/phillyHighwayLights', 284, 185, 1.0, 1.0);
        highwaylight.setGraphicSize(Std.int(highwaylight.width * 1));
        highwaylight.updateHitbox();
        add(highwaylight);
 
        construction  = new BGSprite('phillyStreets/erect/phillyConstruction', 1800, 364, 0.7, 1.0);
        construction.setGraphicSize(Std.int(construction.width * 1));
        construction.updateHitbox();
        add(construction);
      
        highway = new BGSprite('phillyStreets/erect/phillyHighway', 139, 209, 1.0, 1.0);
        highway.setGraphicSize(Std.int(highway.width * 1));
        highway.updateHitbox();
        add(highway);

        var degradado:FlxSprite = new FlxSprite(284, 305).loadGraphic(Paths.image('phillyStreets/phillyHighwayLights_lightmap'));
		degradado.antialiasing = ClientPrefs.data.antialiasing;
		degradado.blend = ADD;
		degradado.scrollFactor.set(1.0, 1.0);
		degradado.updateHitbox();
		//degradado.screenCenter();
		add(degradado);

        phillyCarsBack = new FlxSprite(1748, 818);
		phillyCarsBack.frames = Paths.getSparrowAtlas("phillyStreets/erect/phillyCars");
		phillyCarsBack.scrollFactor.set(0.9, 1);
		phillyCarsBack.antialiasing = true;
		phillyCarsBack.flipX = true;
		phillyCarsBack.animation.addByPrefix("car1", "car1", 0, false);
		phillyCarsBack.animation.addByPrefix("car2", "car2", 0, false);
		phillyCarsBack.animation.addByPrefix("car3", "car3", 0, false);
		phillyCarsBack.animation.addByPrefix("car4", "car4", 0, false);
		add(phillyCarsBack);

        phillyCars = new FlxSprite(1748, 818);
		phillyCars.frames = Paths.getSparrowAtlas("phillyStreets/erect/phillyCars");
		phillyCars.scrollFactor.set(0.9, 1);
		phillyCars.antialiasing = true;
		phillyCars.animation.addByPrefix("car1", "car1", 0, false);
		phillyCars.animation.addByPrefix("car2", "car2", 0, false);
		phillyCars.animation.addByPrefix("car3", "car3", 0, false);
		phillyCars.animation.addByPrefix("car4", "car4", 0, false);
		add(phillyCars);
 
        phillyTraffic = new FlxSprite(1840, 608);
		phillyTraffic.frames = Paths.getSparrowAtlas("phillyStreets/erect/phillyTraffic");
		phillyTraffic.scrollFactor.set(0.9, 1);
		phillyTraffic.antialiasing = true;
		phillyTraffic.animation.addByPrefix("togreen", "redtogreen", 24, false);
		phillyTraffic.animation.addByPrefix("tored", "greentored", 24, false);
		add(phillyTraffic);

        /*phillyTrafficLightmap = new BGSprite('phillyStreets/phillyTraffic_lightmap', 1840, 608, 0.9, 1.0);
        phillyTrafficLightmap.blend = ADD;
		phillyTrafficLightmap.setGraphicSize(Std.int(phillyTrafficLightmap.width * 1));
		phillyTrafficLightmap.updateHitbox();
		add(phillyTrafficLightmap);*/

        greyGradient = new BGSprite('phillyStreets/erect/greyGradient', -150, 100, 0.9, 1.0);
		greyGradient.setGraphicSize(Std.int(greyGradient.width * 1));
		greyGradient.updateHitbox();
        greyGradient.alpha = 0.8;

        mistBack = new FlxBackdrop(Paths.image("phillyStreets/erect/mistBack"), X);
        mistBack.setPosition(0, 205);
        mistBack.blend = ADD;
        mistBack.scrollFactor.set(0.9, 0.9);
        mistBack.scale.set(0.65, 0.65);
        mistBack.velocity.x = 30;
        mistBack.antialiasing = ClientPrefs.data.antialiasing;
        add(mistBack);
		
        var foreground = new BGSprite('phillyStreets/erect/phillyForeground', 380, 380, 1.0, 1.0);
        foreground.scale.set(1.3, 1.2);
        add(foreground);

        mistMid = new FlxBackdrop(Paths.image("phillyStreets/erect/mistMid"), X);
        mistMid.setPosition(0, 395);
        mistMid.blend = ADD;
        mistMid.scrollFactor.set(0.9, 0.9);
        mistMid.scale.set(0.9, 0.9);
        mistMid.velocity.x = 75;
        mistMid.alpha = 0.8;
        mistMid.antialiasing = ClientPrefs.data.antialiasing;

addAbot(100, 355);        //abot = new ABotSpeaker(gfGroup.x, gfGroup.y + 310 /*+ 550*/);

        if(ClientPrefs.data.shaders)
        {
            switch(PlayState.SONG.song.toLowerCase()) {
                case 'darnell-bf-mix':
                rain.setIntenseValues(0.0, 0.04);
                useShader = true;
            }
        }
    }

    override function createPost()
    {   
        super.createPost();
        addAbotPost();
        var colorShader = new AdjustColorShader();
        colorShader.hue = -10;
        colorShader.saturation = 5;
        colorShader.contrast = -30;
        colorShader.brightness = -3;

        boyfriend.shader = colorShader;
        gf.shader = colorShader;
        dad.shader = colorShader;
        if (abot != null) abot.setShader(colorShader);

        if (useShader) 
        {
            rainFilter = new ShaderFilter(rain);
            ShaderUtils.applyFiltersToCams([camGame, camHUD], [rainFilter]);
                    
            /*
            This comment is only here to explain the reflection.
        
            It should look like this:
            reflectedChar = new ReflectedChar(character, alpha, shader);
        
            What it does is takes the data from the character and technically makes a new character. Then it flips it, applies an offset
            to not look weird with the animations, applies the alpha value to make it more transparent/opaque, and then it stores the main 
            character as a variable so that it can update it's animations to match the reflected character.
    
            Make sure to use "addBehindBF", "addBehindGF", and "addBehindDad" instead of "add" so that the reflected character is below the proper character it needs to be.
            */
        
            reflectedBF = new ReflectedChar(boyfriend, 0.35);
            addBehindBF(reflectedBF);
        }
        add(mistMid);
                
        periodicoRandom = new FlxSprite(30, 350);
        periodicoRandom.frames = Paths.getSparrowAtlas("phillyStreets/erect/periodico");
        periodicoRandom.animation.addByPrefix('volandoAndo', 'Paper Blowing instancia 1', 24, false);
        periodicoRandom.antialiasing = ClientPrefs.data.antialiasing;
        periodicoRandom.visible = false;
        add(periodicoRandom);
        add(greyGradient);

    }
    override function sectionHit() {
		updateABotEye();
	}

	override function startSong() {
		abotSongStart();
	}
    function everyoneDance()
        { 
        }
    override function update(elapsed:Float) {
        // Actualizar el shader solo si está habilitado
        if (ClientPrefs.data.shaders) {
            rain.update(elapsed * rainTimeScale);
            rain.lerpRatio = Math.max(0, Conductor.songPosition - ClientPrefs.data.noteOffset) / FlxG.sound.music.length;
            rainTimeScale = MathUtil.coolLerp(rainTimeScale, rainScaler, 0.05);
        }
    }

    var paperBeat:Int = 0;
	var paperOffset:Int = 12;
    override function beatHit() {
        abotBeatHit();

        // Reducir la probabilidad de eventos para mejorar el rendimiento
        if (FlxG.random.bool(5) && curBeat != (lastChange + changeInterval) && carInterruptable) {
            if (!lightsStop) {
                driveCar(phillyCars);
            } else {
                driveCarLights(phillyCars);
            }
        }

        if (FlxG.random.bool(5) && curBeat != (lastChange + changeInterval) && car2Interruptable && !lightsStop) {
            driveCarBack(phillyCarsBack);
        }

        // Cambiar luces solo cuando sea necesario
        if (curBeat == (lastChange + changeInterval)) {
            changeLights(curBeat);
        }

        // Mostrar el periódico con menos frecuencia
        if (FlxG.random.bool(3) && curBeat > paperBeat + paperOffset) {
            if (!periodicoRandom.visible) periodicoRandom.visible = true;
            periodicoRandom.animation.play('volandoAndo');
        }
    }

    function changeLights(beat:Int):Void{
        lastChange = beat;
        lightsStop = !lightsStop;
        
        if(lightsStop) {
            phillyTraffic.animation.play('tored');
            changeInterval = 20;
        } else {
            phillyTraffic.animation.play('togreen');
            changeInterval = 30;
        }
        if(carWaiting == true){ 
            finishCarLights(phillyCars);
        }
    }
        
        
    function resetCar(left:Bool, right:Bool) {
        if(left){
            carWaiting = false;
            carInterruptable = true;
            if (phillyCars != null) {
                FlxTween.cancelTweensOf(phillyCars);
                phillyCars.x = 1200;
                phillyCars.y = 400;
                phillyCars.angle = 0;
            }
        }
        
        if(right){
            car2Interruptable = true;
            if (phillyCarsBack != null) {
                FlxTween.cancelTweensOf(phillyCarsBack);
                phillyCarsBack.x = 1200;
                phillyCarsBack.y = 400;
                phillyCarsBack.angle = 0;
            }
        }
    }
        
    function finishCarLights(sprite:FlxSprite):Void	{
        carWaiting = false;
        var duration:Float = FlxG.random.float(1.8, 3);
        var rotations:Array<Int> = [-5, 18];
        var offset:Array<Float> = [306.6, 168.3];
        var startdelay:Float = FlxG.random.float(0.2, 1.2);
        
        var path:Array<FlxPoint> = [
            FlxPoint.get(1950 - offset[0] - 80, (980 - offset[1] + 15) - 265),
            FlxPoint.get(2400 - offset[0], (980 - offset[1] - 50) - 265),
            FlxPoint.get(3102 - offset[0], (1127 - offset[1] + 40) - 265)
        ];
        
        FlxTween.angle(sprite, rotations[0], rotations[1], duration, {ease: FlxEase.sineIn, startDelay: startdelay} );
        FlxTween.quadPath(sprite, path, duration, true,
        {
            ease: FlxEase.sineIn,
            startDelay: startdelay,
            onComplete: function(_) {
                carInterruptable = true;
            }
        });
    }
    function driveCarLights(sprite:FlxSprite):Void {
        carInterruptable = false;
        FlxTween.cancelTweensOf(sprite);
        var variant:Int = FlxG.random.int(1, 4);
        sprite.animation.play('car' + variant);
        var extraOffset:Array<Int> = [0, 0];
        var duration:Float = 2;
    
        switch(variant) {
            case 1:
                duration = FlxG.random.float(1, 1.7);
            case 2:
                extraOffset = [20, -15];
                duration = FlxG.random.float(0.9, 1.5);
            case 3:
                extraOffset = [30, 50];
                duration = FlxG.random.float(1.5, 2.5);
            case 4:
                extraOffset = [10, 60];
                duration = FlxG.random.float(1.5, 2.5);
        }
    
        var rotations:Array<Int> = [-7, -5];
        var offset:Array<Float> = [306.6, 168.3];
        sprite.offset.set(extraOffset[0], extraOffset[1]);
    
        var path:Array<FlxPoint> = [
            FlxPoint.get(1500 - offset[0] - 20, (1049 - offset[1] - 20) - 265),
            FlxPoint.get(1770 - offset[0] - 80, (994 - offset[1] + 10) - 265),
            FlxPoint.get(1950 - offset[0] - 80, (980 - offset[1] + 15) - 265)
        ];
    
        FlxTween.angle(sprite, rotations[0], rotations[1], duration, {ease: FlxEase.cubeOut});
        FlxTween.quadPath(sprite, path, duration, true,
        {
            ease: FlxEase.cubeOut,
            onComplete: function(_) {
                carWaiting = true;
                if (!lightsStop) finishCarLights(phillyCars);
            }
        });
    }
    
    function driveCar(sprite:FlxSprite):Void {
        carInterruptable = false;
        FlxTween.cancelTweensOf(sprite);

        // Reducir cálculos innecesarios en el switch
        var variant:Int = FlxG.random.int(1, 4);
        sprite.animation.play('car' + variant);

        var extraOffset:Array<Int> = [0, 0];
        var duration:Float = 2;

        switch (variant) {
            case 1: duration = FlxG.random.float(1, 1.7);
            case 2: extraOffset = [20, -15]; duration = FlxG.random.float(0.6, 1.2);
            case 3: extraOffset = [30, 50]; duration = FlxG.random.float(1.5, 2.5);
            case 4: extraOffset = [10, 60]; duration = FlxG.random.float(1.5, 2.5);
        }

        var offset:Array<Float> = [306.6, 168.3];
        sprite.offset.set(extraOffset[0], extraOffset[1]);

        var path:Array<FlxPoint> = [
            FlxPoint.get(1570 - offset[0], (1049 - offset[1] - 30) - 265),
            FlxPoint.get(2400 - offset[0], (980 - offset[1] - 50) - 265),
            FlxPoint.get(3102 - offset[0], (1127 - offset[1] + 40) - 265)
        ];

        FlxTween.angle(sprite, -8, 18, duration, null);
        FlxTween.quadPath(sprite, path, duration, true, {
            ease: null,
            onComplete: function(_) {
                carInterruptable = true;
            }
        });
    }
    
    function driveCarBack(sprite:FlxSprite):Void {
        car2Interruptable = false;
        FlxTween.cancelTweensOf(sprite);
        var variant:Int = FlxG.random.int(1, 4);
        sprite.animation.play('car' + variant);
        var extraOffset:Array<Int> = [0, 0];
        var duration:Float = 2;
    
        switch(variant) {
            case 1:
                duration = FlxG.random.float(1, 1.7);
            case 2:
                extraOffset = [20, -15];
                duration = FlxG.random.float(0.6, 1.2);
            case 3:
                extraOffset = [30, 50];
                duration = FlxG.random.float(1.5, 2.5);
            case 4:
                extraOffset = [10, 60];
                duration = FlxG.random.float(1.5, 2.5);
        }
    
        var offset:Array<Float> = [306.6, 168.3];
        sprite.offset.set(extraOffset[0], extraOffset[1]);
        var rotations:Array<Int> = [18, -8];
        var path:Array<FlxPoint> = [
            FlxPoint.get(3102 - offset[0], (1127 - offset[1] + 60) - 265),
            FlxPoint.get(2400 - offset[0], (980 - offset[1] - 30) - 265),
            FlxPoint.get(1570 - offset[0], (1049 - offset[1] - 10) - 265)
        ];
    
        FlxTween.angle(sprite, rotations[0], rotations[1], duration, null);
        FlxTween.quadPath(sprite, path, duration, true,
        {
            ease: null,
            onComplete: function(_) {
                car2Interruptable = true;
            }
        });
    }
}