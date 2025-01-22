package objectsplus;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.math.FlxMath;

class ScoreDisplay extends FlxText
{
    var displayedScore:Float = 0;
    var lerpSpeed:Float = 6; // Reduced for smoother counting
    var posY:Float = 0;

    public function new()
    {
        posY = ClientPrefs.data.downScroll ? 105 : 675;
        
        super(750, posY, 200, "Score: 0");
        
        setFormat(Paths.font(PlayState.isPixelStage ? "pixel.otf" : 'vcr.ttf'), 
                 PlayState.isPixelStage ? 14 : 20,
                 FlxColor.WHITE, CENTER, 
                 FlxTextBorderStyle.OUTLINE, 
                 FlxColor.BLACK);
        setBorderStyle(OUTLINE, FlxColor.BLACK, 2);
        cameras = [PlayState.instance.camHUD];
        
        alignment = CENTER;
        antialiasing = true;
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
        
        y = posY;
        alpha = PlayState.instance.scoreTxt.alpha;
        
        var targetScore:Float = PlayState.instance.songScore;
        displayedScore = FlxMath.lerp(displayedScore, targetScore, lerpSpeed * elapsed); 
        //displayedScore = FlxMath.lerp(displayedScore, targetScore, 1); // testing only
        
        var roundedScore:Int = Math.round(displayedScore);
        text = 'Score: ${formatNumber(roundedScore)}';
    }

    function formatNumber(n:Int):String
    {
        var formatted:String = Std.string(n);
        var regex = ~/(-?\d+)(\d{3})/;
        
        while (regex.match(formatted))
        {
            formatted = regex.replace(formatted, '$1,$2');
        }
        
        return formatted;
    }
}
