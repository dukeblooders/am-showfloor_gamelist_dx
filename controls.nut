//******************************************************************************
// Controls arguments
//******************************************************************************
class ControlArgs
{
	buttonImageIndent = 0
	buttonImagePath = null
	buttonImageTemplate = null
	buttonLinePrefix = null
	groupRowHeight = 0
	groupTextTemplate = null
	headerMessage = null
	lineSeparator = null
	path = null
	rowHeight = 0
	rowIndent = 0
	textTemplate = null
	
		
	constructor(_path, _headerMessage, _rowHeight, _lineSeparator)
	{
		headerMessage = _headerMessage
		path = _path
		rowHeight = fe.layout.height * _rowHeight
		lineSeparator = _lineSeparator
	}	
	
	
	function WithButtons(_buttonImagePath, _buttonImageIndent, _linePrefix, _buttonImageTemplate)
	{
		buttonImagePath = _buttonImagePath
		buttonImageIndent = fe.layout.height * _buttonImageIndent
		buttonLinePrefix = _linePrefix
		buttonImageTemplate = _buttonImageTemplate
		
		return this
	}
	
	
	function WithGroupTextTemplate(_groupRowHeight, _textTemplate)
	{
		groupRowHeight = fe.layout.height * _groupRowHeight
		groupTextTemplate = _textTemplate
		
		return this
	}
	
	
	function WithRowIndent(_indent)
	{
		rowIndent = fe.layout.height * _indent
		
		return this
	}
	
	
	function WithTextTemplate(_textTemplate)
	{
		textTemplate = _textTemplate
		
		return this
	}
}


//******************************************************************************
// Controls
//******************************************************************************
class Controls
{
	args = null
	filePath = null
	minY = 0
	parent = null
	rows = null
	surface = null
	
	
	constructor(_parent, _args)
	{
		parent = _parent
		args = _args
		rows = []
	}
	
	
	function Reload()
	{
		if (filePath == null)
			return
	
		local lines = GetFileContent()
		if (lines.len() != 0)
			UpdateControls(lines)
	}
	
	
	function GetFileContent()
	{
		local lines = []
        local file = ReadTextFile(filePath)
        while (!file.eos())
            lines.append(strip(file.read_line()))
	
		return lines
	}
	
	
	function UpdateControls(_textLines)	
	{	
		local y = 0
		local height = 0

		local lines = []
		foreach (textLine in _textLines)
		{
			local line = ControlLine(textLine, args)
			lines.append(line)
			
			height += line.GetHeight() + args.rowIndent
		}

		surface = parent.add_surface(parent.width, height - args.rowIndent)
		surface.y = parent.height
		
		foreach(i, line in lines)
		{
			if (i >= rows.len())
				rows.append(ControlRow(args))
			
			height = line.GetHeight()
			
			rows[i].UpdateContent(surface, y, line);
			y += height + args.rowIndent
		}
	}
	

	function Clear(_var)
	{
		if (rows != null)
			foreach	(row in rows)
				row.Clear()
	
		if (surface != null)
			surface.visible = false
			
		local extra = fe.game_info(Info.Extra, _var)
		local name = fe.game_info(Info.Name, _var)
		
		filePath = format(args.path, extra, name)
	
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
		if (_transitionFactor == null)
		{
			surface.y = minY
			return false
		}
		else if (surface.y > minY)
		{
			local diff = (fe.layout.height - parent.y) * _transitionFactor
			
			if (surface.y - diff < minY)
			{
				surface.y = minY
				return false
			}
			else
			{
				surface.y = surface.y - diff
			}
		}
		
		return true
	}
	
	
	function ScrollUp(_transitionFactor) 
	{
		if (surface.y == minY)
			return false
		
		local diff = fe.layout.height * _transitionFactor
		surface.y = surface.y + diff > minY ?
			minY :
			surface.y + diff
	}
	
	
	function ScrollDown(_transitionFactor) 
	{	
		if (surface.y + surface.height <= parent.height)
			return false
			
		local diff = fe.layout.height * _transitionFactor
		surface.y = surface.y + surface.height + diff < parent.height ?
			parent.height - surface.height :
			surface.y - diff
	}
}


