package states.stages;

import states.stages.objects.*;

class Wait extends BaseStage 
{
    override function create()
        { 
            ratingPos.set(400, 200);
            comboCountPos.set(300, 350);

        var blackScreen:FlxSprite = new FlxSprite(-900, -500).makeGraphic(Std.int(FlxG.width * 10), Std.int(FlxG.height * 10), FlxColor.WHITE);
		blackScreen.scrollFactor.set();
		add(blackScreen);
    }
}