//******************************************************************************
// Middle pane arguments
//******************************************************************************
class MiddlePaneArgs
{
	boxArgs = null
	headerMessage = null
	headerMessage_nothing = ":-("
	image = null
	inputDelay = 0
	inputPrevious = null
	inputNext = null
	loadDelay = 0
	pathPrefix = "../../"
	pagingFormat = null
	pagingText = null
	snapshotArgs = null
	swapDelay = 0
	videoArgs = null


	constructor(_image)
	{
		image = _image
	}
	
	
	function WithBox(_boxArgs)
	{
		boxArgs = _boxArgs
		
		return this
	}
	
	
	function WithHeader(_message)
	{
		headerMessage = _message
		
		return this
	}
	
	
	function WithInputs(_previous, _next, _delay)
	{
		inputPrevious = _previous
		inputNext = _next
		inputDelay = _delay
		
		return this
	}
	
	
	function WithLoadDelay(_loadDelay)
	{
		loadDelay = _loadDelay
		
		return this
	}
	
	
	function WithPaging(_format, _text)
	{
		pagingFormat = _format
		pagingText = _text
		
		return this
	}
	
	
	function WithSnapshot(_snapshotArgs)
	{
		snapshotArgs = _snapshotArgs
		
		return this
	}
	
	
	function WithSwapDelay(_swapDelay)
	{
		swapDelay = _swapDelay
		
		return this
	}
	
	
	function WithVideo(_videoArgs)
	{
		videoArgs = _videoArgs
		
		return this
	}
}


//******************************************************************************
// Middle pane system
//******************************************************************************
class MiddlePaneSystem
{
	system = null
	imageFiles = null
	wheelFiles = null
	
	constructor(_system)
	{
		system = _system
		imageFiles = array(255)
		wheelFiles = array(255)
	}	
}


//******************************************************************************
// Middle pane item
//******************************************************************************
class MiddlePaneItem
{
	index = null
	path = null
	type = null
	wheelPath = null
	
	
	constructor(_type, _path)
	{
		type = _type
		path = _path
	}	
}


//******************************************************************************
// Middle pane
//******************************************************************************
class MiddlePane
{
	args = null
	autoSwap = true
	box = null
	boxMode = false
	itemIndex = -1
	items = null
	lastReload = -1
	systemObjs = null
	previousLoad = -1
	previousTick = 0
	snapshot = null
	video = null
	wheel = null
	wheelMiddleSlot = null
	

	constructor(_args, _wheelMiddleSlot)
	{
		args = _args
		wheelMiddleSlot = _wheelMiddleSlot
		
		args.image.Create("")
		args.image.Visible(false)
		
		if (args.headerMessage != null)
			args.headerMessage.Create("")
		if (args.pagingText != null)
			args.pagingText.Create("")
		if (args.snapshotArgs != null)
			snapshot = Snapshot(args.snapshotArgs, args.pathPrefix)
		if (args.videoArgs != null)
			video = Video(args.videoArgs, args.pathPrefix)
		if (args.boxArgs != null)
			box = Box(args.boxArgs, args.pathPrefix)
	}
	
	
	function Reload()
	{
		if (itemIndex != -1)
		{
			args.image.SetName(items[itemIndex].path)
		
			if (items[itemIndex].wheelPath == null) 
				wheelMiddleSlot.Reset()	
			else
				wheelMiddleSlot.SetImage(items[itemIndex].wheelPath)			
		}
			
		args.image.Visible(true)
	}
	
	
	function Clear(_var, _systemChange)
	{	
		items = []
		itemIndex = -1
		args.image.SetName("")
		args.image.VideoPlaying(false)
		args.image.Visible(false)
		
		if (systemObjs == null || _systemChange)
			ListSystemFiles()
		
		local system = fe.game_info(Info.Extra, _var)
		local name = fe.game_info(Info.Name, _var)
		
		if (snapshot != null)
			LoadSnapshot(system, name)
		
		if (video != null)
			LoadVideo(system, name)
			
		if (box != null)
			LoadBox(system, name)
				
		if (itemIndex == -1)
		{
			if (args.headerMessage != null)
				args.headerMessage.SetMessage(args.headerMessage_nothing)
				
			UpdatePaging()
		}
		else 
		{
			GoTo(itemIndex, true, false)
		}
	}	
	
		
	function ListSystemFiles()
	{
		systemObjs = []
			
		for (local i = 0; i < fe.list.size; i++)
		{
			local system = fe.game_info(Info.Extra, i)
			if (GetSystem(system) != null)
				continue
			
			local systemObj = MiddlePaneSystem(system)
			systemObjs.append(systemObj)
			
			if (box != null)
				box.ListFiles(systemObj)
		}
	}