//******************************************************************************
// Control line
//******************************************************************************
class ControlLine
{
	args = null
	texts = null
	buttons = null
	group = false


	constructor(_line, _args)
	{
		args = _args
		texts = []
		buttons = []
	
		local values = split(_line, _args.lineSeparator)
		
		foreach (value in values)
			if (value[0] == _args.buttonLinePrefix)
				buttons.append(value.slice(1))
			else
				texts.append(strip(value))
				
		group = texts.len() == 1 && buttons.len() == 0
	}
	
	
	function GetHeight()
	{
		if (texts.len() == 0)
			return args.rowHeight
	
		return group ?
			args.groupRowHeight :
			GetTextHeight() + (args.buttonImageTemplate == null ? 0 : args.buttonImageTemplate.rect.height + args.buttonImageIndent * 2)
	}
	
	
	function GetTextHeight()
	{
		return args.rowHeight * texts.len()
	}
	
	
	function GetText()
	{
		local text = "";
		foreach (t in texts)
			text += t + "\n"
			
		return strip(text)
	}
}



//******************************************************************************
// Control row
//******************************************************************************
class ControlRow
{
	args = null
	text = null
	images = null
	

	constructor(_args)
	{
		args = _args
		images = []
	}
	
	
	function UpdateContent(_parent, _y, _line)
	{
		if (_line.texts.len() == 0)
			return
	
		text = Text(0, _y, _parent.width, _line.GetHeight(), true)
	
		if (_line.group)
		{
			if (args.groupTextTemplate != null)
				UpdateText(_parent, args.groupTextTemplate, _line.GetText())
		}
		else 
		{
			if (args.textTemplate != null)
				UpdateText(_parent, args.textTemplate, _line.GetText())
			
			if (args.buttonImageTemplate != null)
				UpdateButtons(_parent, _line.buttons, _y + _line.GetTextHeight() + args.buttonImageIndent)
		}
	}	
	
	
	function UpdateText(_parent, _template, _title)
	{
		if (_template != null)
		{
			text.align = _template.align
			text.bgcolor = _template.bgcolor
			text.charSize = _template.charSize
			text.color = _template.color
			text.margin = _template.margin
			text.style = _template.style
			text.wrap = _template.wrap
		}
		
		text.Create(strip(_title), _parent)
		text.Visible(true)
	}
	
	
	function UpdateButtons(_parent, _buttons, _y)
	{
		local x = args.buttonImageIndent + args.buttonImageTemplate.rect.width
		local imgindex = 0

		for (local i = _buttons.len() - 1; i >= 0; i--)
		{
			if (imgindex >= images.len())
				images.append(Image(0, 0, args.buttonImageTemplate.rect.width, args.buttonImageTemplate.rect.height, args.buttonImageTemplate.preserve, true))
				
			images[imgindex].rect.x = _parent.width - x
			images[imgindex].rect.y = _y
						
			UpdateImage(_parent, images[imgindex], args.buttonImageTemplate, _buttons[i])
			
			x += args.buttonImageIndent + args.buttonImageTemplate.rect.width
			imgindex++
		}
	}
	
	
	function UpdateImage(_parent, _image, _template, _button)
	{
		if (_template != null)
		{
			_image.alpha = _template.alpha
			_image.color = _template.color
			_image.pinch_x = _template.pinch_x
			_image.pinch_y = _template.pinch_y
			_image.rotation = _template.rotation
			_image.skew_x = _template.skew_x
			_image.skew_y = _template.skew_y
			_image.zorder = _template.zorder
		}
		
		_image.Create(format(args.buttonImagePath, _button), _parent)
		_image.Visible(true)
	}
	
	
	function Clear()
	{
		if (text != null)
			text.Visible(false)
			
		if (images != null)
			foreach (image in images)
				image.Visible(false)
	}
}