extends Node

var externalator_initated = false
var game : MainGame

var mainConfig : Dictionary
var scenarios = []
var projects = []

var activeScenarioIndex = -1
var curPhaseIndex = -1
var curProject 

var productP = 0
var productN = 0
var techP = 0
var techN = 0
var marketP = 0
var marketN = 0

func ApplyInsights():
	var temp = int(global.curProject["ProductInsights"])
	if temp > 0:
		productP += temp
	else:
		productN -= temp
	temp = int(global.curProject["TechInsights"])
	if temp > 0:
		techP += temp
	else:
		techN -= temp
	temp = int(global.curProject["MarketInsights"])
	if temp > 0:
		marketP += temp
	else:
		marketN -= temp

func GetInsight(index, good):
	var value = 0
	match index:
		0:
			if good:
				value = productP + game.teamScreen.GetInsight(index, good)
			else:
				value = productN + game.teamScreen.GetInsight(index, good)
		1:
			if good:
				value = techP + game.teamScreen.GetInsight(index, good)
			else:
				value = techN + game.teamScreen.GetInsight(index, good)
		2:
			if good:
				value = marketP + game.teamScreen.GetInsight(index, good)
			else:
				value = marketN + game.teamScreen.GetInsight(index, good)
	return value * int(mainConfig["InsightMultiplier"])

func ResetGame():
	activeScenarioIndex = -1
	curPhaseIndex = -1

func curPhase():
	return scenarios[activeScenarioIndex]["PhaseProjects"][curPhaseIndex]

func curScenario():
	return scenarios[activeScenarioIndex]
