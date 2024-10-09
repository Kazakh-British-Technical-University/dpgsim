extends Node2D

var window = JavaScript.get_interface("window")
var externalator = JavaScript.get_interface("externalator")
var _languages_callback = JavaScript.create_callback(self, "_ProcessLanguages")
var _mainConfigCallback = JavaScript.create_callback(self, "_ParseMainConfig")
var _scenarioCallback = JavaScript.create_callback(self, "_ParseScenarios")
var _projects_callback = JavaScript.create_callback(self, "_ProcessProjects")
var _events_callback = JavaScript.create_callback(self, "_ProcessEvents")
var _actions_callback = JavaScript.create_callback(self, "_ProcessActions")

var _systemLocalization_callback = JavaScript.create_callback(self, "_ProcessSystemLocalization")
var _projectsLocalization_callback = JavaScript.create_callback(self, "_ProcessProjectsLocalization")
var _eventsLocalization_callback = JavaScript.create_callback(self, "_ProcessEventsLocalization")
var _actionsLocalization_callback = JavaScript.create_callback(self, "_ProcessActionsLocalization")
var _teamLocalization_callback = JavaScript.create_callback(self, "_ProcessTeamLocalization")
var _creditsLocalization_callback = JavaScript.create_callback(self, "_ProcessCreditsLocalization")

# callback signals
signal language_processed
# signal mainConfig_processed
# signal scenario_processed
# signal system_processed
# signal projects_processed
# signal events_processed
# signal actions_processed
# signal team_processed
# signal credits_processed

# JS callbacks
func _ProcessLanguages(args):
	var parsed = JSON.parse(str(args[0])).result
	assert(parsed != null, "JSON parse error: Languages")
	
	for i in range(0, parsed.size()):
		global.languageIconIndexes[parsed[i]["Path"]] = parsed[i]["IconIndex"]

	global.currentLanguage = args[1]
	emit_signal("language_processed")


func _ParseMainConfig(args):
	var parsed = JSON.parse(str(args[0])).result
	assert(parsed != null, "JSON parse error: Main Config")

	global.mainConfig = parsed


func _ParseScenarios(args):
	var parsed = JSON.parse(str(args[0])).result
	assert(parsed != null, "JSON parse error: Scenario")

	global.scenarios.append(parsed)


func _ProcessProjects(args):
	var parsed = JSON.parse(str(args[0])).result
	assert(parsed != null, "CSV parse error: Projects.csv")

	var keys = parsed["Lines"][0]
	for i in range(1, parsed["Lines"].size()):
		var project : Dictionary
		for j in range(keys.size()):
			project[keys[str(j)]] = parsed["Lines"][i][str(j)]
			
		global.projects[project["ID"]] = project


func _ProcessEvnets(args):
	var parsed = JSON.parse(str(args[0])).result
	assert(parsed != null, "CSV parse error: Events.csv")

	var keys = parsed["Lines"][0]
	for i in range(1, parsed["Lines"].size()):
		var event : Dictionary
		for j in range(keys.size()):
			event[keys[str(j)]] = parsed["Lines"][i][str(j)]
		
		global.events[event["ID"]] = event


func _ProcessActions(args):
	var parsed = JSON.parse(str(args[0])).result
	assert(parsed != null, "CSV parse error: Actions.csv")

	var keys = parsed["Lines"][0]
	for i in range(1, parsed["Lines"].size()):
		var action : Dictionary
		for j in range(keys.size()):
			action[keys[str(j)]] = parsed["Lines"][i][str(j)]
		global.actions.append(action)


# JS callbacks (Localization)
func _ProcessSystemLocalization(args):
	var parsed = JSON.parse(str(args[0])).result
	assert(parsed != null, "CSV parse error: System.csv")

	for i in range(1, parsed["Lines"].size()):
		trans.dict[parsed["Lines"][i]["0"]] = parsed["Lines"][i]["1"]


func _ProcessProjectsLocalization(args):
	var parsed = JSON.parse(str(args[0])).result
	assert(parsed != null, "CSV parse error: Projects.csv")

	for i in range(1, parsed["Lines"].size()):
		var project = global.projects[parsed["Lines"][i]["0"]]
		project["Title"] = parsed["Lines"][i]["1"]
		project["Description"] = parsed["Lines"][i]["2"]
		
		global.projects[project["ID"]] = project


func _ProcessEventsLocalization(args):
	var parsed = JSON.parse(str(args[0])).result
	assert(parsed != null, "CSV parse error: Events.csv")
	
	for i in range(1, parsed["Lines"].size()):
		var event = global.events[parsed["Lines"][i]["0"]]
		event["Title"] = parsed["Lines"][i]["1"]
		event["Description"] = parsed["Lines"][i]["2"]
		event["First option"] = parsed["Lines"][i]["3"]
		event["First option tooltip"] = parsed["Lines"][i]["4"]
		event["Second option"] = parsed["Lines"][i]["5"]
		event["Second option tooltip"] = parsed["Lines"][i]["6"]
		
		global.events[event["ID"]] = event


func _ProcessActionsLocalization(args):
	var parsed = JSON.parse(str(args[0])).result
	assert(parsed != null, "CSV parse error: Actions.csv")

	for i in range(1, parsed["Lines"].size()):
		global.actions[i-1]["Title"] = parsed["Lines"][i]["1"]
		global.actions[i-1]["Description"] = parsed["Lines"][i]["2"]


func _ProcessTeamLocalization(args):
	var parsed = JSON.parse(str(args[0])).result
	assert(parsed != null, "CSV parse error: Team.csv")

	for i in range(1, parsed["Lines"].size()):
		global.teamDetails[parsed["Lines"][i]["0"]] = parsed["Lines"][i]["1"]


func _ProcessCreditsLocalizatiob(args):
	trans.dict["CREDITS_LIST"] = str(args[0])


# public functions
func ConnectToWeb():
	if global.externalator_initated:
		return
	global.externalator_initated = true
	
	externalator.addGodotFunction('SendMainConfig', _mainConfigCallback)
	externalator.addGodotFunction('SendScenario', _scenarioCallback)
	externalator.addGodotFunction('SendProjects',_projects_callback)
	externalator.addGodotFunction('SendEvents',_events_callback)
	externalator.addGodotFunction('SendActions',_actions_callback)
	externalator.addGodotFunction('SendLanguages',_languages_callback)

	externalator.addGodotFunction('SendSystemLocalization', _systemLocalization_callback)
	externalator.addGodotFunction('SendProjectsLocalization', _projectsLocalization_callback)
	externalator.addGodotFunction('SendEventsLocalization', _eventsLocalization_callback)
	externalator.addGodotFunction('SendActionsLocalization', _actionsLocalization_callback)
	externalator.addGodotFunction('SendTeamLocalization', _teamLocalization_callback)
	externalator.addGodotFunction('SendCreditsLocalization', _creditsLocalization_callback)

func LoadFiles():
	window.fetchLanguages()
	yield(self,"language_processed")

	window.fetchMainConfig()
	window.fetchScenarios()
	window.fetchProjects()
	window.fetchEvents()
	window.fetchActions()
	
	LoadLocalization()

func LoadLocalization():
	window.fetchLocalizedData("System")
	window.fetchLocalizedData("Projects")
	window.fetchLocalizedData("Events")
	window.fetchLocalizedData("Actions")
	window.fetchLocalizedData("Team")
	window.fetchCredits()

func ChangeLanguage(newLang):
	window.changeLanguage(newLang)
	global.currentLanguage = newLang;
	global.externalator_initated = false; # deinitialize to get callbacks aftrer language change
	global.ResetLocalizedFiles()
