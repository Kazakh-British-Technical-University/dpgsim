extends Node2D

var rng = RandomNumberGenerator.new()
func _ready():
	rng.randomize()

onready var counters = [$FitCounter, $DevCounter, $MarketCounter]
var PGR = 0.0
var NPR = 0.0
var PGR_limit = 0.0
var NPR_limit = 0.0
func Start():
	$Office.Start()
	$Team_Button.Start()
	$Actions_Button.Start()
	
	$FitCounter.text = trans.local("FIT_PTS")
	$DevCounter.text = trans.local("DEV_PTS")
	$MarketCounter.text = trans.local("MARKET_PTS")
	
	PGR = float(global.mainConfig["PGR"])
	NPR = float(global.mainConfig["NPR"])
	PGR_limit = float(global.mainConfig["PGR_limit"])
	NPR_limit = float(global.mainConfig["NPR_limit"])

func StartProject():
	$Team_Button.visible = global.curPhaseIndex > 1
	curDays = 0
	SetProjectProgress()
	$Office.StartProject()
	$FitCounter.present = global.mainConfig["Phases"][global.curPhaseIndex]["Fit"]
	$DevCounter.present = global.mainConfig["Phases"][global.curPhaseIndex]["Dev"]
	$MarketCounter.present = global.mainConfig["Phases"][global.curPhaseIndex]["Market"]
	for counter in counters:
		counter.Start()

func GenPoints():
	for i in range(counters.size()):
		if counters[i].present:
			if global.actionsActive[i]:
				if counters[i].bad > 0:
					CleanNegativePoint(counters[i], i)
			else:
				GenOnePoint(counters[i], i)

func GenOnePoint(counter : PointCounter, ind : int):
	var pBonus : float = global.GetInsight(ind, true)
	var nBonus : float = global.GetInsight(ind, false)
	
	var remainder = PGR + pBonus
	var negChance = clamp(NPR + nBonus, 0, NPR_limit)
	while remainder > 0:
		var pointChance = rng.randf_range(1, 100)
		var temp_PGR = clamp(remainder, 0, PGR_limit)
		#print(counter.name, " | random number:", pointChance, " PGR:", remainder, " clamped PGR: ", temp_PGR)
		if pointChance <= temp_PGR:
			remainder -= temp_PGR
			var negRandom = rng.randf_range(1, 100)
			var isGood = negRandom > negChance
			#print("NPR:", NPR + nBonus, " clamped NPR:", negChance, " random number:", negRandom)
			$Office.EnqueuePoint(counter, isGood)
		else:
			remainder = 0

func CleanNegativePoint(counter : PointCounter, ind : int):
	var remainder = PGR
	while remainder > 0:
		var pointChance = rng.randf_range(1, 100)
		var temp_PGR = clamp(remainder, 0, PGR_limit)
		#print(counter.name, " | random number:", pointChance, " PGR:", remainder, " clamped PGR: ", temp_PGR)
		if pointChance <= temp_PGR:
			remainder -= temp_PGR
			$Office.EnqueueClean(counter)
		else:
			remainder = 0

func ResetCounters():
	for counter in counters:
		counter.Reset()

func SetProjectProgress():
	$ProjectProgress.value = float(curDays) / float(global.curProject["TimeCost"]) * 100.0
	$ProjectProgress/ProjectProgressLabel.text = str(curDays) + "/" + global.curProject["TimeCost"]

func SetActionProgress(i):
	$ActionProgress.value = float(actionDays) / float(global.actions[i]["TimeCost"]) * 100.0
	$ActionProgress/ActionProgressLabel.text = str(actionDays) + "/" + str(global.actions[i]["TimeCost"])
	if actionDays == int(global.actions[i]["TimeCost"]):
		global.actionsActive[i] = false
		actionDays = 0
		$ActionProgress.visible = false
		$Actions_Button.visible = true

var curDays = 0
var actionDays = 0
func CheckTime():
	GenPoints()
	for i in range(3):
		if global.actionsActive[i]:
			$ActionProgress.visible = true
			$Actions_Button.visible = false
			actionDays += 1
			SetActionProgress(i)
			return
	curDays += 1
	global.game.CheckEvents(curDays)
	if curDays == int(global.curProject["TimeCost"]):
		global.game.Overtime()
	SetProjectProgress()

func _on_Team_Button_buttonPressed():
	global.game.OpenTeamScreen(true)

func _on_Actions_Button_buttonPressed():
	global.game.OpenActionScreen(true)
