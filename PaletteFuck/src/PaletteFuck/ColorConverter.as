package PaletteFuck 
{
	/**
	 * ...
	 * @author Nick Heckman
	 */
	public class ColorConverter 
	{
		
		public function ColorConverter() 
		{
			
		}
		
		public static function hsv2rgb(hue:Number, sat:Number, val:Number) 
		{
			var red:Number, grn:Number, blu:Number, i:Number, f:Number, p:Number, q:Number, t:Number;
			hue%=360;
			if(val==0) {return({r:0, g:0, v:0});}
			sat/=100;
			val/=100;
			hue/=60;
			i = Math.floor(hue);
			f = hue-i;
			p = val*(1-sat);
			q = val*(1-(sat*f));
			t = val*(1-(sat*(1-f)));
			if (i==0) {red=val; grn=t; blu=p;}
			else if (i==1) {red=q; grn=val; blu=p;}
			else if (i==2) {red=p; grn=val; blu=t;}
			else if (i==3) {red=p; grn=q; blu=val;}
			else if (i==4) {red=t; grn=p; blu=val;}
			else if (i==5) {red=val; grn=p; blu=q;}
			red = Math.floor(red*255);
			grn = Math.floor(grn*255);
			blu = Math.floor(blu*255);
			return ({r:red, g:grn, b:blu});
		}
	
	
		public static function rgb2hsv(red:Number, grn:Number, blu:Number) 
		{
			var x:Number, val:Number, f:Number, i:Number, hue:Number, sat:Number, val:Number;
			red/=255;
			grn/=255;
			blu/=255;
			x = Math.min(Math.min(red, grn), blu);
			val = Math.max(Math.max(red, grn), blu);
			if (x==val){
				return({h:undefined, s:0, v:val*100});
			}
			f = (red == x) ? grn-blu : ((grn == x) ? blu-red : red-grn);
			i = (red == x) ? 3 : ((grn == x) ? 5 : 1);
			hue = Math.floor((i-f/(val-x))*60)%360;
			sat = Math.floor(((val-x)/val)*100);
			val = Math.floor(val*100);
			return({h:hue, s:sat, v:val});
		}
		
		public static function rgb2Hex (r, g, b)
		{
			return(r<<16 | g<<8 | b);
		}
		
		public static function obj2Hex (obj:Object)
		{
			return(obj.r<<16 | obj.g<<8 | obj.b);
		}
	}
}