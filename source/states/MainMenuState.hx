package states;

import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.FlxObject;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import states.editors.MasterEditorMenu;
import options.OptionsState;
import torchsfunctions.functions.KeyboardTools;
import flixel.input.keyboard.FlxKey;
import flixel.input.FlxKeyManager;
import backend.Highscore;
import backend.Song;
import states.PlayState;
import openfl.ui.Mouse;

//temporary
import torchsthings.states.ResultsScreen;
import torchsthings.utils.WindowUtils;

enum MainMenuColumn {
	LEFT;
	CENTER;
	RIGHT;
}

class MainMenuState extends MusicBeatState
{	
	public static var fnfReaniV:String = 'V2.0';
	public static var psychEngineVersion:String = '1.0.4'; // This is also used for Discord RPC
	public static var torchEngineVersion:String = '0.1.1'; // Only reason I am listing this is because I think I am nearing a first beta release of this build
	public static var curSelected:Int = 0;
	public static var curColumn:MainMenuColumn = CENTER;
	public static var codeEntered:Bool = false; // Just for some detection is all, like for the "debugger" achievement
	var allowMouse:Bool = true; //Turn this off to block mouse movement in menus

	var menuItems:FlxTypedGroup<FlxSprite>;
	var leftItem:FlxSprite;
	var rightItem:FlxSprite;

	var charInput:String = "";
	var codesAndSongs:Array<Array<String>> = [
		["SMASH", "Verbal-smash"], 
		["CHUDNELL", "score"], 
		["TMG", "high-remix"], 
		["HEV", "pico-erect"], 
		["KARANXD", "blammed-erect"], 
		["LOCKIN", "fuck-you"],
		["DUPLEX", "blammed-remix"],
		["CHRISTMAS", "erect-eggnog"],
		["MEAREST","satin-panties-remix"],
		//["ICONOCLAST", "robin"],
		["HENRY", "cg5"],
		//["BFMIX", "Darnell-bf-mix"],
		["DEBUG", 'test']
	];
	var invalidCodes:Array<String> = [];


