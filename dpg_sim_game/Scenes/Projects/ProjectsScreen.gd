extends Control

export var numProjects = 4
onready var projectOptions = [$ProjectOption1, $ProjectOption2, $ProjectOption3, $ProjectOption4]

func Start():
	var randInds = []
	var projectInds = global.curPhase()
	for i in range(projectInds.size()):
		randInds.append(i)
	
	numProjects = min(4, projectInds.size())
	for i in range(4):
		projectOptions[i].visible = i < numProjects
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	for i in range(numProjects):
		var ind = rng.randi_range(0, randInds.size()-1)
		var project = global.projects[projectInds[randInds[ind]]]
		randInds.remove(ind)
		projectOptions[i].InitProjectButton(project)
