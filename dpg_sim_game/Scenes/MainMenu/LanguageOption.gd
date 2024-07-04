class_name LanguageOption
extends OptionButton

signal language_changed(lang)

func Start():
	AddAvailableLanguages()
	SetCurrentLanguage()
	connect("item_selected", self, "_on_item_selected")
	connect("language_changed", global.game, "_on_language_changed")

func AddAvailableLanguages():
	var i: int = 0
	for key in global.languages:
		add_item(global.languages[key])
		set_item_metadata(i, key)
		i += 1

func SetCurrentLanguage():
	for i in range(0, get_item_count()):
		if (get_item_metadata(i) != global.currentLanguage):
			continue
		select(i)
		return

func _on_item_selected(index):
	emit_signal("language_changed", get_item_metadata(index))