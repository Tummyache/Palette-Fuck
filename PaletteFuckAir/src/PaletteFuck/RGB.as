package PaletteFuck {
 
public class RGB {
 
private var color:uint;
private var red:int;
private var green:int;
private var blue:int;
/**
* Contructs an RGB object for containing Red Green and Blue values, and
* converting them to a Hex color
* @param r the Red value (0-255)
* @param g the Green value (0-255)
* @param b the Blue value (0-255)
*/
public function RGB(r:Number=0, g:Number=0, b:Number=0) {
Red = r;
Green = g;
Blue = b;
}
 
/*
* Getters for each channel, converts from Hex
*/
public function get Red():int {
return color >> 16;
}
public function get Green():int {
return (color >> 8) & 0xFF;
}
public function get Blue():int {
return color & 0x00FF;
}
/*
*Setters for each channel, converts to Hex
*/
public function set Red(Value:int):void {
red = (Value>255)? 255 : ((Value<0)?0:Value);
color=getHex(red,green,blue);
}
public function set Green(Value:int):void {
green = (Value>255)? 255 : ((Value<0)?0:Value);
color=getHex(red,green,blue);
}
public function set Blue(Value:int):void {
blue = (Value>255)? 255 : ((Value<0)?0:Value);
color=getHex(red,green,blue);
}
/*
* Getter and setter for Hex value
*/
public function get Hex():uint {
return color;
}
public function set Hex(Value:uint):void {
color=Value;
}
 
/**
* A static method for directly converting from Red,Green,and Blue values
* to Hex.
* @param r the Red value (0-255)
* @param g the Green value (0-255)
* @param b the Blue value (0-255)
* @return the Hex value of the specified RGB color
*/
public static function getHex(r:int, g:int, b:int):uint{
return (r<<16)|(g << 8)|b;
}
}
 
}