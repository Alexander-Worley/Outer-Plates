extends Area2D

const MAX_COOKING_LEVEL: int = 4
# 0: Raw, 1: Rare, 2: Medium, 3: Well-Done, 4: Burnt
var doneness: int = 0
""" # TODO: Uncomment this when sprites are added
var sprites = {
	0: preload("res://???.png"),
	1: preload("res://???.png"),
	2: preload("res://???.png"),
	3: preload("res://???.png"),
	4: preload("res://???.png")
}
@onready var sprite = $Sprite
"""

# Returns whether the food is burnt or not
func isBurnt():
	return doneness >= MAX_COOKING_LEVEL

# Increases doneness by 1
func increase_doneness():
	if isBurnt(): return
	doneness += 1
	update_sprite()
	
func get_doneness():
	return doneness

# Change sprite
func update_sprite():
	# TODO: Remove the TEMP function call below when sprites are added
	$devSprite.TEMP_dev_sprite_update(doneness)
	""" # TODO: Uncomment this when sprites are added
	if doneness in sprites:
		sprite.texture = sprites[doneness]
	"""
