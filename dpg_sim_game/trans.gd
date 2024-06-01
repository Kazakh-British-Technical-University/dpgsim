extends Node

var curLang = 0
var dict : Dictionary
func local(line : String):
	if (dict.has(line)):
		return dict[line][curLang]
	else:
		if len(line) > 0:
			return line
		else:
			return "Translation missing"
