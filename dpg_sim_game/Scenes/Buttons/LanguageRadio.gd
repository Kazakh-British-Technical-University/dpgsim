extends TextureButton

onready var outline: CanvasItem = $Outline

func _on_LanguageRadio_toggled(button_pressed:bool):
	outline.visible = button_pressed
