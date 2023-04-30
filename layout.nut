//******************************************************************************
// Modules
//******************************************************************************
fe.load_module("conveyor");
fe.load_module("file")

fe.do_nut("preserve.nut")
fe.do_nut("tools.nut")
fe.do_nut("wheel.nut")

fe.do_nut("overview.nut")
fe.do_nut("controls.nut")
fe.do_nut("leftPane.nut")

fe.do_nut("snapshot.nut")
fe.do_nut("video.nut")
fe.do_nut("box.nut")
fe.do_nut("middlePane.nut")


//******************************************************************************
// Settings
//******************************************************************************
local baseWidth = 1920
local imageExtension = ".png"

local backgroundImage = Image(0, 0, 1, 1, false)
local backgroundImage_path = "./backgrounds/background" + imageExtension
local categoryText = Text(0.341, 0.118, 0.307, 0.03)
	.WithAlign(Align.Left)
	.WithCharSize(18, baseWidth)
local categoryCaptionText = Text(0.225, 0.118, 0.11, 0.03)
	.WithAlign(Align.Left)
	.WithCharSize(18, baseWidth)
	.WithColor(150, 150, 150)
local categoryCaptionText_displayMsg = "Catégorie(s)"
local clockText = Text(0.676, 0.94, 0.029, 0.035)
	.WithCharSize(18, baseWidth)
local font_path = "OpenSans-Bold.ttf"
local gameCountText = Text(0.961, 0.695, 0.027, 0.02)
	.WithCharSize(18, baseWidth)
local gameText = Text(0.218, 0.022, 0.442, 0.05)
	.WithCharSize(24, baseWidth)
	.WithColor(250, 170, 35)
	.WithStyle(Style.Bold)
local languageText = Text(0.08, 0.895, 0.112, 0.035)
	.WithAlign(Align.Left)
	.WithCharSize(18, baseWidth)
local languageText_replacers = Replacer("JP", "Japonais")	
	.Add("EN", "Anglais")
	.Add("FR", "Français")
local languageCaptionText = Text(0.019, 0.895, 0.052, 0.035)
	.WithAlign(Align.Left)
	.WithCharSize(18, baseWidth)
	.WithColor(150, 150, 150)
local yearText = Text(0.341, 0.154, 0.307, 0.03)
	.WithAlign(Align.Left)
	.WithCharSize(18, baseWidth)
local languageCaptionText_displayMsg = "Langue(s)"
local leftPane_args = LeftPaneArgs(0.022, 0.286, 0.172, 0.561)
	.WithContentTransition(5)
	.WithControls(ControlArgs("../Roms/%s/media/controls/%s.txt", "Contrôles", 0.025, ";")
		.WithButtons("../buttons/%s" + imageExtension, 0.004, '$',
			Image(0, 0, 0.025, 0.0444, false))
		.WithGroupTextTemplate(0.04,
			Text(0, 0, 0, 0)
				.WithAlign(Align.Left)
				.WithColor(250, 170, 35)
				.WithBackgroundColor(25, 25, 25, 200)
				.WithCharSize(20, baseWidth)
				.WithMargin(0.005))
		.WithRowIndent(0.0074)
		.WithTextTemplate(
			Text(0, 0, 0, 0)
				.WithAlign(Align.TopLeft)
				.WithBackgroundColor(75, 75, 75, 100)
				.WithCharSize(18, baseWidth)
				.WithMargin(0.005)
				.WithWordWrap(true)))
	.WithEllipses("./backgrounds/arrowUp" + imageExtension, "./backgrounds/arrowDown" + imageExtension,
		Image(0.023, 0.257, 0.172, 0.015, true),
		Image(0.022, 0.86, 0.172, 0.015, true))
	.WithHeader(
		Text(0.022, 0.215, 0.172, 0.045)
			.WithCharSize(24, baseWidth)
			.WithColor(150, 150, 150)
			.WithStyle(Style.Bold))
	.WithInputs("custom1", "custom2", 0.3)
	.WithLoadDelay(500)
	.WithOverview(OverviewArgs("./scraper/%s/overview/%s.txt", 0.0232, "Description",
		Text(0, 0, 0.172, 0)
			.WithAlign(Align.TopLeft)
			.WithCharSize(18, baseWidth)
			.WithWordWrap(true)))
local manufacturerText = Text(0.341, 0.081, 0.307, 0.03)
	.WithAlign(Align.Left)
	.WithCharSize(18, baseWidth)
local manufacturerCaptionText = Text(0.225, 0.081, 0.11, 0.03)
	.WithAlign(Align.Left)
	.WithCharSize(18, baseWidth)
	.WithColor(150, 150, 150)
