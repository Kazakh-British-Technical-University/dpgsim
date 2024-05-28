extends Node2D

var window = JavaScript.get_interface("window")
var externalator = JavaScript.get_interface("externalator")
var _mainConfigCallback = JavaScript.create_callback(self, "_ParseMainConfig")
var _scenarioCallback = JavaScript.create_callback(self, "_ParseScenarios")
var _trans_callback = JavaScript.create_callback(self, "_ProcessTrans")
var _projects_callback = JavaScript.create_callback(self, "_ProcessProjects")

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
		print("CSV parse error: Data/Projects.csv")


# public functions
func ConnectToWeb():
	if global.externalator_initated:
		return
	global.externalator_initated = true
	
	externalator.addGodotFunction('SendMainConfig', _mainConfigCallback)
	externalator.addGodotFunction('SendScenarios', _scenarioCallback)
	externalator.addGodotFunction('SendTrans',_trans_callback)
	externalator.addGodotFunction('SendProjects',_projects_callback)

func LoadTranslations():
	window.fetchTrans()

func LoadMainConfig():
	window.fetchMainConfig()

func LoadScenarios():
	window.getFilesInDirectory()

func LoadProjects():
	window.fetchProjects()

