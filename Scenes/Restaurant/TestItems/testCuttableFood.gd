extends Area2D

# True after being cut at a cuttingBoard
var isCut: bool = false
""" # TODO: Uncomment this when sprites are added
var sprites = {
	"false": preload("res://???.png"),
	"true": preload("res://???.png"),
	2: preload("res://???.png"),
	3: preload("res://???.png"),
	4: preload("res://???.png")
}
@onready var sprite = $Sprite
"""

# Set the isCut bool of this holdable
func set_isCut(newCut: bool):
	isCut = newCut
	update_sprite()

# Change sprite
func update_sprite():
	$devSprite/devLabel.text = "DONE"
	# TODO: Remove the TEMP function call below when sprites are added
	#$devSprite.TEMP_dev_sprite_update(doneness)
	""" # TODO: Uncomment this when sprites are added
	if doneness in sprites:
		sprite.texture = sprites[doneness]
	"""
