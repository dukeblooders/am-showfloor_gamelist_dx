//******************************************************************************
// Video arguments
//******************************************************************************
class VideoArgs
{
	headerMessage = null
	videoExtension = null
	path = null
	

	constructor(_path, _headerMessage, _videoExtension)
	{
		path = _path
		headerMessage = _headerMessage
		videoExtension = _videoExtension
	}
}


//******************************************************************************
// Video
//******************************************************************************
class Video
{
	args = null
	pathPrefix = null
	
	
	constructor(_args, _pathPrefix)
	{
		args = _args
		pathPrefix = _pathPrefix == null ? "" : _pathPrefix
	}
	
	
	function GetVideoPath(_system, _name)
	{
		local path = format(args.path, _system) + "/" + _name + args.videoExtension
	
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