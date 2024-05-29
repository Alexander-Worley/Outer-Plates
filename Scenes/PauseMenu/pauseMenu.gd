extends Node2D

const KEYBOARD_LAYOUTS = {
	0: preload("res://Assets/UI/InputLayouts/Keyboard/keyboard-layout.png")
}
const NS_LAYOUTS = {
	0: preload("res://Assets/UI/InputLayouts/NintendoSwitch/NS-black.png"),
	1: preload("res://Assets/UI/InputLayouts/NintendoSwitch/NS-blue.png"),
	2: preload("res://Assets/UI/InputLayouts/NintendoSwitch/NS-green.png"),
	3: preload("res://Assets/UI/InputLayouts/NintendoSwitch/NS-grey.png"),
	4: preload("res://Assets/UI/InputLayouts/NintendoSwitch/NS-purple.png"),
	5: preload("res://Assets/UI/InputLayouts/NintendoSwitch/NS-red.png"),
	6: preload("res://Assets/UI/InputLayouts/NintendoSwitch/NS-white.png"),
	7: preload("res://Assets/UI/InputLayouts/NintendoSwitch/NS-yellow.png")
}
const PS_LAYOUTS = {
	0: preload("res://Assets/UI/InputLayouts/PlayStation/PS-black.png"),
	1: preload("res://Assets/UI/InputLayouts/PlayStation/PS-blue.png"),
	2: preload("res://Assets/UI/InputLayouts/PlayStation/PS-green.png"),
	3: preload("res://Assets/UI/InputLayouts/PlayStation/PS-grey.png"),
	4: preload("res://Assets/UI/InputLayouts/PlayStation/PS-purple.png"),
	5: preload("res://Assets/UI/InputLayouts/PlayStation/PS-red.png"),
	6: preload("res://Assets/UI/InputLayouts/PlayStation/PS-white.png"),
	7: preload("res://Assets/UI/InputLayouts/PlayStation/PS-yellow.png")
}
const XB_LAYOUTS = {
	0: preload("res://Assets/UI/InputLayouts/Xbox/XB-black.png"),
	1: preload("res://Assets/UI/InputLayouts/Xbox/XB-blue.png"),
	2: preload("res://Assets/UI/InputLayouts/Xbox/XB-green.png"),
	3: preload("res://Assets/UI/InputLayouts/Xbox/XB-grey.png"),
	4: preload("res://Assets/UI/InputLayouts/Xbox/XB-purple.png"),
	5: preload("res://Assets/UI/InputLayouts/Xbox/XB-red.png"),
	6: preload("res://Assets/UI/InputLayouts/Xbox/XB-white.png"),
	7: preload("res://Assets/UI/InputLayouts/Xbox/XB-yellow.png")
}
const NUM_CONTROLLER_TYPES: int = 3
var controllerType: int = 1
# Number of colors in each layout array
@onready var NUM_COLORS: int = NS_LAYOUTS.size()
@onready var keyboard = %Keyboard
@onready var controller = %Controller
@onready var layoutChangerTimer = $LayoutChangerTimer

func _ready():
	keyboard.texture = KEYBOARD_LAYOUTS[0]
	controller.texture = NS_LAYOUTS[0]
	hide()
	layoutChangerTimer.connect("timeout", Callable(self, "_on_layoutChangerTimer_timeout"))

func _input(event):
	if event.is_action_pressed("pause"):
		visible = !visible
		get_tree().paused = !get_tree().paused
		if layoutChangerTimer.is_stopped():
			layoutChangerTimer.start()
		else: layoutChangerTimer.stop()

func _on_layoutChangerTimer_timeout():
	controllerType += 1
	if controllerType > 3: controllerType = 1
	var color: int = randi_range(0, NUM_COLORS - 1)
	match controllerType:
		1:
			controller.texture = NS_LAYOUTS[color]
		2:
			controller.texture = PS_LAYOUTS[color]
		3:
			controller.texture = XB_LAYOUTS[color]
