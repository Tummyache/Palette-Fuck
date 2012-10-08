package PaletteFuck 
{
	import flash.net.FileReference;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Nick Heckman
	 */
	public class PaletteWorld extends World 
	{
		
		
		public var mSelectedBlock:PaletteBlock;
		public var mSelection:Entity;
		public var mSelectionBlock:Image;
		public var mBlocks:Array;
		
		public var mHueSlider:Slider;
		public var mLumSlider:Slider;
		public var mSatSlider:Slider;
		
		public var mShadowSlider:HueSlider;
		
		public function PaletteWorld() 
		{
			mBlocks = new Array();
			
			mSelectionBlock = Image.createRect(27, 27, 0xFFFFFF, 1.0);
			mSelectionBlock.centerOO();
			
			mSelection = new Entity(0, 0, mSelectionBlock);
			
			add(mSelection);
			
			for (var x:int = 0; x < 16; x++)
			{
				var rowOfBlocks:Array = new Array();
				
				for (var y:int = 0; y < 16; y++)
				{
					var block:PaletteBlock = new PaletteBlock();
					block.x = 10 + (x+1) * 26;
					block.y = 10 + (y + 1) * 26;
					block.mRow = y;
					block.mColumn = x;
					add(block);
					rowOfBlocks.push(block);
				}
					
				mBlocks.push(rowOfBlocks);
			}
			
			(mBlocks[15][15] as PaletteBlock).mColor.Luminance = 1.0;
			
			mShadowSlider = new HueSlider(this);
			mShadowSlider.x = 550;
			mShadowSlider.y = 50;
			add(mShadowSlider);
			
			mHueSlider = new Slider("Hue");
			mHueSlider.x = 550;
			mHueSlider.y = 100;
			mHueSlider.mMaxValue = 360;
			add(mHueSlider);
			
			mSatSlider = new Slider("Saturation");
			mSatSlider.x = 550;
			mSatSlider.y = 200;
			mSatSlider.mMaxValue = 1.0;
			add(mSatSlider);
			
			mLumSlider = new Slider("Luminance");
			mLumSlider.x = 550;
			mLumSlider.y = 300;
			mLumSlider.mMaxValue = 1.0;
			add(mLumSlider);
			
			var directions:Graphiclist = new Graphiclist();
			directions.add(new Text("Up/Down to blend above or below", 0, 24*0));
			directions.add(new Text("(Searches for next block with > 0 Luminance)", 0, 24*1));
			directions.add(new Text("Left to generate shadow", 0, 24*2));
			directions.add(new Text("Right to generate highlight", 0, 24 * 3));
			directions.add(new Text("S to save palette", 0, 24 * 4 + 20));
			directions.add(new Text("Sometimes right click after hitting S (weird bug)", 0, 24 * 5 + 20));
			directions.add(new Text("Import to Graphics Gale for good times!", 0, 24 * 6 + 20));
			
			add(new Entity(500, 365, directions));
			
			
			mSelectedBlock = mBlocks[0][0];
		}
		
		override public function update():void 
		{
			super.update();
			
			if (Input.mousePressed)
			{
				for (var y:int = 0; y < mBlocks.length; y++)
				{
					var thisRow:Array = mBlocks[y];
					for (var x:int = 0; x < thisRow.length; x++)
					{
						var currentBlock:PaletteBlock = thisRow[x];
						if (currentBlock.collidePoint(currentBlock.x, currentBlock.y, Input.mouseX, Input.mouseY))
						{
							mSelectedBlock = currentBlock;
							trace(mSelectedBlock.mColor.Hue);
							mHueSlider.setValue(mSelectedBlock.mColor.Hue);
							mSatSlider.setValue(mSelectedBlock.mColor.Saturation);
							mLumSlider.setValue(mSelectedBlock.mColor.Luminance);
							break;
						}
					}
				}
			}
			
			if (Input.mouseDown)
			{
				mSelectedBlock.mColor.Hue = mHueSlider.getValue();
				mSelectedBlock.mColor.Saturation = mSatSlider.getValue();
				mSelectedBlock.mColor.Luminance = mLumSlider.getValue();
			}
			
			if (Input.pressed(Key.LEFT))
			{
				var shadowBlock:PaletteBlock = mBlocks[mSelectedBlock.mColumn-1][mSelectedBlock.mRow];
				shadowBlock.mColor.Hue = mSelectedBlock.mColor.Hue + FP.sign(mShadowSlider.mShadowColor - mSelectedBlock.mColor.Hue) * 14;
				shadowBlock.mColor.Luminance = mSelectedBlock.mColor.Luminance - .14;
				shadowBlock.mColor.Saturation = mSelectedBlock.mColor.Saturation;
				
				mSelectedBlock = shadowBlock;
			}
			else if (Input.pressed(Key.RIGHT))
			{
				var lightBlock:PaletteBlock = mBlocks[mSelectedBlock.mColumn+1][mSelectedBlock.mRow];
				lightBlock.mColor.Hue = mSelectedBlock.mColor.Hue + FP.sign(mShadowSlider.mHighlightColor - mSelectedBlock.mColor.Hue) * 14;
				lightBlock.mColor.Luminance = mSelectedBlock.mColor.Luminance + .14;
				lightBlock.mColor.Saturation = mSelectedBlock.mColor.Saturation;
				
				mSelectedBlock = lightBlock;
			}
			else if (Input.pressed(Key.DOWN))
			{
				var otherBlock:PaletteBlock;
				for (var y:int = mSelectedBlock.mRow+1; y < mBlocks.length; y++)
				{
					otherBlock = mBlocks[mSelectedBlock.mColumn][y];
					if (otherBlock.mColor.Luminance > 0)
					{
						break;
					}
				}
				var tempBlock:PaletteBlock = mSelectedBlock;
				mSelectedBlock = otherBlock;
				otherBlock = tempBlock;
				var blocksBetween = otherBlock.mRow - mSelectedBlock.mRow - 1;
				for (var i:int = 1; i <= blocksBetween; i++)
				{
					var modBlock:PaletteBlock = mBlocks[mSelectedBlock.mColumn][mSelectedBlock.mRow + i];
					var otherColor:RGB = otherBlock.mColor.toRGB();
					var selectedColor:RGB = mSelectedBlock.mColor.toRGB();
					var newColor:RGB = new RGB();
					newColor.Red = FP.lerp(selectedColor.Red, otherColor.Red, i / (blocksBetween + 1));
					newColor.Blue = FP.lerp(selectedColor.Blue, otherColor.Blue, i / (blocksBetween + 1));
					newColor.Green = FP.lerp(selectedColor.Green, otherColor.Green, i / (blocksBetween + 1));
					
					var blendColor:Object = ColorConverter.rgb2hsv(newColor.Red, newColor.Green, newColor.Blue);
					
					modBlock.mColor.Hue = blendColor.h;
					modBlock.mColor.Saturation = blendColor.s/100;
					modBlock.mColor.Luminance = FP.lerp(mSelectedBlock.mColor.Luminance, otherBlock.mColor.Luminance, i / (blocksBetween + 1));
				}
				
			}
			else if (Input.pressed(Key.UP))
			{
				var otherBlock:PaletteBlock;
				for (var y:int = mSelectedBlock.mRow-1; y >= 0; y--)
				{
					otherBlock = mBlocks[mSelectedBlock.mColumn][y];
					if (otherBlock.mColor.Luminance > 0)
					{
						break;
					}
				}
				var blocksBetween = mSelectedBlock.mRow - otherBlock.mRow - 1;
				for (var i:int = 1; i <= blocksBetween; i++)
				{
					var modBlock:PaletteBlock = mBlocks[mSelectedBlock.mColumn][mSelectedBlock.mRow - i];
					var otherColor:RGB = otherBlock.mColor.toRGB();
					var selectedColor:RGB = mSelectedBlock.mColor.toRGB();
					var newColor:RGB = new RGB();
					newColor.Red = FP.lerp(selectedColor.Red, otherColor.Red, i / (blocksBetween + 1));
					newColor.Blue = FP.lerp(selectedColor.Blue, otherColor.Blue, i / (blocksBetween + 1));
					newColor.Green = FP.lerp(selectedColor.Green, otherColor.Green, i / (blocksBetween + 1));
					
					var blendColor:Object = ColorConverter.rgb2hsv(newColor.Red, newColor.Green, newColor.Blue);
					
					modBlock.mColor.Hue = blendColor.h;
					modBlock.mColor.Saturation = blendColor.s/100;
					modBlock.mColor.Luminance = FP.lerp(mSelectedBlock.mColor.Luminance, otherBlock.mColor.Luminance, i / (blocksBetween + 1));
				}
				
			}
			
			if (Input.pressed(Key.S))
			{
				var saver:FileReference = new FileReference();
				var paletteFile:String = new String("JASC-PAL\r\n0100\r\n256\r\n");
				for (var y:int = 0; y < mBlocks.length; y++)
				{
					var thisRow:Array = mBlocks[y];
					for (var x:int = 0; x < thisRow.length; x++)
					{
						var currentBlock:PaletteBlock = mBlocks[x][y];
						var rgbValues:RGB = currentBlock.mColor.toRGB();
						paletteFile += rgbValues.Red + " ";
						paletteFile += rgbValues.Green + " ";
						paletteFile += rgbValues.Blue + "\r\n";
					}
				}
				saver.save(paletteFile, ".pal");
			}
			
			mSelection.x = mSelectedBlock.x;
			mSelection.y = mSelectedBlock.y;
		}
		
	}

}