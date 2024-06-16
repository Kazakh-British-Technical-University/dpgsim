extends Node2D

var window = JavaScript.get_interface("window")
var externalator = JavaScript.get_interface("externalator")
var _mainConfigCallback = JavaScript.create_callback(self, "_ParseMainConfig")
var _scenarioCallback = JavaScript.create_callback(self, "_ParseScenarios")
var _trans_callback = JavaScript.create_callback(self, "_ProcessTrans")
var _projects_callback = JavaScript.create_callback(self, "_ProcessProjects")
var _events_callback = JavaScript.create_callback(self, "_ProcessEvents")
var _actions_callback = JavaScript.create_callback(self, "_ProcessActions")

# JS callbacks
func _ParseMainConfig(args):
	var parsed = JSON.parse(str(args[0])).result
	if (parsed != null):
		global.mainConfig = parsed
	else:
		print("JSON parse error")

func _ParseScenarios(args):
	var parsed = JSON.parse(str(args[0])).result
	if (parsed != null):
		global.scenarios.append(parsed)
	else:
		print("JSON parse error")

func _ProcessTrans(args):
	var parsed = JSON.parse(str(args[0])).result
	if (parsed != null):
		for i in range(1, parsed["Lines"].size()):
			trans.dict[parsed["Lines"][i]["0"]] = [parsed["Lines"][i]["1"],parsed["Lines"][i]["2"],parsed["Lines"][i]["3"]]
	else:
		print("CSV parse error: Data/Translations.csv")

func _ProcessProjects(args):
	var parsed = JSON.parse(str(args[0])).result
	if (parsed != null):
		var keys = parsed["Lines"][0]
		for i in range(1, parsed["Lines"].size()):
			var project : Dictionary
			for j in range(keys.size()):
				project[keys[str(j)]] = parsed["Lines"][i][str(j)]
			global.projects.append(project)
	else:
		print("CSV parse error: Projects.csv")

func _ProcessEvents(args):
	var parsed = JSON.parse(str(args[0])).result
	if (parsed != null):
		var keys = parsed["Lines"][0]
		for i in range(1, parsed["Lines"].size()):
			var event : Dictionary
			for j in range(keys.size()):
				event[keys[str(j)]] = parsed["Lines"][i][str(j)]
			global.events.append(event)
	else:
		print("CSV parse error: Events.csv")

func _ProcessActions(args):
	var parsed = JSON.parse(str(args[0])).result
	if (parsed != null):
		var keys = parsed["Lines"][0]
		for i in range(1, parsed["Lines"].size()):
			var action : Dictionary
			for j in range(keys.size()):
				action[keys[str(j)]] = parsed["Lines"][i][str(j)]
			global.actions.append(action)
	else:
		print("CSV parse error: Actions.csv")


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

func LoadTranslations():
	window.fetchTrans()

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

