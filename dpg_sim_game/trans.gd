extends Node

var dict : Dictionary
func local(line : String):
	if dict.has(line) and len(dict[line]) > 0:
		return dict[line]
	else:
		if len(line) > 0:
			return line
		else:
			return "Translation missing"
