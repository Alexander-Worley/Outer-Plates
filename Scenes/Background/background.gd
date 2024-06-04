@tool
extends ParallaxBackground

const SCROLL_SPEED: int = 100
const LOGO_AMPLITUDE: float = 20.0
const LOGO_FREQUENCY: float = 2.0
const LOGO_DEFAULT_POSITION = Vector2(384, 160)
var time: float = 300
const BG_TEXTURES = {
	"Main Menu": preload("res://Assets/BGs/mainMenuBG.png"),
	"Level Select": preload("res://Assets/BGs/mainMenuBG.png"),
	"Green Planet": preload("res://Assets/BGs/greenPlanetBG.png"),
	"Blue Planet": preload("res://Assets/BGs/bluePlanetBG.png")
}
const LOGO_SPRITES = {
	"Main Menu": preload("res://Assets/UI/outer-plates-logo.png"),
	"Level Select": null,
	"Green Planet": null,
	"Blue Planet": null
}
const DINER_TEXTURES = {
	"Main Menu": null,
	"Level Select": null,
	"Green Planet": preload("res://Assets/BGs/greenPlanetDiner.png"),
	"Blue Planet": preload("res://Assets/BGs/bluePlanetDiner.png")
}
@export_category("Developer Tools :0")
@export_enum("Main Menu", "Level Select", "Green Planet", "Blue Planet") var Planet = "Main Menu"
@onready var backgroundTexture = $BG/BackgroundTexture
@onready var dinerTexture = $DinerTexture
@onready var logo = $Logo

func _ready():
	scroll_offset.x = 0
	backgroundTexture.texture = BG_TEXTURES[Planet]
	logo.texture = LOGO_SPRITES[Planet]
	dinerTexture.texture = DINER_TEXTURES[Planet]
	# If on Main Menu
	if !Engine.is_editor_hint() and Planet == "Main Menu":
		$RotateLeft.queue_free()
		$FlyLeft.queue_free()
		$FlyRight.queue_free()
	if !Engine.is_editor_hint() and Planet == "Level Select":
		$RotateLeft.queue_free()
		$FlyLeft.queue_free()
		$FlyRight.queue_free()

func _process(delta):
	scroll_offset.x -= SCROLL_SPEED * delta
	time += delta * LOGO_FREQUENCY
	if logo.texture:
		logo.position = LOGO_DEFAULT_POSITION + Vector2(0, sin(time) * LOGO_AMPLITUDE)
	if Planet != "Main Menu" and Planet != "Level Select":
		var sprites = $RotateLeft.get_children()
		for sprite in sprites:
			sprite.rotation = -time

func _physics_process(_delta):
	# Update textures in the editor interface
	if Engine.is_editor_hint(): _ready()
