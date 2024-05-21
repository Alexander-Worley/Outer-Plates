@tool
extends Area2D

var centerOfSurface = Vector2.ZERO
var isHolding: bool = false
var holdableOnSurface: Area2D = null
@export_enum("Up", "Right", "Down", "Left") var direction: int = 0
@export var texture: Texture2D = null

func _ready():
	if texture: $Surface.texture = texture
	$Surface.rotation_degrees = 90 * direction
	match direction:
		0:
			centerOfSurface = Vector2(0,-8)
		1:
			centerOfSurface = Vector2(8,0)
		2:
			centerOfSurface = Vector2(0,8)
		3:
			centerOfSurface = Vector2(-8,0)
	var originalHoldable: Array[Node] = find_children("*", "Area2D", false)
	if originalHoldable:
		holdableOnSurface = originalHoldable[0]
		holdableOnSurface.position = centerOfSurface
		isHolding = true

# Given a holdable, set it on the surface
func set_holdable_on_surface(holdableInHand: Area2D):
	if isHolding: return false
	holdableOnSurface = holdableInHand.duplicate()
	add_child(holdableOnSurface)
	holdableOnSurface.position = centerOfSurface
	holdableOnSurface.rotation = 0
	isHolding = true
	return true

func _physics_process(_delta):
	# Update sprite in the editor interface
	if Engine.is_editor_hint(): _ready()