	//Centered/Text options
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		#if MODS_ALLOWED 'mods', #end
		'credits'
	];

	var leftOption:String = #if ACHIEVEMENTS_ALLOWED 'achievements' #else null #end;
	var rightOption:String = 'options';

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	var djData:Array<Array<String>> = [
		//	['djAssetName', 'x', 'y', 'graphicScale', 'djIdle', 'selectedAnimation'],
			['tutututurutututru', '660', '190', '0.6', 'bfeando ando0', ''], 
			['Jeys_BF_DJ_Assets', '380', '100', '0.8', 'BF Dancing Beat0', 'BF Cheer0'],
			['Boyfriend_DJ_original', '630', '200', '1.2', 'Boyfriend DJ0', 'Boyfriend hey0'],
			['Girlfriend', '630', '200', '1.2', 'Idle menu0', 'Start menu0'],
			['mecaigo', '730', '200', '1.2', 'zemp dj idle0', 'zemp dj enter0']
		];
		var randomDJnum:Int;
		var dj:BGSprite;

	static var showOutdatedWarning:Bool = true;
	override function create()
	{
		WindowUtils.changeDefaultTitle(WindowUtils.DEFAULT_TITLE);
		WindowUtils.changeTitle(WindowUtils.baseTitle + " - Main Menu");
		
		super.create();

		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = 0.25;
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.scrollFactor.set(0, yScroll);
		bg.updateHitbox();
		bg.screenCenter();
		bg.color = 0xfffdf24e;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.antialiasing = ClientPrefs.data.antialiasing;
		magenta.scrollFactor.set(0, yScroll);
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.color = 0xfffd4e82;
		add(magenta);

		var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x73FFFFFF, 0x0));
		grid.velocity.set(-40, 40);
		grid.alpha = 0;
		FlxTween.tween(grid, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		add(grid);

		randomDJnum = FlxG.random.int(0, djData.length - 1);
		var djName:String = djData[randomDJnum][0];
		var djOffsets:Array<Int> = [Std.parseInt(djData[randomDJnum][1]), Std.parseInt(djData[randomDJnum][2])];
		var djScale:Float = Std.parseFloat(djData[randomDJnum][3]);
		var djAnims:Array<String> = [djData[randomDJnum][4], djData[randomDJnum][5]];
		
		dj = new BGSprite('menuDJs/' + djName, djOffsets[0], djOffsets[1], 0.3, 0.3, [djAnims[0]], true);
		dj.animation.addByPrefix(djAnims[1], djAnims[1], 24, false);
		dj.antialiasing = ClientPrefs.data.antialiasing;
		dj.setGraphicSize(Std.int(dj.width * djScale));
		dj.updateHitbox();
		add(dj);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
			{
				if (optionShit[i] == 'nothing') {continue;}
				var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 140;
				var menuItem:FlxSprite = new FlxSprite(0, (i * 140) + offset);
				menuItem.antialiasing = ClientPrefs.data.antialiasing;
				menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
				menuItem.animation.addByPrefix('idle', optionShit[i] + " idle", 24);
				menuItem.animation.addByPrefix('selected', optionShit[i] + " selected", 24);
				menuItem.animation.play('idle');
				menuItems.add(menuItem);
				var scr:Float = (optionShit.length - 4) * 0.135;
				if (optionShit.length < 6)
					scr = 0;
				menuItem.scrollFactor.set(0, scr);
				menuItem.setGraphicSize(Std.int(menuItem.width * 1));
				menuItem.updateHitbox();
				//menuItem.screenCenter(X);
			
				switch (i)
				{
					case 0: 
						//menuItem.x = 99.4;
						menuItem.x -= 570;
						menuItem.y = 4.95;
						FlxTween.tween(menuItem, { x: menuItem.x + 570}, 0.7, {startDelay: 0.3 * i, ease: FlxEase.smoothStepOut});
					case 1:
						//menuItem.x = 100;
						menuItem.x -= 670;
						menuItem.y = 180;
						FlxTween.tween(menuItem, { x: menuItem.x + 700}, 0.7, {startDelay: 0.3 * i, ease: FlxEase.smoothStepOut});
					case 2:
						//menuItem.x = 100;
						menuItem.x -= 670;
						menuItem.y = 370;
						FlxTween.tween(menuItem, {x: menuItem.x + 700}, 0.7, {startDelay: 0.3 * i, ease: FlxEase.smoothStepOut});
					case 3:
						//menuItem.x = 100;
						menuItem.x -= 670;
						menuItem.y = 550;
						FlxTween.tween(menuItem, {x: menuItem.x + 700}, 0.7, {startDelay: 0.3 * i, ease: FlxEase.smoothStepOut});
				}
			}

		if (leftOption != null)
			leftItem = createMenuItem(leftOption, 1560, 40);
			FlxTween.tween(leftItem, {x: leftItem.x + -500}, 0.7, {startDelay: 0.3, ease: FlxEase.smoothStepOut});

		if (rightOption != null)
		{
			rightItem = createMenuItem(rightOption, 1560, 220);
			FlxTween.tween(rightItem, {x: rightItem.x + -500}, 0.7, {startDelay: 0.3, ease: FlxEase.smoothStepOut});

		}

		var rVer:FlxText = new FlxText(12, FlxG.height - 64, 0, "Reanimated " + fnfReaniV, 12);
		rVer.scrollFactor.set();
		rVer.setFormat("vcr.ttf", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(rVer);
		var torchVer:FlxText = new FlxText(12, FlxG.height - 44, 0, "Torch Engine v" + torchEngineVersion, 12);
		torchVer.scrollFactor.set();
		torchVer.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(torchVer);
		var psychVer:FlxText = new FlxText(12, FlxG.height - 24, 0, "Psych Engine v" + psychEngineVersion, 12);
		psychVer.scrollFactor.set();
		psychVer.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(psychVer);
		/*
		var fnfVer:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		fnfVer.scrollFactor.set();
		fnfVer.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(fnfVer);
		*/
		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		// Unlocks "Freaky on a Friday Night" achievement if it's a Friday and between 18:00 PM and 23:59 PM
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
			Achievements.unlock('friday_night_play');

		#if MODS_ALLOWED
		Achievements.reloadList();
		#end
		#end

		#if CHECK_FOR_UPDATES
		if (showOutdatedWarning && ClientPrefs.data.checkForUpdates && substates.OutdatedSubState.updateVersion != torchEngineVersion) {
			persistentUpdate = false;			
			showOutdatedWarning = false;
			openSubState(new substates.OutdatedSubState());
		}
		#end

		//FlxG.camera.follow(camFollow, null, 0.15);
	}

	function createMenuItem(name:String, x:Float, y:Float):FlxSprite
	{
		var menuItem:FlxSprite = new FlxSprite(x, y);
		menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_$name');
		menuItem.animation.addByPrefix('idle', '$name idle', 24, true);
		menuItem.animation.addByPrefix('selected', '$name selected', 24, true);
		menuItem.animation.play('idle');
		menuItem.updateHitbox();
		
		menuItem.antialiasing = ClientPrefs.data.antialiasing;
		menuItem.scrollFactor.set();
		menuItems.add(menuItem);
		return menuItem;
	}

	var selectedSomethin:Bool = false;

	var timeNotMoving:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume = Math.min(FlxG.sound.music.volume + 0.5 * elapsed, 0.8);

		if (FlxG.keys.justPressed.NUMPADZERO) {LoadingState.loadAndSwitchState(new ResultsScreen('test', 'Perfect!!', 999999, 'hard', [9999, 0, 0, 0, 0, 9999, 100], 0, 'pico'));}

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
				changeItem(-1);

			if (controls.UI_DOWN_P)
				changeItem(1);

			var allowMouse:Bool = allowMouse;
			if (allowMouse && ((FlxG.mouse.deltaScreenX != 0 && FlxG.mouse.deltaScreenY != 0) || FlxG.mouse.justPressed)) //FlxG.mouse.deltaScreenX/Y checks is more accurate than FlxG.mouse.justMoved
			{
				allowMouse = false;
				//FlxG.mouse.visible = true;
				Cursor.show();
				timeNotMoving = 0;

				var selectedItem:FlxSprite;
				switch(curColumn)
				{
					case CENTER:
						selectedItem = menuItems.members[curSelected];
					case LEFT:
						selectedItem = leftItem;
					case RIGHT:
						selectedItem = rightItem;
				}

				if(leftItem != null && FlxG.mouse.overlaps(leftItem))
				{
					allowMouse = true;
					if(selectedItem != leftItem)
					{
						curColumn = LEFT;
						changeItem();
					}
				}
				else if(rightItem != null && FlxG.mouse.overlaps(rightItem))
				{
					allowMouse = true;
					if(selectedItem != rightItem)
					{
						curColumn = RIGHT;
						changeItem();
					}
				}
				else
				{
					var dist:Float = -1;
					var distItem:Int = -1;
					for (i in 0...optionShit.length)
					{
						var memb:FlxSprite = menuItems.members[i];
						if(FlxG.mouse.overlaps(memb))
						{
							var distance:Float = Math.sqrt(Math.pow(memb.getGraphicMidpoint().x - FlxG.mouse.screenX, 2) + Math.pow(memb.getGraphicMidpoint().y - FlxG.mouse.screenY, 2));
							if (dist < 0 || distance < dist)
							{
								dist = distance;
								distItem = i;
								allowMouse = true;
							}
						}
					}

					if(distItem != -1 && selectedItem != menuItems.members[distItem])
					{
						curColumn = CENTER;
						curSelected = distItem;
						changeItem();
					}
				}
			}
			else
			{
				timeNotMoving += elapsed;
				if(timeNotMoving > 2) /*FlxG.mouse.visible = false;*/ Cursor.hide();
			}

			switch(curColumn)
			{
				case CENTER:
					if(controls.UI_LEFT_P && leftOption != null)
					{
						curColumn = LEFT;
						changeItem();
					}
					else if(controls.UI_RIGHT_P && rightOption != null)
					{
						curColumn = RIGHT;
						changeItem();
					}

				case LEFT:
					if(controls.UI_RIGHT_P)
					{
						curColumn = CENTER;
						changeItem();
					}

				case RIGHT:
					if(controls.UI_LEFT_P)
					{
						curColumn = CENTER;
						changeItem();
					}
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				//FlxG.mouse.visible = false;
				Cursor.hide();
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT || (FlxG.mouse.justPressed && allowMouse))
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				selectedSomethin = true;
				FlxG.mouse.visible = false;

				var djCheer:String = djData[randomDJnum][5];
				dj.animation.play(djCheer);
				FlxG.mouse.visible = false;

				if (ClientPrefs.data.flashing)
					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

				var item:FlxSprite;
				var option:String;
				switch(curColumn)
				{
					case CENTER:
						option = optionShit[curSelected];
						item = menuItems.members[curSelected];

					case LEFT:
						option = leftOption;
						item = leftItem;

					case RIGHT:
						option = rightOption;
						item = rightItem;
				}

				FlxTween.tween(item, {
					x: (FlxG.width - item.width) / 3.2,
					y: (FlxG.height - item.height) / 2
				}, 0.5, {ease: FlxEase.quadOut});

				for (memb in menuItems.members)
					{
						if (memb != item)
						{
							FlxTween.tween(memb, {alpha: 0}, 0.4, {ease: FlxEase.quadOut});
						}
					}

				FlxTween.tween(FlxG.camera, {zoom: 1.2}, 0.5, {
					ease: FlxEase.quadOut,
				});

				FlxG.camera.fade(FlxColor.BLACK, 1.1, false, function() 
				{
					switch (option) {
						case 'story_mode':
							MusicBeatState.switchState(new StoryMenuState());
						case 'freeplay':
							MusicBeatState.switchState(new FreeplayState());

						#if MODS_ALLOWED
						case 'mods':
							MusicBeatState.switchState(new ModsMenuState());
						#end

						#if ACHIEVEMENTS_ALLOWED
						case 'achievements':
							MusicBeatState.switchState(new AchievementsMenuState());
						#end

						case 'credits':
							MusicBeatState.switchState(new CreditsState());
						case 'options':
							MusicBeatState.switchState(new OptionsState());
							OptionsState.onPlayState = false;
							if (PlayState.SONG != null)
							{
								PlayState.SONG.arrowSkin = null;
								PlayState.SONG.splashSkin = null;
								PlayState.stageUI = 'normal';
							}
						case 'donate':
							CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
							selectedSomethin = false;
							item.visible = true;
						default:
							trace('Menu Item ${option} doesn\'t do anything');
							selectedSomethin = false;
							item.visible = true;
					}
				});

				for (memb in menuItems)
				{
					if(memb == item)
						continue;

					FlxTween.tween(memb, {alpha: 0}, 0.4, {ease: FlxEase.quadOut});
				}
			}
			#if desktop
			if (controls.justPressed('debug_1'))
			{
				selectedSomethin = true;
				//FlxG.mouse.visible = false;
				Cursor.hide();
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end

			charInput += KeyboardTools.keypressToString();
			for (array in codesAndSongs) {
				if (array[0].toUpperCase().trim().startsWith(charInput)) {
					if (charInput == array[0].toUpperCase().trim() && !invalidCodes.contains(array[0])) {
						FlxG.mouse.visible = false;
						selectedSomethin = true;
						codeEntered = true;

						FlxG.sound.play(Paths.sound('confirmMenu'));
						var djCheer:String = djData[randomDJnum][5];
						dj.animation.play(djCheer);

						var songLowercase:String = Paths.formatToSongPath(array[1]);
						var poop:String = Highscore.formatSong(songLowercase, 2);

						PlayState.SONG = Song.loadFromJson(poop, songLowercase);
						PlayState.isStoryMode = false;
						PlayState.storyDifficulty = 2;

						LoadingState.loadAndSwitchState(new PlayState());
					}
					continue;
				} else {
					if (invalidCodes.contains(array[0])) continue;
					invalidCodes.push(array[0]);
					//trace(invalidCodes);
				}
			}
			if (invalidCodes.length == codesAndSongs.length) {
				invalidCodes = [];
				charInput = '';
				//trace("reset char input");
			}
		
		}

		super.update(elapsed);
	}

	function changeItem(change:Int = 0)
	{
		if(change != 0) curColumn = CENTER;
		curSelected = FlxMath.wrap(curSelected + change, 0, optionShit.length - 1);
		FlxG.sound.play(Paths.sound('scrollMenu'));

		for (item in menuItems)
		{
			item.animation.play('idle');
			item.centerOffsets();
		}

		var selectedItem:FlxSprite;
		switch(curColumn)
		{
			case CENTER:
				selectedItem = menuItems.members[curSelected];
			case LEFT:
				selectedItem = leftItem;
			case RIGHT:
				selectedItem = rightItem;
		}
		selectedItem.animation.play('selected');
		selectedItem.centerOffsets();
		camFollow.y = selectedItem.getGraphicMidpoint().y;
	}
}
