package states.stages;

import states.stages.objects.*;
import torchsthings.shaders.AdjustColorShader;
import flash.display.BlendMode;
import substates.GameOverSubstate;

class Week1Erect extends BaseStage
{
    var background:BGSprite;
    var crowd:BGSprite;
    var orange:BGSprite;
    var bg:BGSprite;
    var speaker:BGSprite;
    var lightsmall:BGSprite;
    var light:BGSprite;
    var lightAbove:BGSprite;
    override function create() {

        background = new BGSprite('rework/Erect/background', 989, -370, 1, 1);
        background.setGraphicSize(Std.int(background.width * 1));
        background.updateHitbox();
        add(background);

        crowd = new BGSprite('rework/Erect/crowd', 700, 190, 0.8, 0.8, ['Symbol 2 instance'], true);
        crowd.setGraphicSize(Std.int(crowd.width * 1.2));
        crowd.updateHitbox();
        add(crowd);

        bg = new BGSprite('rework/Erect/bg', -600, -400, 0.9, 0.9);
        bg.setGraphicSize(Std.int(bg.width * 1.3));
        bg.updateHitbox();
        add(bg);

          orange = new BGSprite('rework/Erect/orangeLight', 100, -200, 1, 1);
        orange.setGraphicSize(Std.int(orange.width * 1.2));
        orange.updateHitbox();
        add(orange);

        speaker = new BGSprite('rework/Erect/speaker', -201, 205, 1, 1);
        speaker.setGraphicSize(Std.int(speaker.width * 0.9));
        speaker.updateHitbox();
        add(speaker);

        lightsmall = new BGSprite('rework/Erect/brightLightSmall', 1500, -200, 0.9, 0.9);
        lightsmall.setGraphicSize(Std.int(lightsmall.width * 1.2));
        lightsmall.updateHitbox();

        light = new BGSprite('rework/Erect/lights', -401, -247, 0.9, 0.9);
        light.setGraphicSize(Std.int(light.width * 1.2));
        light.updateHitbox();

        lightAbove = new BGSprite('rework/Erect/lightAbove', 1201, -267, 0.9, 0.9);
        lightAbove.blend = ADD;
        lightAbove.setGraphicSize(Std.int(lightAbove.width * 1.2));
        lightAbove.updateHitbox();
     
    }
    override function createPost() {
        add(lightsmall);
        add(light);
        add(lightAbove);
        super.createPost();
            gf.shader = makeCoolShader(-9,0,-30,-4);
            dad.shader = makeCoolShader(-32,0,-33,-23);
            boyfriend.shader = makeCoolShader(12,0,-23,7);
            
        }
    function makeCoolShader(hue:Float,sat:Float,bright:Float,contrast:Float) {
        var coolShader = new AdjustColorShader();
        coolShader.hue = hue;
        coolShader.saturation = sat;
        coolShader.brightness = bright;
        coolShader.contrast = contrast;
        return coolShader;
    }
}
