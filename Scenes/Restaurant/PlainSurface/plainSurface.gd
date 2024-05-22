@tool
extends Area2D

# A 2D Array: [Vector2][bool]
# Vector2 contains a surfaceCenter
# bool contains whether said surfaceCenter is occupied
var centersOfSurface: Array[Vector2]= []
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
	# Set centersOfSurface
	set_surface_points()
	# Set starting holdablesOnSurface[0] if needed
	var originalHoldables: Array[Node] = find_children("*", "Area2D", false)
	for i: int in originalHoldables.size():
		# If this errors, you have too many holdables on one surface!
		originalHoldables[i].position = centersOfSurface[i]
		holdablesOnSurface.append(originalHoldables[i])

func set_surface_points():
	var w_offset = (width - 1) * 16
	var h_offset = (height - 1) * 16
	for w in width:
		for h in height:
			var newPoint = Vector2(w * 32 - w_offset, h * 32 - h_offset)
			# Adjust for surface rotation
			match direction:
				0:
					newPoint.y -= 8
				1:
					newPoint.x += 8
				2:
					newPoint.y += 8
				3:
					newPoint.x -= 8
			centersOfSurface.append(newPoint)

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
	newHoldable.position = centersOfSurface[holdablesOnSurface.size() - 1]
	newHoldable.rotation = 0
	return true

# Given a holdable, remove it from the surface
func remove_holdable_from_surface(holdable):
	holdablesOnSurface.erase(holdable)

func _physics_process(_delta):
	# Update sprite in the editor interface
	if Engine.is_editor_hint(): _ready()
