extends Node

var curLang = 0
var dict : Dictionary
func local(line : String):
	if (dict.has(line)):
		if len(dict[line][curLang]) > 0:
			return dict[line][curLang]
		else:
			return dict[line][0]
	else:
		if len(line) > 0:
			return line
		else:
			return "Translation missing"
