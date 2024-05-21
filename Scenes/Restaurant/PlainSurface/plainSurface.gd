extends Area2D

const CENTER_OF_SURFACE = Vector2(0,-8)
var isHolding: bool = false
var holdableOnSurface: Area2D = null
@export var texture: Texture2D = null

func _ready():
	if texture: $Sprite2D.texture = texture

# Given a holdable, set it on the surface
func set_holdable_on_surface(holdableInHand: Area2D):
	if isHolding: return false
	holdableOnSurface = holdableInHand.duplicate()
	add_child(holdableOnSurface)
	holdableOnSurface.position = CENTER_OF_SURFACE
	holdableOnSurface.rotation = 0
	isHolding = true
	return true
