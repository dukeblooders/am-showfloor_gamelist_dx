//******************************************************************************
// Left pane arguments
//******************************************************************************
class LeftPaneArgs
{
	contentTransitionFactor = null
	controlArgs = null
	ellipsisDown = null
	ellipsisDown_path = null
	ellipsisUp = null
	ellipsisUp_path = null
	headerMessage = null
	headerMessage_nothing = ":-("
	input_scrollUp = null
	input_scrollDown = null
	loadDelay = 0
	overviewArgs = null
	rect = null
	scrollTransitionFactor = null
	
		
	constructor(_x, _y, _width, _height)
	{
		rect = Rectangle(_x, _y, _width, _height)	
	}
	
	
	function WithContentTransition(_contentTransitionFactor)
	{
		contentTransitionFactor = _contentTransitionFactor / 100.0
		
		return this
	}
	
	
	function WithControls(_controlArgs)
	{
		controlArgs = _controlArgs
		
		return this
	}
	
	
	function WithEllipses(_pathUp, _pathDown, _imageUp, _imageDown)
	{
		ellipsisUp_path = _pathUp
		ellipsisDown_path = _pathDown
		ellipsisUp = _imageUp
		ellipsisDown = _imageDown
		
		return this
	}
		
	
	function WithHeader(_message)
	{
		headerMessage = _message
		
		return this
	}
	
	
	function WithInputs(_scrollUp, _scrollDown, _scrollTransitionFactor)
	{
		input_scrollUp = _scrollUp
		input_scrollDown = _scrollDown
		scrollTransitionFactor = _scrollTransitionFactor / 100.0
		
		return this
	}
	
	
	function WithLoadDelay(_loadDelay)
	{
		loadDelay = _loadDelay
		
		return this
	}
	
		
	function WithOverview(_overviewArgs)
	{
		overviewArgs = _overviewArgs
		
		return this
	}
}


//******************************************************************************
// Left pane
//******************************************************************************
class LeftPane
{
	args = null
	contentType = null
	controls = null
	overview = null
	previousLoad = -1
	surface = null
	transit = null
	
	
	constructor(_args)
	{
		args = _args

		surface = fe.add_surface(args.rect.width, args.rect.height)
		surface.x = args.rect.x
		surface.y = args.rect.y

		if (args.headerMessage != null)
			args.headerMessage.Create("")
		if (args.ellipsisUp != null)
			args.ellipsisUp.Create(args.ellipsisUp_path)
		if (args.ellipsisDown != null)
			args.ellipsisDown.Create(args.ellipsisDown_path)
		if (args.overviewArgs != null)
			overview = Overview(surface, args.overviewArgs)
		if (args.controlArgs != null)
			controls = Controls(surface, args.controlArgs)		
	}
	
	
	function Reload()
	{
		switch (contentType)
		{
			case "overview":
				if (args.headerMessage != null)
					args.headerMessage.SetMessage(args.overviewArgs.headerMessage)
			
				overview.Reload()
				break
		
			case "controls":
				if (args.headerMessage != null)
					args.headerMessage.SetMessage(args.controlArgs.headerMessage)
			
				controls.Reload()
				break
		}
	}
	
	
	function Clear(_var)
	{
		contentType = null
		transit = args.scrollTransitionFactor != null
		args.ellipsisUp.Visible(false)
		args.ellipsisDown.Visible(false)
		
		if (overview != null)
			if (overview.Clear(_var))
			{
				contentType = "overview"
			
				if (args.headerMessage != null)
					args.headerMessage.SetMessage(args.overviewArgs.headerMessage)
			}
			
		if (controls != null)
			if (controls.Clear(_var) && contentType == null)
			{
				contentType = "controls"
				
				if (args.headerMessage != null)
					args.headerMessage.SetMessage(args.controlArgs.headerMessage)
			}
			
		if (args.headerMessage != null && contentType == null)
			args.headerMessage.SetMessage(args.headerMessage_nothing)
	}
	

	function Update(_ttime) 
	{
		if (previousLoad == 0)
		{	
			switch (contentType)
			{
				case "overview":
					if (transit)
					{
						transit = overview.Transit(args.contentTransitionFactor)
						
						if (!transit) UpdateEllipses(overview.GetLayoutText(), overview.minY)
					}
					else if (args.scrollTransitionFactor != null)
						if (fe.get_input_state(args.input_scrollUp))
						{
							overview.ScrollUp(args.scrollTransitionFactor)
							UpdateEllipses(overview.GetLayoutText(), overview.minY)
						}
						else if (fe.get_input_state(args.input_scrollDown))
						{
							overview.ScrollDown(args.scrollTransitionFactor)
							UpdateEllipses(overview.GetLayoutText(), overview.minY)
						}
					break
			
				case "controls":
					if (transit)
					{
						transit = controls.Transit(args.contentTransitionFactor)
						
						if (!transit) UpdateEllipses(controls.surface, controls.minY)
					}
					else if (args.scrollTransitionFactor != null)
						if (fe.get_input_state(args.input_scrollUp))
						{
							controls.ScrollUp(args.scrollTransitionFactor)
							UpdateEllipses(controls.surface, controls.minY)
						}
						else if (fe.get_input_state(args.input_scrollDown))
						{
							controls.ScrollDown(args.scrollTransitionFactor)
							UpdateEllipses(controls.surface, controls.minY)
						}
					break
			}
		}
		else if (_ttime > previousLoad + args.loadDelay)
		{
			previousLoad = 0
			Reload()
		}
	}
	
	
	function UpdateEllipses(_item, _minY)
	{
		if (args.scrollTransitionFactor == null)
			return
	
		if (!transit)
			args.ellipsisUp.Visible(_item.y != _minY)
			
		args.ellipsisDown.Visible(_item.y + _item.height > surface.height)		
	}
	
	
	function Reset(_var, _ttime)
	{
		Clear(_var)
			
		previousLoad = _ttime
	}
}