local manufacturerCaptionText_displayMsg = "Produit par"
local middlePane_args = MiddlePaneArgs(Image(0.23, 0.286, 0.419, 0.649, true))
	.WithBox(BoxArgs("../Roms/%s/media/box", "Boîtier", 95, imageExtension)		// 95 = '_'
		.WithSystemHeaderMessage("arcade", "Flyer")
		.WithWheel("../Roms/%s/media/wheel", "Logo alternatif"))
	.WithHeader(
		Text(0.23, 0.215, 0.419, 0.045)
			.WithCharSize(24, baseWidth)
			.WithColor(150, 150, 150)
			.WithStyle(Style.Bold))
	.WithInputs("custom4", "custom5", 400)
	.WithLoadDelay(400)
	.WithPaging("%s / %s",
		Text(0.23, 0.94, 0.419, 0.035)
			.WithCharSize(18, baseWidth)
			.WithColor(150, 150, 150))
	.WithSnapshot(SnapshotArgs("../Roms/%s/media/images", "Instantané", imageExtension))
	.WithSwapDelay(2000)
	.WithVideo(VideoArgs("../Roms/%s/media/videos", "Extrait vidéo", ".mp4"))
local pageSize = 7
local playerCaptionText = Text(0.019, 0.94, 0.052, 0.035)
	.WithAlign(Align.Left)
	.WithCharSize(18, baseWidth)
	.WithColor(150, 150, 150)
local playerText = Text(0.08, 0.94, 0.112, 0.035)
	.WithAlign(Align.Left)
	.WithCharSize(18, baseWidth)
local playerText_replacers = Replacer("alt", "en alternance")	
local playerCaptionText_displayMsg = "Joueur(s)"
local scrollbarImage = Image(0.96, 0, 0.029, 0.052, false)
local scrollbarImage_path = "./backgrounds/scroll" + imageExtension
local scrollbarImage_maxY = 0.665
local scrollbarImage_minY = 0.335
local scrollbarImage_transitionFactor = 30
local scrollbarText = Text(0.96, 0, 0.029, 0.052)
	.WithCharSize(14, baseWidth)
	.WithColor(0, 0, 0)
local systemImage = Image(0.01, 0.019, 0.197, 0.171, true)
local systemImage_path = "../showfloor/platforms/%s" + imageExtension
local wheel_args = WheelSlotArgs("../../../Roms/[Extra]/media/wheel/[Name]", [
		Image(0.91, -0.15, 0.18, 0.16, false)	// Out of screen (top)
			.WithColor(75, 75, 75)
			.WithRotation(12)
			.WithZOrder(0),
		Image(0.871, 0.04, 0.18, 0.16, false)
			.WithColor(100, 100, 100)
			.WithRotation(9)
			.WithZOrder(1),
		Image(0.84, 0.155, 0.18, 0.16, false)
			.WithColor(125, 125, 125)
			.WithRotation(6)
			.WithZOrder(2),
		Image(0.812, 0.27, 0.18, 0.16, false)
			.WithColor(150, 150, 150)
			.WithRotation(3)
			.WithZOrder(4),
		Image(0.807, 0.5, 0.235, 0.205, false)
			.WithZOrder(5),	// Middle
		Image(0.808, 0.74, 0.18, 0.16, false)
			.WithColor(150, 150, 150)
			.WithRotation(-3)
			.WithZOrder(3),		
		Image(0.832, 0.855, 0.18, 0.16, false)
			.WithColor(125, 125, 125)
			.WithRotation(-6)
			.WithZOrder(2),
		Image(0.859, 0.97, 0.18, 0.16, false)
			.WithColor(100, 100, 100)
			.WithRotation(-9)
			.WithZOrder(1),			
		Image(0.9, 1.2, 0.18, 0.16, false)	// Out of screen (bottom)
			.WithColor(75, 75, 75)
			.WithRotation(-12)
			.WithZOrder(0),
		])
	.WithTransition(200)
local yearText = Text(0.341, 0.154, 0.307, 0.03)
	.WithAlign(Align.Left)
	.WithCharSize(18, baseWidth)
local yearCaptionText = Text(0.225, 0.154, 0.11, 0.03)
	.WithAlign(Align.Left)
	.WithCharSize(18, baseWidth)
	.WithColor(150, 150, 150)
local yearCaptionText_displayMsg = "Année de sortie"
		
	
//******************************************************************************
// Variables
//******************************************************************************
local clockTime = null
local current_ttime = null
local leftPane = null
local middlePane = null
local scrollSurface = null
local scrollSurface_index = null
local scrollSurface_y = null
local wheelMiddleSlot = null


//******************************************************************************
// Clock
//******************************************************************************
function InitClock()
{
	clockText.Create("")
}


function UpdateClock()
{
	local now = date();
	local time = format("%02i", now.hour) + ":" + format("%02i", now.min)
	
	if (clockTime != time)
	{
		clockText.SetMessage(time)
		clockTime = time
	}
}


//******************************************************************************
// Languages
//******************************************************************************
function ResetLanguages(_var)
{
	local value = fe.game_info(Info.Language, _var)
		
	if (languageText_replacers != null)
		value = languageText_replacers.Replace(value)

	languageText.SetMessage(value)
}


//******************************************************************************
// Players
//******************************************************************************
function ResetPlayers(_var)
{
	local value = fe.game_info(Info.Players, _var)
		
	if (playerText_replacers != null)
		value = playerText_replacers.Replace(value)

	playerText.SetMessage(value)
}


