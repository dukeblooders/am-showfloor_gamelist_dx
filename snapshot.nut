//******************************************************************************
// Snapshot arguments
//******************************************************************************
class SnapshotArgs
{
	headerMessage = null
	imageExtension = null
	path = null
	

	constructor(_path, _headerMessage, _imageExtension)
	{
		path = _path
		headerMessage = _headerMessage
		imageExtension = _imageExtension
	}
}


//******************************************************************************
// Snapshot
//******************************************************************************
class Snapshot
{
	args = null
	pathPrefix = null
	
	
	constructor(_args, _pathPrefix)
	{
		args = _args
		pathPrefix = _pathPrefix == null ? "" : _pathPrefix
	}
	
	
	function GetImagePath(_system, _name)
	{
		local path = format(args.path, _system) + "/" + _name + args.imageExtension
	
		try 
		{
			file(path, "r")
			
			return pathPrefix + path
		}
		catch(e)
		{
			return null
		}
	}
}