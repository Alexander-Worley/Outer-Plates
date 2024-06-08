extends Area2D


var isFull: bool = false
var isGreen: bool = false
var type = 'red'
var isEaten: bool = false

func set_isFull(newFull: bool, newGreen: bool):
	isFull = newFull
	isGreen = newGreen
	type = 'green' if isGreen else 'red'
	if (isFull): print("we're full fuckers")
	update_sprite()

func update_sprite():
	var sprite = get_node("AnimatedSprite2D")
	if !isFull: sprite.set_frame(0)
	elif isGreen:
		sprite.set_frame(1)
	else: 
		sprite.set_frame(2)

func get_isFull():
	return isFull

func set_isEaten(newEaten: bool):
	isEaten = newEaten
	isFull = false
	update_sprite()

func isReady():
	if isFull:
		return true
	return false
