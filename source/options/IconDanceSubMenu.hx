package options;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import objects.Alphabet;

class IconDanceSubMenu extends MusicBeatSubstate
{
	public var availableAnims:Array<String>;
	public var primaryIndex:Int;
	public var secondaryIndex:Int;
	public var onConfirm:Void->Void;

	private var modalBg:FlxSprite;
	private var primaryText:Alphabet;
	private var secondaryText:Alphabet;
	private var instructions:FlxText;
	
	public function new(availableAnims:Array<String>, currentPrimary:Int, currentSecondary:Int, onConfirm:Void->Void)
	{
		super();
		this.availableAnims = availableAnims;
		primaryIndex = currentPrimary;
		secondaryIndex = currentSecondary;
		this.onConfirm = onConfirm;
	}

	override public function create():Void
	{
		super.create();

		// Fondo semitransparente (modal)
		modalBg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xCC000000);
		modalBg.screenCenter();
		modalBg.alpha = 0;
		add(modalBg);

		// Texto para animación primaria usando Alphabet
		primaryText = new Alphabet(0, 0, "Primary: " + availableAnims[primaryIndex], true);
		primaryText.screenCenter();
		primaryText.x -= 130; 
		primaryText.y = modalBg.y + 60;
		primaryText.alpha = 0;
		add(primaryText);

		// Texto para animación secundaria usando Alphabet
		secondaryText = new Alphabet(0, 0, "Secondary: " + availableAnims[secondaryIndex], true);
		secondaryText.screenCenter();
		secondaryText.x -= 100; 
		secondaryText.y = modalBg.y + 130;
		secondaryText.alpha = 0;
		add(secondaryText);

		// Instrucciones usando FlxText (puedes cambiar a Alphabet si lo prefieres)
		instructions = new FlxText(0, 0, FlxG.width, "Izquierda/Derecha: cambia primaria   Arriba/Abajo: cambia secundaria   ENTER: confirmar   ESC: cancelar");
		instructions.setFormat("vcr.ttf", 20, 0xAAAAAA, "center");
		instructions.screenCenter();
		instructions.y = FlxG.height - 40;
		instructions.alpha = 0;
		add(instructions);

		// Animación de entrada: fade-in para fondo, textos e íconos
		FlxTween.tween(modalBg, {alpha: 0.9}, 0.5, {ease: FlxEase.quadOut});
		FlxTween.tween(primaryText, {alpha: 1}, 0.5, {ease: FlxEase.quadOut, startDelay: 0});
		FlxTween.tween(secondaryText, {alpha: 1}, 0.5, {ease: FlxEase.quadOut, startDelay: 0.1});
		FlxTween.tween(instructions, {alpha: 1}, 0.5, {ease: FlxEase.quadOut, startDelay: 0.2});
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		// Actualizar las selecciones y los textos
		if (FlxG.keys.justPressed.LEFT)
		{
			primaryIndex = (primaryIndex - 1 + availableAnims.length) % availableAnims.length;
			primaryText.text = "Primary: " + availableAnims[primaryIndex];
		}
		else if (FlxG.keys.justPressed.RIGHT)
		{
			primaryIndex = (primaryIndex + 1) % availableAnims.length;
			primaryText.text = "Primary: " + availableAnims[primaryIndex];
		}

		if (FlxG.keys.justPressed.UP)
		{
			secondaryIndex = (secondaryIndex - 1 + availableAnims.length) % availableAnims.length;
			secondaryText.text = "Secondary: " + availableAnims[secondaryIndex];
		}
		else if (FlxG.keys.justPressed.DOWN)
		{
			secondaryIndex = (secondaryIndex + 1) % availableAnims.length;
			secondaryText.text = "Secondary: " + availableAnims[secondaryIndex];
		}

		if (FlxG.keys.justPressed.ENTER)
		{
			ClientPrefs.data.iconAnims = [ availableAnims[primaryIndex], availableAnims[secondaryIndex] ];
			if (onConfirm != null)
				onConfirm();
			closeMenu();
		}

		if (FlxG.keys.justPressed.ESCAPE)
		{
			closeMenu();
		}
	}

	function closeMenu():Void
	{
		FlxTween.tween(modalBg, {alpha: 0}, 0.5, {ease: FlxEase.quadIn});
		FlxTween.tween(primaryText, {alpha: 0}, 0.5, {ease: FlxEase.quadIn});
		FlxTween.tween(secondaryText, {alpha: 0}, 0.5, {ease: FlxEase.quadIn, startDelay: 0.1});
		FlxTween.tween(instructions, {alpha: 0}, 0.5, {ease: FlxEase.quadIn, startDelay: 0.2});

		var timer = new FlxTimer();
		timer.start(0.6, function(timer:FlxTimer) {
			close();
		});
	}
}