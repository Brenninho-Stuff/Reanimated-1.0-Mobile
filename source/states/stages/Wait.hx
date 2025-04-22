package states.stages;

import lime.utils.Assets;
import states.stages.objects.*;
import torchsthings.objects.ImageBar;
import torchsthings.objects.ImageBar.BarSettings;

class Wait extends BaseStage 
{
    override function create()
        { 
            ratingPos.set(400, 200);
            comboCountPos.set(300, 350);
            comboImage.set( 0, 300);

        var blackScreen:FlxSprite = new FlxSprite(-4000, -2000).makeGraphic(Std.int(FlxG.width * 10), Std.int(FlxG.height * 10), FlxColor.WHITE);
		blackScreen.scrollFactor.set();
		add(blackScreen);
        
        var settings:BarSettings = haxe.Json.parse(Assets.getText(Paths.json("healthbars/17bucks", "shared").replace("data", "images")));
        PlayState.healthBarSettings = settings;
    }
    override function createPost()
    { 
        // Hide opponent notes
        if (songName.toLowerCase() == 'i-ma-walk-right-in') {
			for (i in 0...4) {
				PlayState.instance.opponentStrums.members[i].x = -5000;
				PlayState.instance.opponentStrums.members[i].visible = false;
				PlayState.instance.defaultStrumPosition[i][0] = -5000;
			}
        PlayState.instance.iconP2.visible = false;
        }
    }
}