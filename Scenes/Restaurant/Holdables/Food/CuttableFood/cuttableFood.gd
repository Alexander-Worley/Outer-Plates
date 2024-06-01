extends Area2D

# True after being cut at a cuttingBoard
var isCut: bool = false
@onready var sprite = $AnimatedSprite2D

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
