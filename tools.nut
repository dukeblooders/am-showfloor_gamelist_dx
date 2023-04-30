//******************************************************************************
// Color
//******************************************************************************
class Color
{
	red = 0
	blue = 0
	green = 0
	alpha = 0
		
	constructor(_red, _green, _blue, _alpha = 255)
	{
		red = _red
		green = _green
		blue = _blue
		alpha = _alpha
	}
	
	function Apply(_obj)
	{
		_obj.red = red
		_obj.blue = blue
		_obj.green = green
		_obj.alpha = alpha
	}
	
	
	function ApplyBackground(_obj)
	{
		_obj.bg_red = red
		_obj.bg_blue = blue
		_obj.bg_green = green
		_obj.bg_alpha = alpha
	}
}


//******************************************************************************
// Game
//******************************************************************************
class Game
{
	name = null
	manufacturer = null
	extra = null
}


//******************************************************************************
// Image
//******************************************************************************
class Image
{
	alpha = 255
	color = Color(255, 255, 255)
	image = null
	name = null
	pinch_x = 0
	pinch_y = 0
	preserve = null
	rect = null
	rotation = 0
	skew_x = 0
	skew_y = 0
	zorder = 0
	
	
	constructor(_x, _y, _width, _height, _preserve, _fixedRect = false)
	{
		preserve = _preserve
		rect = _fixedRect ? FixedRectangle(_x, _y, _width, _height) : Rectangle(_x, _y, _width, _height)
	}
	
	function WithAlpha(_alpha)
	{
		alpha = _alpha
	
		return this
	}
	
	function WithColor(_red, _green, _blue)
	{
		color = Color(_red, _green, _blue)
	
		return this
	}
	
	function WithPinch(_pinch_x, _pinch_y)
	{
		pinch_x = fe.layout.width * _pinch_x
		pinch_y = fe.layout.height * _pinch_y
	
		return this
	}
	
	function WithSkew(_skew_x, _skew_y)
	{
		skew_x = fe.layout.width * _skew_x
		skew_y = fe.layout.height * _skew_y
	
		return this
	}
	
	function WithRotation(_rotation)
	{
		rotation = _rotation
	
		return this
	}
	
	function WithZOrder(_zorder)
	{
		zorder = _zorder
	
		return this
	}
	
	function Create(_name, _parent = ::fe)
	{
		if (_name == null)
			_name = ""
		name = _name
	
		if (preserve)
			image = PreserveImage(_name, rect.x, rect.y, rect.width, rect.height, _parent)
		else
			image = _parent.add_image(_name, rect.x, rect.y, rect.width, rect.height)
		
		image.alpha = alpha
		image.pinch_x = pinch_x
		image.pinch_y = pinch_y
		image.skew_x = skew_x
		image.skew_y = skew_y
		image.rotation = rotation
			
		image.red = color.red
		image.green = color.green
		image.blue = color.blue
		
		if (preserve)
			image.update()
	}
	
	function GetLayoutImage()
	{
		return preserve ? image.surface : image
	}
	
	function SetName(_name)
	{
		name = _name
	
		if (preserve)
		{
			image.art.file_name = _name
			image.update()
		}
		else
			image.file_name = _name
	}
	
	function VideoPlaying(_value)
	{
		if (preserve)
			image.art.video_playing = _value
		else
			image.video_playing = _value
	}
	
	function Visible(_value)
	{
		if (preserve)
			image.art.visible = _value
		else
			image.visible = _value
	}
}


//******************************************************************************
// Rectangle
//******************************************************************************
class Rectangle
{
	x = null
	y = null
	width = null
	height = null
	
	constructor(_x, _y, _width, _height)
	{
		x = fe.layout.width * _x
		y = fe.layout.height * _y
		width = fe.layout.width * _width
		height = fe.layout.height * _height
	}
}


class FixedRectangle extends Rectangle
{
	constructor(_x, _y, _width, _height)
	{
		x = _x
		y = _y
		width = _width
		height = _height
	}
}


//******************************************************************************
// Replacer
//******************************************************************************
class Replacer
{
	items = []
	
	constructor(_oldValue, _newValue)
	{
		Add(_oldValue, _newValue)
	}
	
	function Add(_oldValue, _newValue)
	{
		items.append(ReplacerItem(_oldValue, _newValue))
		
		return this
	}
	
	function Replace(_value)
	{
		foreach (item in items) {
			local index = _value.find(item.oldValue)
			if (index != null)
				_value = _value.slice(0, index) + item.newValue + _value.slice(index + item.oldValue.len())	
		}
		
		return _value
	}
}


class ReplacerItem
{
	oldValue = null
	newValue = null
	
	constructor(_oldValue, _newValue)
	{
		oldValue = _oldValue
		newValue = _newValue
	}
}


//******************************************************************************
// Text
//******************************************************************************
class Text
{
	align = null
	bgcolor = null
	charSize = null
	color = null
	margin = 0
	rect = null
	style = null
	text = null
	wrap = null
	
		
	constructor(_x, _y, _width, _height, _fixedRect = false)
	{
		rect = _fixedRect ? FixedRectangle(_x, _y, _width, _height) : Rectangle(_x, _y, _width, _height)
	}
	
	function WithAlign(_align)
	{
		align = _align
	
		return this
	}

	function WithBackgroundColor(_red, _green, _blue, _alpha)
	{
		bgcolor = Color(_red, _green, _blue, _alpha)
	
		return this
	}
	
	function WithCharSize(_charSize, _baseWidth)
	{
		charSize = fe.layout.width * _charSize / _baseWidth
	
		return this
	}
	
	function WithColor(_red, _green, _blue)
	{
		color = Color(_red, _green, _blue)
	
		return this
	}
	
	function WithMargin(_margin)
	{
		margin = fe.layout.width * _margin
	
		return this
	}
	
	function WithStyle(_style)
	{
		style = _style
	
		return this
	}
	
	function WithWordWrap(_wrap)
	{
		wrap = _wrap
	
		return this
	}
	
	function Create(_msg, _parent = ::fe)
	{
		if (_msg == null)
			_msg = ""	
	
		text = _parent.add_text(_msg, rect.x, rect.y, rect.width, rect.height)
		text.margin = margin
		if (align != null) text.align = align
		if (bgcolor != null) bgcolor.ApplyBackground(text)
		if (color != null) color.Apply(text)
		if (charSize != null) text.charsize = charSize
		if (style != null) text.style = style
		if (wrap != null) text.word_wrap = wrap
	}
		
	function GetLayoutText()
	{
		return text
	}
	
	function GetWrappedMessage()
	{
		return text.msg_wrapped 
	}
		
	function IsVisible()
	{
		return text.visible
	}
	
	function SetMessage(_msg)
	{
		text.msg = _msg
	}
	
	function Visible(_value)
	{
		text.visible = _value
	}
}