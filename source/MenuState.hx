package;

import flixel.addons.text.FlxTypeText;
import flixel.effects.FlxTrailArea;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxEmitterExt;
import flixel.effects.particles.FlxParticle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	
	public static inline var N_PARTICLES:Int = 100;
	
	var titleText:FlxText;
	var subtitleText:FlxTypeText;
	var button:FlxButton;
	var introMusic:FlxSound;
	
	var sentences:Array<String>;
	var weightSentences:Array<Float>;
	
	var emitter:FlxEmitter;
	
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
		
		FlxG.log.redirectTraces = false;
		
		createIntro();
		
		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		emitter.destroy();
		titleText.destroy();
		subtitleText.destroy();
		button.destroy();
		introMusic.destroy();
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
	}
	
	@:access(flixel.text.FlxText.calcFrame)
	private function createIntro():Void {
		
		sentences = ["Not really...", "Or that what they say...", "The best game in the world!", "WOW, SUCH GAME, SO NICE, VERY PLAYABLE"];
		weightSentences = [for (i in 0...sentences.length) FlxRandom.float() ];
		
		introMusic = FlxG.sound.load("assets/music/intro.wav", 0.7, true, false, false);
		
		titleText = new FlxText(0, -200, FlxG.width, "The Most SuperAwesome Game", 48);
		subtitleText = new FlxTypeText(0, -200, FlxG.width, getRandomSentence(), 24);
		button = new FlxButton(0, -200, "PLAY");
		button.x = FlxG.width / 2 - button.label.width / 2;
		button.onDown.callback = startGame;
		
		// The first thing to do is setting up the FlxTrailArea
		var trailArea = new FlxTrailArea(10, 10, FlxG.width, FlxG.height);
		trailArea.smoothing = false;
		trailArea.alpha = 1;
		
		// This just sets up an emitter at the bottom of the screen
		emitter = new FlxEmitter(0, -128, N_PARTICLES);
		emitter.setSize(FlxG.width, 0);
		emitter.gravity = 30;
		emitter.setYSpeed( 75, 25);
		emitter.setXSpeed( -30, 30);
		emitter.setScale(0.75, 1.2, 0.75, 1.2);
		
		var txt_array = [];
		
		
		var txt_wow = new FlxText(0, 0, 128, "WOW", 32);
		txt_array.push(txt_wow);
		var txt_such =  new FlxText(0, 0, 128, "SUCH GAME", 32);
		txt_array.push(txt_such);
		var txt_very =  new FlxText(0, 0, 256, "VERY PLAYABLE", 32);
		txt_array.push(txt_very);
		var txt_so =  new FlxText(0, 0, 128, "SO NICE", 32);
		txt_array.push(txt_so);
		
		for (txt in txt_array) {
			txt.setFormat(null, 36, FlxRandom.color(128), "center");
			txt.calcFrame();
		}
		
		var particle:FlxParticle;
		for (i in 0...N_PARTICLES) {
			particle = new FlxParticle();
			
			if(i % 2 == 0) {
				particle.loadRotatedGraphic("assets/images/doge_particle.png", 4);
				trailArea.add(particle);
			} else {
				var txt = FlxRandom.getObject(txt_array);
				particle.loadFromSprite(txt);
			}
			emitter.add(particle);
		}
		
		
		add(trailArea);
		add(emitter);
		add(titleText);
		add(subtitleText);
		add(button);
		
		titleText.setFormat(null, 48, 0xff0000, "center", FlxText.BORDER_OUTLINE_FAST, 0xFFFFFF);
		titleText.angle = -10;
		titleText.scale.set(3, 3);
		
		subtitleText.setFormat(null, 24, 0x000000, "center", FlxText.BORDER_OUTLINE_FAST, 0xFFFFFF);
		subtitleText.delay = 0.08;
		subtitleText.eraseDelay = 0.06;
		subtitleText.useDefaultSound = true;
		subtitleText.setTypingVariation(1.75, true);
		
		subtitleText.setCompleteCallback(function () {
			FlxTimer.start(2, function(timer:FlxTimer) { subtitleText.erase(); subtitleText.sound.volume = 0.15; } );
		});
		subtitleText.setEraseCallback(function() {
			subtitleText.resetText(getRandomSentence());
			subtitleText.start();
			subtitleText.sound.volume = 0.2;
		});
		

		// scale title tween
		FlxTween.multiVar(titleText.scale, { x: 1, y: 1 }, 0.78, { ease: FlxEase.elasticOut } ).start();
		// position title tween
		var tween:FlxTween = FlxTween.multiVar(titleText, { y: (FlxG.height / 2 - titleText.height / 2) - 100 }, 0.88, {ease: FlxEase.elasticOut});
		tween.start();
		tween.complete = function (t:FlxTween) {
			FlxG.camera.flash(0xffffffff, 0.2);
			FlxG.camera.shake(0.05, 0.2);
			emitter.start(false, 0, 0.3);
			button.y = titleText.height + titleText.y + 100;
			subtitleText.y = FlxG.height - 48;
			subtitleText.start();
			subtitleText.sound.volume = 0.2;
			introMusic.play();
			FlxTween.angle(titleText, -10, 10, 2.2, { ease: FlxEase.elasticInOut, type: FlxTween.PINGPONG } );
		};
	}
	
	private function startGame():Void {
		subtitleText.paused = true;
		FlxTween.singleVar(introMusic, "volume", 0, 1);
		FlxTween.multiVar(titleText, { y: -250 }, 0.6, { ease: FlxEase.bounceIn, complete: function(t:FlxTween) { FlxG.camera.fade(0xFF000000, 0.5, false, function() { FlxG.switchState(new PlayState()); } ); } } );
		FlxTween.multiVar(titleText.scale, { x: -1, y: 0.5 }, 0.6, { ease: FlxEase.bounceIn } );
		FlxTween.multiVar(subtitleText, { x: FlxG.width + 10 }, 0.6, { ease: FlxEase.bounceIn } );
	}
	
	private function getRandomSentence():String {
		var rand = FlxRandom.weightedPick(weightSentences);
		for (i in 0...weightSentences.length) {
			weightSentences[i] = i == rand ? 0 : FlxRandom.float();
		}
		
		return sentences[rand];
	}
}