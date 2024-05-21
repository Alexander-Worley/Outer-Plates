@tool
extends Area2D

var centerOfSurface = Vector2.ZERO
var holdablesOnSurface: Array[Area2D] = []
var maxHoldables: int = 1
@export_category("Developer Tools :0")
@export_enum("Up", "Right", "Down", "Left") var direction: int = 0
@export var width: int = 1
@export var height: int = 1
@export var texture: Texture2D = null

func _ready():
	# Set maxHoldables
	maxHoldables = width * height
	# Set Texture
	if texture: $Surface.texture = texture
	# Set Collision
	var collision: CollisionShape2D = get_node("CollisionShape2D")
	if collision: collision.scale = Vector2(width, height)
	# Set Rotation
	$Surface.rotation_degrees = 90 * direction
	# Set centerOfSurface based on Rotation
	match direction:
		0:
			centerOfSurface = Vector2(0,-8)
		1:
			centerOfSurface = Vector2(8,0)
		2:
			centerOfSurface = Vector2(0,8)
		3:
			centerOfSurface = Vector2(-8,0)
	# Set starting holdablesOnSurface[0] if needed
	var originalHoldable: Array[Node] = find_children("*", "Area2D", false)
	if originalHoldable:
		holdablesOnSurface.append(originalHoldable[0])
		holdablesOnSurface[0].position = centerOfSurface

# Given a holdable, set it on the surface
# Return true if successful and false if not successful
# This wrapper function is necessary because interactable surfaces (like Stoves) have additional functions
func set_holdable_on_surface_wrapper(holdableInHand: Area2D):
	return set_holdable_on_surface(holdableInHand)
func set_holdable_on_surface(holdableInHand: Area2D):
	if holdablesOnSurface.size() >= maxHoldables: return false
	var newHoldable: Area2D = holdableInHand.duplicate()
	holdablesOnSurface.append(newHoldable)
	add_child(newHoldable)
	newHoldable.position = centerOfSurface
	newHoldable.rotation = 0
	return true

# Given a holdable, remove it from the surface
func remove_holdable_from_surface(holdable):
	holdablesOnSurface.erase(holdable)

func _physics_process(_delta):
	# Update sprite in the editor interface
	if Engine.is_editor_hint(): _ready()
