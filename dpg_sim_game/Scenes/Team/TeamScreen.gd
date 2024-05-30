extends Node2D

onready var allTeams = [$Management,$Development,$Design,$Product,$Marketing,$QA,$Support]
var teamLimit = 5
var teamSize = 1
var team : Dictionary = {
	"Management": 1,
	"Development": 0,
	"Design": 0,
	"Product": 0,
	"Marketing": 0,
	"QA": 0,
	"Support": 0,
}


func Start():
	teamSize = 1
	teamLimit = 5
	for key in team:
		team[key] = 0
	team["Management"] = 1
	
	$Back_Button.Start()
	UpdateTeamSizeLabel()
	for worker in allTeams:
		worker.Start()

func UpdateAvailableWorkers():
	var ind = 0
	match global.curPhaseIndex:
		2:
			ind = 3
		3:
			ind = 4
		4:
			ind = 5
		5:
			ind = 6
		6:
			ind = 6
		7:
			ind = 7
		8:
			ind = 7
	
	for i in range(7):
		allTeams[i].visible = i < ind

func HireWorker(type):
	if teamSize < teamLimit:
		teamSize += 1
		team[type] += 1
		global.game.HireWorker(1)
		
		if type == "Management":
			teamLimit += 5
		
		UpdateTeamSizeLabel()

func FireWorker(type):
	if type != "Management":
		if team[type] > 0:
			teamSize -= 1
			team[type] -= 1
			global.game.HireWorker(-1)
			UpdateTeamSizeLabel()
		return
	else:
		if team[type] > 1 and teamSize <= teamLimit - 5:
			teamSize -= 1
			team[type] -= 1
			global.game.HireWorker(-1)
			teamLimit -= 5
			UpdateTeamSizeLabel()

func GetInsight(index, good):
	var value = 0
	match index:
		0:
			if good:
				value = team["Product"]
			else:
				value = - (team["Design"] + team["Support"])
		1:
			if good:
				value = team["Development"]
			else:
				value = -(team["Design"] + team["QA"])
		2:
			if good:
				value = team["Marketing"]
			else:
				value = -team["Support"]
	
	return value * int(global.mainConfig["TeamBonus"])

func _on_Back_Button_buttonPressed():
	global.game.CloseTeamScreen()

func UpdateTeamSizeLabel():
	$TeamSize.text = trans.local("TEAM_SIZE") + ": " + str(teamSize) + "/" + str(teamLimit)
