//******************************************************************************
// Wheel slot arguments
//******************************************************************************
class WheelSlotArgs
{
	transition_delay = null
	wheelImages = null
	wheelPath = null	

	constructor(_wheelPath, _wheelImages)
	{
		wheelPath = _wheelPath
		wheelImages = _wheelImages
	}
	
	function WithTransition(_transition_delay)
	{
		transition_delay = _transition_delay
		
		return this
	}
}


//******************************************************************************
// Wheel slot
//******************************************************************************
class WheelSlot extends ConveyorSlot
{
	args = null
	imageCount = null
	imageMaxIndex = null
	path = null


	constructor(_args, _imageExtension)
	{
		args = _args
		
		base.constructor(fe.add_image(args.wheelPath + _imageExtension))
		m_obj.preserve_aspect_ratio = true
		
		imageCount = args.wheelImages.len() 
		imageMaxIndex = imageCount - 1
	}
	
	
	function on_progress(_progress, _var)
	{	
		local progress = _progress * imageCount
		if (progress < 0) return  // Ignore the first image moving to top
		
		local index = progress.tointeger()		
		if (index >= imageMaxIndex) 
			index = imageMaxIndex
		
		// The middle image is not at index zero, we must fix the progress manually 
		_progress -= index * 1.0 / imageCount
			
		local width = GetWidth(index, _progress)
		local height = width * args.wheelImages[index].rect.height / args.wheelImages[index].rect.width

		m_obj.x = GetX(index, width, _progress)
		m_obj.y = GetY(index, height, _progress)
		m_obj.width = width
		m_obj.height = height
		m_obj.rotation = GetRotation(index, _progress)
		m_obj.alpha = GetAlpha(index, _progress)
		m_obj.zorder = GetZOrder(index, _progress)
		
		GetColor(index, _progress)
	}
	
	
	function GetX(_index, _width, _progress)
	{
		local x1 = args.wheelImages[_index].rect.x - _width / 2
		local x2 = _index == imageMaxIndex ? x1 : args.wheelImages[_index + 1].rect.x - _width / 2
		
		return x1 + (x2 - x1) * _progress * imageCount
	}
	
	
	function GetY(_index, _height, _progress)
	{
		local y1 = args.wheelImages[_index].rect.y - _height / 2
		local y2 = _index == imageMaxIndex ? y1 : args.wheelImages[_index + 1].rect.y - _height / 2
				
		return y1 + (y2 - y1) * _progress * imageCount
	}
	

	function GetWidth(_index, _progress)
	{
		local w1 = args.wheelImages[_index].rect.width
	
		if (_progress == 0 || _index != imageMaxIndex / 2) // Don't apply on the middle object when moving
			return w1
		else
			return _index == imageMaxIndex ? w1 : args.wheelImages[_index + 1].rect.width
	}
	
	
	function GetRotation(_index, _progress)
	{
		local r1 = args.wheelImages[_index].rotation
		local r2 = _index == imageMaxIndex ? r1 : args.wheelImages[_index + 1].rotation
	
		return r1 + (r2 - r1) * _progress * imageCount
	}	
	
	
	function GetAlpha(_index, _progress)
	{
		local a1 = args.wheelImages[_index].alpha
	
		if (_progress == 0 || _index != imageMaxIndex / 2) // Don't apply on the middle object when moving
			return a1
		else 
			return _index == imageMaxIndex ? a1 : args.wheelImages[_index + 1].alpha
	}
	
	
	function GetZOrder(_index, _progress)
	{
		local z1 = args.wheelImages[_index].zorder
		local z2 = _index == imageMaxIndex ? z1 : args.wheelImages[_index + 1].zorder
	
		return z1 + (z2 - z1) * _progress * imageCount
	}	
	
	
	function GetColor(_index, _progress)
	{
		local c1 = args.wheelImages[_index].color
	
		if (_progress == 0 || _index != imageMaxIndex / 2)
		{
			m_obj.red = c1.red
			m_obj.green = c1.green
			m_obj.blue = c1.blue
		}
		else if (_index == imageMaxIndex)
		{
			m_obj.red = args.wheelImages[_index + 1].color.red
			m_obj.green = args.wheelImages[_index + 1].color.green
			m_obj.blue = args.wheelImages[_index + 1].color.blue
		}
		else
		{
			m_obj.red = c1.red
			m_obj.green = c1.green
			m_obj.blue = c1.blue
		}
	}
	

	function SetImage(_path)
	{
		if (path == null)
			path = m_obj.file_name
	
		m_obj.file_name = _path
	}
	
	
	function Reset()
	{
		if (path != null)
		{
			m_obj.file_name = path
			path = null
		}
	}
}