	function LoadSnapshot(_system, _name)
	{
		local contentPath = snapshot.GetImagePath(_system, _name)
		
		if (contentPath != null)
		{
			items.append(MiddlePaneItem("snapshot", contentPath))
			
			if (itemIndex == -1)
				itemIndex++
		}
	}


	function LoadVideo(_system, _name)
	{
		local contentPath = video.GetVideoPath(_system, _name)
	
		if (contentPath != null)
		{
			items.append(MiddlePaneItem("video", contentPath))
			
			if (itemIndex == -1)
				itemIndex = items.len() - 1
		}
	}


	function LoadBox(_system, _name)
	{
		local systemObj = GetSystem(_system)
		
		local boxItems = box.GetContent(systemObj, _name)

		if (boxItems.len() != 0)
		{
			local itemCount = items.len()
		
			foreach (boxItem in boxItems)
				items.append(boxItem)
			
			if (itemIndex == -1 || boxMode)
				itemIndex = itemCount
		}		
	}
	
	
	function GetSystem(_system)
	{
		foreach	(systemObj in systemObjs)
			if (systemObj.system == _system)
				return systemObj
			
		return null	
	}
	
	
	function GoTo(_index, _auto, _reload = true)
	{
		local count = items.len()
		
		if (count != 0)
		{
			if (_index < 0)
				_index = count - 1
			if (_index >= count)
				_index = 0
			if (_reload && _index == itemIndex)
				return
		
			itemIndex = _index
			if (!_auto) 
				boxMode = items[itemIndex].type == "box"
		
			switch (items[itemIndex].type)
			{
				case "snapshot":
					args.headerMessage.SetMessage(args.snapshotArgs.headerMessage)
					break
					
				case "video":
					args.headerMessage.SetMessage(args.videoArgs.headerMessage)
					break
					
				case "box":			
					args.headerMessage.SetMessage(box.GetHeaderMessage(fe.game_info(Info.Extra)))
					break
					
				case "wheel":			
					args.headerMessage.SetMessage(args.boxArgs.wheelHeaderMessage)
					break
			}
		}
		
		UpdatePaging()
		if (_reload) Reload()
	}	
	
	
	function SwapToVideo()
	{
		foreach (index, item in items)
		{
			if (item.type == "video")
			{
				itemIndex = index
				args.headerMessage.SetMessage(args.videoArgs.headerMessage)
				
				UpdatePaging()
				Reload()
				break
			}
		}
	}
	
		
	function UpdatePaging() 
	{
		if (args.pagingText == null)
			return
	
		args.pagingText.SetMessage(format(args.pagingFormat, (itemIndex + 1).tostring(), items.len().tostring()))
	}
		

	function Update(_ttime) 
	{
		if (previousLoad == 0)
		{
			if (args.inputPrevious != null && fe.get_input_state(args.inputPrevious))
			{
				if (_ttime > previousTick + args.inputDelay)
				{
					GoTo(itemIndex - 1, false)
					
					autoSwap = false
					previousTick = _ttime
				}
			}
			else if (args.inputNext != null && fe.get_input_state(args.inputNext))
			{	
				if (_ttime > previousTick + args.inputDelay)
				{
					GoTo(itemIndex + 1, false)
					
					autoSwap = false
					previousTick = _ttime
				}
			}
			else if (autoSwap && args.swapDelay != 0 && itemIndex != -1 && items[itemIndex].type == "snapshot")
				if (_ttime > lastReload + args.swapDelay)
				{
					foreach (index, item in items)
						if (item.type == "video")
						{
							GoTo(index, true)
							break
						}
				}
		}
		else if (_ttime > previousLoad + args.loadDelay)
		{
			previousLoad = 0
			lastReload = _ttime
			Reload()
		}
	}
	
	
	function Reset(_var, _ttime, _systemChanged)
	{
		Clear(_var, _systemChanged)
		
		autoSwap = itemIndex != -1 && items[itemIndex].type == "snapshot"
		previousLoad = _ttime
	}
}