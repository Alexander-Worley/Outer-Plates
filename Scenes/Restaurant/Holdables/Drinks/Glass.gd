extends Area2D


var isFull: bool = false
var isGreen: bool = false

func set_isFull(newFull: bool, newGreen: bool):
	isFull = newFull
	isGreen = newGreen
	update_sprite()

func update_sprite():
	var sprite = get_node("AnimatedSprite2D")
	if !isFull: sprite.set_frame(0)
	elif isGreen: sprite.set_frame(1)
	else: sprite.set_frame(2)

func get_isFull():
	return isFull

func isReady():
	if isFull:
		return true
	return false
