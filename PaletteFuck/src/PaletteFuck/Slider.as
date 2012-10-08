package PaletteFuck 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Nick Heckman
	 */
	public class Slider extends Entity 
	{
		[Embed(source = "../Slider.png")] private const IMG_SLIDER:Class;
		
		public var mImage:Graphiclist;
		public var mSlider:Image;
		public var mSelected:Boolean;
		public var mMaxValue:int;
		public var mLabel:Text;
		
		public function Slider(label:String) 
		{
			mImage = new Graphiclist();
			
			mMaxValue = 360;
			
			var line:Image = Image.createRect(360, 3, 0x888888, 1.0);
			line.y = 6;
			
			mSlider = new Image(IMG_SLIDER);
			mSlider.y = 6;
			mSlider.x = (label == "Saturation" ? 360 : 0);
			mSlider.centerOO();
			
			mLabel = new Text(label, -100, 0);
			mLabel.size = 16;
			
			mImage.add(line);
			mImage.add(mSlider);
			mImage.add(mLabel);
			
			setHitbox(380, 15, 10, 0);
			
			graphic = mImage;
		}
		
		
		override public function update():void 
		{
			super.update();
			
			if (Input.mousePressed && collidePoint(x, y, Input.mouseX, Input.mouseY))
			{
				mSelected = true;
			}
			
			if (mSelected == true)
			{
				mSlider.x = Input.mouseX - x;
				if (mSlider.x < 0)
				{
					mSlider.x = 0;
				}
				if (mSlider.x > 360)
				{
					mSlider.x = 360;
				}
			}
			
			if (Input.mouseReleased && mSelected == true)
			{
				mSelected = false;
			}
		}
		
		public function getValue():Number
		{
			return (mSlider.x / 360)*mMaxValue;
		}
		
		public function setValue(val:Number):void
		{
			mSlider.x = (val / mMaxValue) * 360;
		}
	}

}