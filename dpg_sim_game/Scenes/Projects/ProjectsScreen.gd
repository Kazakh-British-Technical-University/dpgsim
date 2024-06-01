extends Node2D

export var numProjects = 4
var projectOption = preload("res://Scenes/Projects/ProjectOption.tscn")

func Start():
	for child in $Buttons.get_children():
		child.queue_free()
	
	var randInds = []
	var projectInds = global.curPhase()
	for i in range(projectInds.size()):
		randInds.append(i)
	
	numProjects = min(4, projectInds.size())
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	for i in range(numProjects):
		var ind = rng.randi_range(0, randInds.size()-1)
		var project = global.projects[projectInds[randInds[ind]]]
		randInds.remove(ind)
		
		var newProject = projectOption.instance()
		newProject.InitProjectButton(project)
		$Buttons.add_child(newProject)
