package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	var player:FlxSprite;
	var enemy:FlxSprite;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end
		FlxG.camera.fade(0xff000000, 0.5, true);
		
		//player = new FlxSprite(0, 0).makeGraphic(32, 32, 0xFF00ffff);
		//enemy = new FlxSprite(50, 50).makeGraphic(32, 32, 0xffff0000);
		
		//add(player);
		//add(enemy);
		
		var text:FlxText = new FlxText(0, 0, FlxG.width, "Yeah, about that...\nIt doesn't exist, sorry", 48);
		text.setFormat(null, 42, 0xffffff, "center");
		text.y =  FlxG.height / 2 - text.height / 2;
		
		add(text);
		
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
	}	
}