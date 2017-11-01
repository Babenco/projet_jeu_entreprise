extends Label

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_LabelFinTour_input_event( ev ):
	print("input event!")
	if (ev.type == InputEvent.MOUSE_BUTTON) && (ev.button_index == BUTTON_LEFT):
		emit_signal("button_click")
