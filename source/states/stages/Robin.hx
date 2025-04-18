package states.stages;

import states.stages.objects.*;
import objects.Character;
import substates.GameOverSubstate;
import lime.utils.Assets;
import torchsthings.objects.ImageBar;
import torchsthings.objects.ImageBar.BarSettings;

class Robin extends BaseStage
{
	var robinForestuff:BGSprite;
	override function create() 
	{
		ratingPos.set(750, 950);
        comboCountPos.set(650, 1100);
		comboImage.set( 0, 950);

		var _song = PlayState.SONG;
		if(_song.gameOverLoop == null || _song.gameOverLoop.trim().length < 1) GameOverSubstate.loopSoundName = 'gameOver-iconoclast';
		if(_song.gameOverEnd == null || _song.gameOverEnd.trim().length < 1) GameOverSubstate.endSoundName = 'gameOverEnd-iconoclast';

		var sky:BGSprite = new BGSprite('blockrock/sky', -370, -270, 0.1, 0.1);
		sky.setGraphicSize(Std.int(sky.width * 0.9));
		sky.updateHitbox();
		add(sky);
		
		var trees:BGSprite = new BGSprite('blockrock/trees', -810, 50, 0.5, 0.4);
		trees.setGraphicSize(Std.int(trees.width * 1.2));
		trees.updateHitbox();
		add(trees);

		var rockfloor:BGSprite = new BGSprite('blockrock/rockfloor', -115, 1060, 1, 1);
		rockfloor.setGraphicSize(Std.int(rockfloor.width * 0.9));
		rockfloor.updateHitbox();
		add(rockfloor);
		
		var bush:BGSprite = new BGSprite('blockrock/bush', -105, 870, 1, 1);
		bush.setGraphicSize(Std.int(bush.width * 0.9));
		bush.updateHitbox();
		add(bush);
		
		var house:BGSprite = new BGSprite('blockrock/house', 30, 240);
		house.setGraphicSize(Std.int(house.width * 0.59));
		house.updateHitbox();
		add(house);
		
		var tree:BGSprite = new BGSprite('blockrock/tree', 1280, 275, 0.9, 0.9);
		tree.setGraphicSize(Std.int(tree.width * 0.7));
		tree.updateHitbox();
		add(tree);	

		var stone:BGSprite = new BGSprite('blockrock/stone', -170, 480, 0.9, 0.9);
		stone.setGraphicSize(Std.int(stone.width * 0.7));
		stone.updateHitbox();
		add(stone);
		
		robinForestuff = new BGSprite('blockrock/forestuff', -80, 410, 0.9, 0.9);
		robinForestuff.setGraphicSize(Std.int(robinForestuff.width * 0.75));
		robinForestuff.updateHitbox();
		
		var settings:BarSettings = haxe.Json.parse(Assets.getText(Paths.json("healthbars/Iconoclast", "shared").replace("data", "images")));
        PlayState.healthBarSettings = settings;
	}
	override function createPost()
		{
			add(robinForestuff);
		}
}