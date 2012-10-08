package PaletteFuck
{
	import flash.display.Sprite;
	import flash.events.Event;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Nick Heckman
	 */
	public class Main extends Engine 
	{
		
		public function Main():void 
		{
			super(1000, 600, 60, false);
			//FP.console.enable();
			FP.world = new PaletteWorld();
		}
		
	}
	
}