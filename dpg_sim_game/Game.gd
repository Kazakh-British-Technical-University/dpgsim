class_name MainGame
extends Node2D

onready var gameTooltip = $Tooltip
onready var dateCounter = $Header/DateCounter
func _ready():
	global.game = self
	$WebInterface.ConnectToWeb()
	yield(get_tree().create_timer(0.1),"timeout")
	LoadFiles()
	yield(get_tree().create_timer(1),"timeout")
	$MainMenu.visible = true
	$MainMenu.Start()
	$MM_Button.Start()
	dateCounter.connect("dayTick", $MainSession, "GenPoints")
	dateCounter.connect("dayTick", self, "CheckTime")

func LoadFiles():
	$WebInterface.LoadTranslations()
	$WebInterface.LoadMainConfig()
	$WebInterface.LoadScenarios()
	$WebInterface.LoadProjects()

func StartScenario():
	$MapScreen.visible = false
	global.curPhaseIndex = 0
	$Header.Start()
	$Header/Money.SetMoney(global.curScenario()["Money"])
	$Header.visible = true
	StartNextPhase()

func StartNextPhase():
	$Header.StartPhase()
	$Projects.Start()
	$Projects.visible = true

func StartProject():
	PauseTimer(false)
	$Projects.visible = false
	$Header.StartProject()
	$MainSession.Start()
	$MainSession.visible = true

func ProjectComplete():
	PauseTimer(true)
	curDays = 0
	global.ApplyInsights()
	$MainSession.visible = false
	if (global.curPhaseIndex < 8):
		global.curPhaseIndex += 1
		StartNextPhase()
	else:
		print("You win")

func PauseTimer(pause):
	if pause:
		dateCounter.timerOn = false
	else:
		dateCounter.t = 0
		dateCounter.timerOn = true

var curDays = 0
func CheckTime():
	curDays += 1
	$Header.UpdateProgress(int(global.curProject["TimeCost"]) - curDays)
	if curDays == int(global.curProject["TimeCost"]):
		$Header.PhaseComplete()

func _on_Start_Button_buttonPressed():
	$MainMenu.visible = false
	$MM_Button.visible = true
	$MapScreen.visible = true
	$MapScreen.Start()

func _on_MM_Button_buttonPressed():
	PauseTimer(true)
	global.ResetGame()
	for child in get_children():
		child.visible = false
	
	$MainMenu.visible = true
