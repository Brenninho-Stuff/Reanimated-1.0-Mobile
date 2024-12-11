package states.stages;

import states.stages.objects.*;
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
    override function create() {

        background = new BGSprite('rework/Erect/background', 989, -170, 1, 1);
        background.setGraphicSize(Std.int(background.width * 1));
        background.updateHitbox();
        add(background);

        crowd = new BGSprite('rework/Erect/crowd', 700, 190, 0.8, 0.8, ['Symbol 2 instance'], true);
        crowd.setGraphicSize(Std.int(crowd.width * 1.2));
        crowd.updateHitbox();
        add(crowd);
        
        orange = new BGSprite('rework/Erect/orangeLight', 100, -200, 1, 1);
        orange.setGraphicSize(Std.int(orange.width * 1.2));
        orange.updateHitbox();
        add(orange);

        bg = new BGSprite('rework/Erect/bg', -600, -400, 0.9, 0.9);
        bg.setGraphicSize(Std.int(bg.width * 1.3));
        bg.updateHitbox();
        add(bg);

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
     
    }
    override function createPost() {
        add(lightsmall);
        add(light);
    }
}
