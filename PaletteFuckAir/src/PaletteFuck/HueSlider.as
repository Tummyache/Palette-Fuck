package PaletteFuck 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Nick Heckman
	 */
	public class HueSlider extends Entity 
	{
		[Embed(source = "../HueGradient.png")] private const IMG_HUE_GRADIENT:Class;
		
		public var mShadowNode:Entity;
		public var mHighlightNode:Entity;
		
		public var mShadowColor:Number = 330;
		public var mHighlightColor:Number = 30;
		
		public function HueSlider(world:World) 
		{
			var tempImage:Image = Image.createCircle(4, 0x000000, 0.7);
			tempImage.centerOO();
			mShadowNode = new Entity(260, 10, tempImage);
			mShadowNode.setHitbox(10, 10, 5, 5);
			mShadowNode.layer = -1;
			
			tempImage = Image.createCircle(4, 0xFFFFFF, 0.7);
			tempImage.centerOO();
			mHighlightNode = new Entity(30, 24, tempImage);
			mHighlightNode.setHitbox(10, 10, 5, 5);
			mHighlightNode.layer = -1;
			
			world.add(mShadowNode);
			world.add(mHighlightNode);
			
			graphic = new Image(IMG_HUE_GRADIENT);
			(graphic as Image).scaleY = 1.5;
			setHitbox(360, 37);
		}
		
		
		override public function update():void 
		{
			super.update();
			
			mShadowNode.x = x + mShadowColor;
			mShadowNode.y = y + 10;
			mHighlightNode.x = x + mHighlightColor;
			mHighlightNode.y = y + 24;
			
			if (Input.mousePressed && collidePoint(x, y, Input.mouseX, Input.mouseY))
			{
				if (Input.mouseY - y < 20)
				{
					mShadowColor = Input.mouseX - x;
				}
				else
				{
					mHighlightColor = Input.mouseX - x;
				}
			}
		}
	}

}