extends Node

export var buttonScene: PackedScene
export var group: ButtonGroup
export var flagsAtlas: Texture
export var atlasRowLength: int
export var flagSize: Vector2
export var atlasPadding: int

signal language_changed

func Start():
	AddAvailableLanguages()
	SetCurrentLanguage()

	for button in group.get_buttons():
		button.connect("pressed", self, "_on_item_selected")

	connect("language_changed", global.game, "_on_language_changed")

func AddAvailableLanguages():
	for key in global.languageIconIndexes:
		AddItem(key, global.languageIconIndexes[key])

func AddItem(language, flagAtlasIndex):
	var button = buttonScene.instance()
	var texture = AtlasTexture.new()
	texture.atlas = flagsAtlas;
	texture.region = IndexToRegion(flagAtlasIndex)

	button.texture_normal = texture
	button.group = group
	button.toggle_mode = true
	button.set_meta("Language", language)
	add_child(button)

func IndexToRegion(index: int):
	var row = index / atlasRowLength
	var column = index % atlasRowLength

	var posX = column * flagSize.x + (column + 1) * atlasPadding
	var posY = row * flagSize.y + (row + 1) * atlasPadding
	return Rect2(Vector2(posX, posY), flagSize)


func SetCurrentLanguage():
	for button in group.get_buttons():
		if (button.get_meta("Language") != global.currentLanguage):
			continue
		button.pressed = true
		break

func _on_item_selected():
	emit_signal("language_changed", group.get_pressed_button().get_meta("Language"))


func _on_LanguageRadio_toggled(button_pressed:bool):
	pass # Replace with function body.
