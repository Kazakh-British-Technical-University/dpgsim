class_name MainGame
extends Node2D

# Dependencies
onready var gameTooltip = 		$Tooltip
onready var teamScreen = 		$TeamScreen
onready var soundManager = 		$Sounds
onready var header = 			$Header
onready var web_interface = 	$WebInterface
onready var main_menu =			$MainMenu
onready var pause_menu = 		$PauseMenu
onready var options_header = 	$OptionsHeader
onready var mm_button = 		$OptionsHeader/HudRight/Margin/MM_Button
onready var map_screen = 		$MapScreen
onready var main_session = 		$MainSession
onready var win_screen = 		$WinScreen

func _ready():
	global.game = self

	yield(web_interface.ConnectToWeb(), "completed")
	yield(web_interface.LoadFiles(), "completed")
		
	main_menu.visible = true
	main_menu.Start()
	pause_menu.Start()
	mm_button.Start()
	header.date_counter.connect("dayTick", main_session, "CheckTime")
	header.date_counter.connect("dayTick", header, "CheckTime")

func StartScenario():
	map_screen.visible = false
	global.curPhaseIndex = 0
	header.Start()
	header.money.SetMoney(global.curScenario()["Money"])
	header.phase_hud.ShowButton(false)
	header.phase_hud.StartPhase()
	header.visible = true
	teamScreen.Start()
	main_session.Start()
	main_session.ResetCounters()
	main_session.FirstStart()
	main_session.visible = true
	global.curPhaseIndex = -1
	gameTooltip.SetTooltip(trans.local("SCENARIO_POPUP_TITLE"), trans.local("SCENARIO_POPUP_DESC"), null)

func StartNextPhase():
	header.phase_hud.StartPhase()
	$Projects.Start()
	yield(get_tree().create_timer(0.1),"timeout")
	$Projects.visible = true

func StartProject():
	$Projects.visible = false
	teamScreen.UpdateAvailableWorkers()
	PauseTimer(false)
	header.StartProject()
	$ActionScreen.Start()
	main_session.StartProject()
	main_session.visible = true

func ProjectComplete():
	main_session.visible = false
	if global.curPhaseIndex == -1:
		AdvancePhase()
		return
	PauseTimer(true)
	global.ApplyInsights()
	header.phase_hud.ShowButton(false)
	if global.curPhaseIndex == 1:
		##################################################
		# print("name your product")
		pass
	AdvancePhase()

func AdvancePhase():
	if global.curPhaseIndex < 8:
		global.curPhaseIndex += 1
		StartNextPhase()
	else:
		Win()

var timerPaused = true
func PauseTimer(pause):
	timerPaused = pause
	if pause:
		header.date_counter.timerOn = false
	else:
		header.date_counter.t = 0
		header.date_counter.timerOn = true

func GameOver():
	PauseTimer(true)
	main_session.office.ClearQueue()
	header.phase_hud.ShowButton(false)
	gameTooltip.closeIsProceed = true
	var callback = funcref(self, "ExitGame")
	gameTooltip.SetTooltip(trans.local("GAME_OVER"), trans.local("GAME_OVER_DESCR"), callback)

func Win():
	win_screen.Start()
	win_screen.visible = true
	win_screen.scores.text = trans.local("SCORES") + ": " + str(CalcScores())

func CalcScores():
	var points = 0
	points += 20 * main_session.counters["Fit"].good
	points -= 25 * main_session.counters["Fit"].bad
	points += 15 * main_session.counters["Dev"].good
	points -= 20 * main_session.counters["Dev"].bad
	points += 10 * main_session.counters["Market"].good
	points -= 15 * main_session.counters["Market"].bad
	if header.totalDays < 336:
		points += (336 - header.totalDays) * 5
		points += 336 * 3
	else:
		if header.totalDays < 672:
			points += (672 - header.totalDays) * 3
	points += header.money.total * 5
	return points



func _on_Start_Button_buttonPressed():
	main_menu.visible = false
	options_header.visible = true
	map_screen.visible = true
	map_screen.Start()

func _on_language_changed(lang):
	yield(web_interface.ChangeLanguage(lang), "completed")
	var _reload = get_tree().reload_current_scene()

func PauseGame(pause):
	if not timerPaused:
		if pause:
			header.date_counter.timerOn = false
		else:
			header.date_counter.t = 0
			header.date_counter.timerOn = true
	pause_menu.visible = pause

func ExitGame():
	PauseTimer(true)
	global.ResetGame()
	header.phase_hud.ResetPhases()
	for child in get_children():
		if !(child is CanvasItem || child is CanvasLayer):
			continue
		child.visible = false
	pause_menu.visible = false
	main_menu.visible = true

func HireWorker(quantity):
	header.money.AddBurn(int(global.mainConfig["Salary"]) * quantity)
	main_session.office.UpdateMinis()

func OpenTeamScreen(open):
	PauseTimer(open)
	teamScreen.visible = open
	main_session.visible = not open
	if not open:
		header.money.SetMaxBurn()

func OpenActionScreen(open):
	PauseTimer(open)
	$ActionScreen.visible = open
	main_session.visible = not open
	header.visible = not open
	
func Overtime():
	header.phase_hud.OverTime()

func CheckEvents(day):
	$EventManager.CheckEvents(day)

func AddMoney(amount):
	header.money.AddMoney(amount)
