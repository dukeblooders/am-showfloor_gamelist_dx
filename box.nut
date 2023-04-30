//******************************************************************************
// Box arguments
//******************************************************************************
class BoxArgs
{
	headerMessage = null
	imageExtension = null
	imageSeparator = null
	boxPath = null
	systemHeaderMessages = null
	wheelPath = null
	wheelHeaderMessage = null
	

	constructor(_path, _headerMessage, _imageSeparator, _imageExtension)
	{
		boxPath = _path
		headerMessage = _headerMessage
		imageExtension = _imageExtension
		imageSeparator = _imageSeparator
		systemHeaderMessages = []
	}
	
	
	function WithSystemHeaderMessage(_system, _headerMessage)
	{
		systemHeaderMessages.append(BoxSystemArgs(_system, _headerMessage))
	
		return this
	}	
	
	
	function WithWheel(_path, _headerMessage)
	{
		wheelPath = _path
		wheelHeaderMessage = _headerMessage
	
		return this
	}	
}


//******************************************************************************
// Box system arguments
//******************************************************************************
class BoxSystemArgs
{
	headerMessage = null
	system = null

	constructor(_system, _headerMessage)
	{
		system = _system
		headerMessage = _headerMessage
	}
}


//******************************************************************************
// Box
//******************************************************************************
class Box
{
	args = null
	pathPrefix = null
	
	
	constructor(_args, _pathPrefix)
	{
		args = _args
		pathPrefix = _pathPrefix == null ? "" : _pathPrefix
	}
	
	
	function GetContent(_systemObj, _name)
	{
		local items = []
	
		if (_systemObj.imageFiles[_name[0]] != null)
			foreach (boxFile in _systemObj.imageFiles[_name[0]])
			{
				local regex = regexp(_name).capture(boxFile)
				
				if (regex != null)
				{
					local path = format(pathPrefix + args.boxPath, _systemObj.system)
				
					GetItem(items, path, _name, boxFile, false)
				}
			}
			
		if (args.wheelPath != null && _systemObj.wheelFiles[_name[0]] != null)
			foreach (wheelFile in _systemObj.wheelFiles[_name[0]])
			{
				local regex = regexp(_name).capture(wheelFile)
				
				if (regex != null)
				{
					local path = format(pathPrefix + args.wheelPath, _systemObj.system)
				
					GetItem(items, path, _name, wheelFile, true)
				}
			}
			
		return items
	}
	
	
	function GetItem(_items, _path, _name, _filename, _isWheel)
	{
		if (_filename == _name + args.imageExtension) 		// Matches the name exactly (ignored for wheel, already displayed)
		{
			if (!_isWheel)
				_items.append(MiddlePaneItem("box", _path + "/" + _filename))
				
			return		
		}
				
		local length = _name.len()
		if (_filename[length] == args.imageSeparator) 		// Matches name + separator (ex. name_)
		{
			local index = _filename.find(".", length + 1)
			local value = _filename.slice(length + 1, index)
		
			if (_isWheel)
			{
				foreach (item in _items)
					if (item.index == value)
					{
						item.wheelPath = _path + "/" + _filename
						return
					}
					
				local item = MiddlePaneItem("wheel", "")
				item.wheelPath = _path + "/" + _filename
				_items.append(item)
			}
			else
			{
				local item = MiddlePaneItem("box", _path + "/" + _filename)
				item.index = value
				_items.append(item)
			}
		}
	}
	
	
	function GetHeaderMessage(_system)
	{
		foreach (systemHeaderMessage in args.systemHeaderMessages)
			if (systemHeaderMessage.system == _system)
				return systemHeaderMessage.headerMessage
	
		return args.headerMessage
	}
	
	
	// Images - Grouped by the first letter to reduce loading times
	function ListFiles(_systemObj)
	{
		local boxFiles = DirectoryListing(format(pathPrefix + args.boxPath, _systemObj.system), false).results
				
		foreach	(file in boxFiles)
		{
			if (_systemObj.imageFiles[file[0]] == null)
				_systemObj.imageFiles[file[0]] = []
		
			_systemObj.imageFiles[file[0]].append(file)
		}
		
		if (args.wheelPath != null)
		{
			local wheelFiles = DirectoryListing(format(pathPrefix + args.wheelPath, _systemObj.system), false).results
					
			foreach	(file in wheelFiles)
			{
				if (_systemObj.wheelFiles[file[0]] == null)
					_systemObj.wheelFiles[file[0]] = []
			
				_systemObj.wheelFiles[file[0]].append(file)
			}
		}
	}
}