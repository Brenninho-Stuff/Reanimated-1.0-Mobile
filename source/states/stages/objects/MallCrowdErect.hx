package states.stages.objects;

class MallCrowdErect extends BGSprite
{
	//public var heyTimer:Float = 0;
	public function new(x:Float = 0, y:Float = 0, sprite:String = 'christmas/erect/bottomBop', idle:String = 'Bottom Level Boppers Idle0')
	{
		super(sprite, x, y, 0.9, 0.9, [idle]);
		//animation.addByPrefix('hey', hey, 24, false);
		antialiasing = ClientPrefs.data.antialiasing;
	}

}