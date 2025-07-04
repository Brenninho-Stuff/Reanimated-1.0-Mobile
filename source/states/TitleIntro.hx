package states;

//Yeah i know i could do this on titlestate but im to lazy to move shit :p

import states.TitleState;
import openfl.Assets;
import flixel.input.mouse.FlxMouse;
import flixel.input.mouse.FlxMouseEventManager;
import openfl.ui.Mouse;
import torchsthings.shaders.CRT;
import openfl.filters.ShaderFilter;
import objects.VideoSprite;

#if hxvlc
import hxvlc.flixel.FlxVideoSprite;
#end
class TitleIntro extends MusicBeatState
{
	var crt:CRT = new CRT();
    public var jesus:Bool = true;
    private var video:VideoSprite;
    override function create()
    {
        FlxG.mouse.visible = false;

		FlxG.game.setFilters([new ShaderFilter(crt)]);

        super.create();
    }


    //video started on update cuz on create aint work
    override function update(elapsed:Float)
    {
        if (jesus)
        {
            startVideo("Colab X 17 buck Colifloor");
            jesus = false;
        }

        /*if (FlxG.keys.justPressed.ENTER) {
            endVideo();
        }
		crt.update(elapsed);
        */

        super.update(elapsed);
    }

    public function startVideo(name:String)
    {
        var n = Paths.video(name);
        video = new VideoSprite(n, false, true, false);
        video.finishCallback = endVideo;
		video.onSkip = endVideo;
        add(video);
        video.play();
        
    } 
    
    function endVideo(){
        FlxG.game.setFilters(null);
        video = null;
        MusicBeatState.switchState(new TitleState());
    }
    
}