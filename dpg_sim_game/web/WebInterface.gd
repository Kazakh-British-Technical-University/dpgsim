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
var _credits_callback = JavaScript.create_callback(self, "_ProcessCredits")
var _languages_callback = JavaScript.create_callback(self, "_ProcessLanguages")

# callback signals
signal language_processed

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
					
				global.projects[project["ID"]] = project
			else:
				var project = global.projects[parsed["Lines"][i]["0"]]
				project["Title"] = parsed["Lines"][i]["1"]
				project["Description"] = parsed["Lines"][i]["2"]
				
				global.projects[project["ID"]] = project
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
				
				global.events[event["ID"]] = event
			else:
				var event = global.events[parsed["Lines"][i]["0"]]
				event["Title"] = parsed["Lines"][i]["1"]
				event["Description"] = parsed["Lines"][i]["2"]
				event["First option"] = parsed["Lines"][i]["3"]
				event["First option tooltip"] = parsed["Lines"][i]["4"]
				event["Second option"] = parsed["Lines"][i]["5"]
				event["Second option tooltip"] = parsed["Lines"][i]["6"]
				
				global.events[event["ID"]] = event
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

func _ProcessCredits(args):
	trans.dict["CREDITS_LIST"] = str(args[0])

func _ProcessLanguages(args):
	var parsed = JSON.parse(str(args[0])).result
	if (parsed == null):
		print("JSON parse error: Languages")
		return
	for i in range(0, parsed.size()):
		global.languageIconIndexes[parsed[i]["Path"]] = parsed[i]["IconIndex"]

	global.currentLanguage = args[1]

	emit_signal("language_processed")


# public functions
func ConnectToWeb():
	if global.externalator_initated:
		return
	global.externalator_initated = true
	
	externalator.addGodotFunction('SendMainConfig', _mainConfigCallback)
	externalator.addGodotFunction('SendScenario', _scenarioCallback)
	externalator.addGodotFunction('SendTrans',_trans_callback)
	externalator.addGodotFunction('SendProjects',_projects_callback)
	externalator.addGodotFunction('SendEvents',_events_callback)
	externalator.addGodotFunction('SendActions',_actions_callback)
	externalator.addGodotFunction('SendTeam',_team_callback)
	externalator.addGodotFunction('SendCredits',_credits_callback)
	externalator.addGodotFunction('SendLanguages',_languages_callback)

func LoadFiles():
	window.fetchLanguages()
	yield(self,"language_processed")

	window.fetchMainConfig()
	window.fetchScenarios()
	window.fetchProjects()
	window.fetchEvents()
	window.fetchActions()
	window.fetchCredits()
	LoadLocalizedFiles()

func LoadLocalizedFiles():
	window.fetchLocalizedData("System")
	window.fetchLocalizedData("Projects")
	window.fetchLocalizedData("Events")
	window.fetchLocalizedData("Actions")
	window.fetchLocalizedData("Team")

func ChangeLanguage(newLang):
	window.changeLanguage(newLang)
	global.currentLanguage = newLang;
	global.externalator_initated = false; # deinitialize to get callbacks aftrer language change
	global.ResetLocalizedFiles()
