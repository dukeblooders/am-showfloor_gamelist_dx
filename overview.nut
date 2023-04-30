//******************************************************************************
// Overview arguments
//******************************************************************************
class OverviewArgs
{
	headerMessage = null
	lineHeight = null
	path = null
	resetHeight = null
	text = null
		
		
	constructor(_path, _lineHeight, _headerMessage, _text)
	{
		path = _path
		lineHeight = fe.layout.height * _lineHeight
		headerMessage = _headerMessage
		text = _text
		
		resetHeight = fe.layout.height * 2		// Arbitrary value (~2000 pixels for HD screen)
	}	
}


//******************************************************************************
// Overview
//******************************************************************************
class Overview
{
	args = null
	filePath = null
	minY = 1
	parent = null
	
	
	constructor(_parent, _args)
	{
		parent = _parent
		args = _args

		args.text.rect.height = args.resetHeight
		args.text.Create("", _parent)
	}
	
		
	function GetLayoutText()
	{	
		return args.text.GetLayoutText()	
	}
	
	
	function Reload()
	{
		if (filePath == null)
			return
	
		local overviewText = GetFileContent()
		if (overviewText != null)
			UpdateText(overviewText)
	}
	

	function GetFileContent()
	{	
		local text = ""
		local file = ReadTextFile(filePath)
		while (!file.eos())
			text += file.read_line() + "\n"
	
		return strip(text)
	}
	
	
	function UpdateText(_overviewText)
	{
		local text = GetLayoutText()
		text.height = args.resetHeight		
		
		args.text.SetMessage(_overviewText)
		
		_overviewText = args.text.GetWrappedMessage()
		
		local lineCount = 0
		local nextSeparatorIndex = null
		local lastSeparatorIndex = 0
		
		while ((nextSeparatorIndex = _overviewText.find("\n", lastSeparatorIndex)) != null)
		{
			lineCount++
			lastSeparatorIndex = nextSeparatorIndex + 1
		}
		
		text.height = args.lineHeight * lineCount
		
		args.text.Visible(true)
	}
	
	
	function Clear(_var)
	{
		GetLayoutText().y = parent.height
		args.text.Visible(false)
		
		local emulator = fe.game_info(Info.Emulator, _var)
		local name = fe.game_info(Info.Name, _var)
		
		filePath = format(args.path, emulator, name)
	
		try 
		{
			file(filePath, "r")
			return true
		}
		catch(e)
		{
			return false
		}	
	}	
	

	function Transit(_transitionFactor) 
	{
		local text = GetLayoutText()
	
		if (_transitionFactor == null)
		{
			text.y = args.text.rect.y + minY
			return false
		}
		else if (text.y > minY)
		{
			local diff = (fe.layout.height - parent.y) * _transitionFactor
			
			if (text.y - diff < minY)
			{
				text.y = minY
				return false
			}
			else
			{
				text.y = text.y - diff
			}
		}
		
		return true
	}
	
	
	function ScrollUp(_transitionFactor) 
	{
		local text = GetLayoutText()
		if (text.y == minY)
			return false
		
		local diff = fe.layout.height * _transitionFactor
		text.y = text.y + diff > minY ?
			minY :
			text.y + diff
	}
	
	
	function ScrollDown(_transitionFactor) 
	{
		local text = GetLayoutText()
		if (text.y + text.height <= parent.height)
			return false
			
		local diff = fe.layout.height * _transitionFactor
		text.y = text.y + text.height + diff < parent.height ?
			parent.height - text.height :
			text.y - diff
	}
}