@tool
extends Area2D

# A 2D Array: Array[Vector2][bool]
# Vector2 contains a surfaceCenter
# bool contains whether said surfaceCenter is occupied
var centersOfSurface: Array = []
var holdablesOnSurface: Array[Area2D] = []
@export_category("Developer Tools :0")
@export_enum("Up", "Right", "Down", "Left") var direction: int = 0
@export var width: int = 1
@export var height: int = 1
@export var texture: Texture2D = null

func _ready():
	if texture: $Surface.texture = texture
	var collision: StaticBody2D = get_node("StaticBody2D")
	if collision: collision.scale = Vector2(width, height)
	$Surface.rotation_degrees = 90 * direction
	initialize_surface_points()
	initialize_holdables_on_surface()

# Initializes centersOfSurface[Vector2][bool=false]
func initialize_surface_points():
	var w_offset = (width - 1) * (Global.PIXEL_DIMENSION / 2.0)
	var h_offset = (height - 1) * (Global.PIXEL_DIMENSION / 2.0)
	for w in width:
		for h in height:
			var newX = w * Global.PIXEL_DIMENSION - w_offset
			var newY = h * Global.PIXEL_DIMENSION - h_offset
			var newPoint = Vector2(newX, newY)
			# Adjust for surface rotation
			match direction:
				0:
					newPoint.y -= Global.PIXEL_DIMENSION / 4.0
				1:
					newPoint.x += Global.PIXEL_DIMENSION / 4.0
				2:
					newPoint.y += Global.PIXEL_DIMENSION / 4.0
				3:
					newPoint.x -= Global.PIXEL_DIMENSION / 4.0
			centersOfSurface.append([newPoint, false])

# Initializes holdablesOnSurface[Area2D]
func initialize_holdables_on_surface():
	var maxHoldables: int = width * height
	for i: int in maxHoldables:
		holdablesOnSurface.append(null)
	# Set starting holdablesOnSurface[0] if needed
	var originalHoldables: Array[Node] = find_children("*", "Area2D", false)
	for i: int in originalHoldables.size():
		# If this errors, you spawned too many holdables on one surface!
		originalHoldables[i].position = centersOfSurface[i][0]
		originalHoldables[i].rotation = 0
		holdablesOnSurface[i] = originalHoldables[i]
		centersOfSurface[i][1] = true

# Given a holdable, set it on the surface
# Return true if successful and false if not successful
# This wrapper function is necessary because interactable surfaces (like Stoves) have additional functionality
func set_holdable_on_surface_wrapper(holdableInHand: Area2D):
	return set_holdable_on_surface(holdableInHand)
func set_holdable_on_surface(holdableInHand: Area2D):
	var newHoldable: Area2D = holdableInHand.duplicate()
	for i: int in centersOfSurface.size():
		if !centersOfSurface[i][1]: # If center has no holdable
			newHoldable.position = centersOfSurface[i][0]
			newHoldable.rotation = 0
			holdablesOnSurface[i] = newHoldable
			centersOfSurface[i][1] = true # Center is now occupied
			add_child(newHoldable)
			return true
	return true

# Given a holdable, remove it from the surface
func remove_holdable_from_surface(holdable: Area2D):
	for i: int in centersOfSurface.size():
		if centersOfSurface[i][0] == holdable.position:
			holdablesOnSurface[i] = null
			centersOfSurface[i][1] = false # Center is no longer occupied

func _physics_process(_delta):
	# Update sprite in the editor interface
	if Engine.is_editor_hint(): _ready()