//******************************************************************************
// Scrollbar
//******************************************************************************
function InitScrollbar()
{
	scrollSurface = fe.add_surface(scrollbarImage.rect.width, scrollbarImage.rect.height)
	scrollSurface.x = scrollbarImage.rect.x
	
	scrollbarImage.rect.x = 0
	scrollbarImage.rect.y = 0	
	scrollbarImage.Create(scrollbarImage_path, scrollSurface)
	
	scrollbarText.rect.x = 0
	scrollbarText.rect.y = 0	
	scrollbarText.Create("[ListEntry]", scrollSurface)

	scrollbarImage_minY = fe.layout.height * scrollbarImage_minY
	scrollbarImage_maxY = fe.layout.height * scrollbarImage_maxY - scrollbarImage.rect.height
	scrollbarImage_transitionFactor /= 100.0
}


function ResetScrollbar(_var)
{
	local index = fe.list.index + _var
	local size = fe.list.size
	local height = scrollbarImage_maxY - scrollbarImage_minY
	
	if (index < 0) index += size
	else if (index >= size) index %= size

	scrollSurface_y = scrollbarImage_minY + index * height / (size - 1)
	
	if (scrollSurface_index == null)
		scrollSurface.y = scrollSurface_y
		
	scrollSurface_index = index
}


function UpdateScrollbar()
{
	if (scrollSurface.y == scrollSurface_y)
		return

	local size = fe.list.size
	
	if (scrollSurface.y < scrollSurface_y)
	{
		local diff = (scrollSurface_y - scrollSurface.y) * scrollbarImage_transitionFactor
	
		scrollSurface.y = scrollSurface.y + diff > scrollSurface_y ?
			scrollSurface_y :
			scrollSurface.y + diff
	}
	else
	{
		local diff = (scrollSurface.y - scrollSurface_y) * scrollbarImage_transitionFactor
	
		scrollSurface.y = scrollSurface.y - diff < scrollSurface_y ?
			scrollSurface_y :
			scrollSurface.y - diff
	}
}


//******************************************************************************
// System
//******************************************************************************
function InitSystem()
{
	systemImage.Create("")
}


function ResetSystem(_var)
{
	local name = format(systemImage_path, fe.list.name)

	systemImage.SetName(name)
}

	
//******************************************************************************
// Wheel
//******************************************************************************
function InitWheel()
{
	local slots = []
	for (local i = 0; i < wheel_args.wheelImages.len(); i++)
		slots.push(WheelSlot(wheel_args, imageExtension))

	wheelMiddleSlot = slots[(slots.len() - 1) / 2]

	local conveyor = Conveyor()
	conveyor.set_slots(slots)
	conveyor.transition_ms = wheel_args.transition_delay
}


//******************************************************************************
// Init
//******************************************************************************
fe.layout.font = font_path
fe.layout.page_size = pageSize

backgroundImage.Create(backgroundImage_path)
categoryText.Create("[Category]");
categoryCaptionText.Create(categoryCaptionText_displayMsg)
gameCountText.Create("[ListSize]")
gameText.Create("[Title]")
languageText.Create("")
languageCaptionText.Create(languageCaptionText_displayMsg)
manufacturerText.Create("[Manufacturer]")
manufacturerCaptionText.Create(manufacturerCaptionText_displayMsg)
playerText.Create("")
playerCaptionText.Create(playerCaptionText_displayMsg)
yearText.Create("[Year]")
yearCaptionText.Create(yearCaptionText_displayMsg)

InitClock()
InitScrollbar()
InitWheel()
InitSystem()

leftPane = LeftPane(leftPane_args)
middlePane = MiddlePane(middlePane_args, wheelMiddleSlot)

current_ttime = 0
fe.add_ticks_callback("TicksCallback")
fe.add_ticks_callback("TicksCallbackClock")
fe.add_ticks_callback("TicksCallbackScrollbar")
fe.add_transition_callback("TransitionCallback")


//******************************************************************************
// Callbacks
//******************************************************************************
function TicksCallback(_ttime)
{
	current_ttime = _ttime

	leftPane.Update(_ttime)
	middlePane.Update(_ttime)
}


function TicksCallbackClock(_ttime)
{
	UpdateClock()
}


function TicksCallbackScrollbar(_ttime)
{
	UpdateScrollbar()
}


function TransitionCallback(_ttype, _var, _ttime) 
{
	switch(_ttype) 
	{	
		case Transition.FromGame:
			fe.signal("reload")
			break
	
		case Transition.ToNewList:
			ResetLanguages(_var)
			ResetPlayers(_var)
			ResetSystem(_var)
			ResetScrollbar(_var)
			
			wheelMiddleSlot.Reset()
			leftPane.Reset(_var, -1)	
			middlePane.Reset(_var, -1, true)
			break
			
		case Transition.ToNewSelection:
			ResetLanguages(_var)
			ResetPlayers(_var)	
			ResetScrollbar(_var)

			wheelMiddleSlot.Reset()
			leftPane.Reset(_var, current_ttime)		
			middlePane.Reset(_var, current_ttime, false)			
			break
	}
}
