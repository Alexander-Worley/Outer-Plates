@tool
extends Area2D

var centerOfSurface = Vector2.ZERO
var isHolding: bool = false
var holdableOnSurface: Area2D = null
@export_category("Developer Tools :0")
@export_enum("Up", "Right", "Down", "Left") var direction: int = 0
@export var width: int = 1
@export var height: int = 1
@export var texture: Texture2D = null

func _ready():
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
	# Set starting holdableOnSurface if needed
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
	
	#copy ammo count
	if holdableOnSurface.is_in_group("Weapons"):
		holdableOnSurface.ammo = holdableInHand.ammo
	
	holdableOnSurface.position = centerOfSurface
	holdableOnSurface.rotation = 0
	isHolding = true
	return true

func _physics_process(_delta):
	# Update sprite in the editor interface
	if Engine.is_editor_hint(): _ready()
