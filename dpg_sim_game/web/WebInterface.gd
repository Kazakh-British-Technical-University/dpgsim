extends Node2D

var window = JavaScript.get_interface("window")
var externalator = JavaScript.get_interface("externalator")
var _mainConfigCallback = JavaScript.create_callback(self, "_ParseMainConfig")
var _scenarioCallback = JavaScript.create_callback(self, "_ParseScenarios")
var _trans_callback = JavaScript.create_callback(self, "_ProcessTrans")
var _projects_callback = JavaScript.create_callback(self, "_ProcessProjects")
var _events_callback = JavaScript.create_callback(self, "_ProcessEvents")
var _actions_callback = JavaScript.create_callback(self, "_ProcessActions")
var _team_callback = JavaScript.create_callback(self, "_ProcessTeam")

# JS callbacks
func _ParseMainConfig(args):
	var parsed = JSON.parse(str(args[0])).result
	if (parsed != null):
		global.mainConfig = parsed
	else:
		print("JSON parse error: Main Config")

func _ParseScenarios(args):
	var parsed = JSON.parse(str(args[0])).result
	if (parsed != null):
		global.scenarios.append(parsed)
	else:
		print("JSON parse error: Scenario")

func _ProcessTrans(args):
	var parsed = JSON.parse(str(args[0])).result
	if (parsed != null):
		for i in range(1, parsed["Lines"].size()):
			trans.dict[parsed["Lines"][i]["0"]] = parsed["Lines"][i]["1"]
	else:
		print("CSV parse error: System.csv")

func _ProcessProjects(args):
	var parsed = JSON.parse(str(args[0])).result
	if (parsed != null):
		var keys = parsed["Lines"][0]
		for i in range(1, parsed["Lines"].size()):
			if not bool(args[1]):
				var project : Dictionary
				for j in range(keys.size()):
					project[keys[str(j)]] = parsed["Lines"][i][str(j)]
				global.projects.append(project)
			else:
				global.projects[i-1]["Title"] = parsed["Lines"][i]["1"]
				global.projects[i-1]["Description"] = parsed["Lines"][i]["2"]
	else:
		print("CSV parse error: Projects.csv")

func _ProcessEvents(args):
	var parsed = JSON.parse(str(args[0])).result
	if (parsed != null):
		var keys = parsed["Lines"][0]
		for i in range(1, parsed["Lines"].size()):
			if not bool(args[1]):
				var event : Dictionary
				for j in range(keys.size()):
					event[keys[str(j)]] = parsed["Lines"][i][str(j)]
				global.events.append(event)
			else:
				global.events[i-1]["Title"] = parsed["Lines"][i]["1"]
				global.events[i-1]["Description"] = parsed["Lines"][i]["2"]
				global.events[i-1]["First option"] = parsed["Lines"][i]["3"]
				global.events[i-1]["First option tooltip"] = parsed["Lines"][i]["4"]
				global.events[i-1]["Second option"] = parsed["Lines"][i]["5"]
				global.events[i-1]["Second option tooltip"] = parsed["Lines"][i]["6"]
	else:
		print("CSV parse error: Events.csv")

func _ProcessActions(args):
	var parsed = JSON.parse(str(args[0])).result
	if (parsed != null):
		var keys = parsed["Lines"][0]
		for i in range(1, parsed["Lines"].size()):
			if not bool(args[1]):
				var action : Dictionary
				for j in range(keys.size()):
					action[keys[str(j)]] = parsed["Lines"][i][str(j)]
				global.actions.append(action)
			else:
				global.actions[i-1]["Title"] = parsed["Lines"][i]["1"]
				global.actions[i-1]["Description"] = parsed["Lines"][i]["2"]
	else:
		print("CSV parse error: Actions.csv")

func _ProcessTeam(args):
	var parsed = JSON.parse(str(args[0])).result
	if (parsed != null):
		for i in range(1, parsed["Lines"].size()):
			global.teamDetails[parsed["Lines"][i]["0"]] = parsed["Lines"][i]["1"]
	else:
		print("CSV parse error: Team.csv")


# public functions
func ConnectToWeb():
	if global.externalator_initated:
		return
	global.externalator_initated = true
	
	externalator.addGodotFunction('SendMainConfig', _mainConfigCallback)
	externalator.addGodotFunction('SendScenarios', _scenarioCallback)
	externalator.addGodotFunction('SendTrans',_trans_callback)
	externalator.addGodotFunction('SendProjects',_projects_callback)
	externalator.addGodotFunction('SendEvents',_events_callback)
	externalator.addGodotFunction('SendActions',_actions_callback)
	externalator.addGodotFunction('SendTeam',_team_callback)

func LoadFiles():
	LoadMainConfig()
	LoadScenarios()
	LoadProjects()
	LoadEvents()
	LoadActions()
	LoadLocalizedFiles()

func LoadMainConfig():
	window.fetchMainConfig()

func LoadScenarios():
	window.getScenarios()

func LoadProjects():
	window.fetchProjects()

func LoadEvents():
	window.fetchEvents()

func LoadActions():
	window.fetchActions()

func LoadLocalizedFiles():
	window.fetchLocalizedData("System")
	window.fetchLocalizedData("Projects")
	window.fetchLocalizedData("Events")
	window.fetchLocalizedData("Actions")
	window.fetchLocalizedData("Team")
