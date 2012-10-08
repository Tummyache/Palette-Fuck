package PaletteFuck 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import PaletteFuck.ColorConverter;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Nick Heckman
	 */
	public class PaletteBlock extends Entity 
	{
		public var mImage:Image;
		public var mColor:Color;
		public var mRow:int;
		public var mColumn:int;
		
		public function PaletteBlock() 
		{
			mImage = Image.createRect(25, 25, 0xFFFFFF, 1.0);
			graphic = mImage;
			mImage.centerOO();
			setHitbox(25, 25, 12, 12);
			
			mColor = new Color();
			
			mColor.Hue = 0;
			mColor.Luminance = 0.0;
			mColor.Saturation = 1.0;
			
			mImage.color = mColor.toHex();
		}
		
		override public function update():void 
		{
			super.update();

			mImage.color = mColor.toHex();
		}
		
	}

}