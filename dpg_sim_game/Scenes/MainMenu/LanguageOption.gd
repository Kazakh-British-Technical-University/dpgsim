class_name LanguageOption
extends OptionButton

signal language_changed(lang)

func Start():
	add_item("en")
	add_item("ru")
	connect("item_selected", self, "_on_item_selected")
	connect("language_changed", global.game, "_on_language_changed")

func _on_item_selected(index):
	emit_signal("language_changed", get_item_text(index))