extends Node

var dict : Dictionary
func local(line : String):
	if (dict.has(line)):
		return dict[line]
	else:
		if len(line) > 0:
			return line
		else:
			return "Translation missing"
