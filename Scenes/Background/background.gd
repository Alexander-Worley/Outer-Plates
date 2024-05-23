@tool
extends ParallaxBackground

const SCROLL_SPEED: int = 100
const LOGO_AMPLITUDE: float = 20.0
const LOGO_FREQUENCY: float = 2.0
const LOGO_DEFAULT_POSITION = Vector2(384, 160)
var time: float = 0
const BG_TEXTURES = {
	"Main Menu": preload("res://Assets/BGs/mainMenuBG.png"),
	"Green Planet": preload("res://Assets/BGs/greenPlanetBG.png"),
	"Blue Planet": preload("res://Assets/BGs/bluePlanetBG.png")
}
const LOGO_SPRITES = {
	"Main Menu": preload("res://Assets/UI/outer-plates-logo.png"),
	"Green Planet": null,
	"Blue Planet": null
}
const DINER_TEXTURES = {
	"Main Menu": null,
	"Green Planet": preload("res://Assets/BGs/greenPlanetDiner.png"),
	"Blue Planet": preload("res://Assets/BGs/bluePlanetDiner.png")
}
@export_category("Developer Tools :0")
@export_enum("Main Menu", "Green Planet", "Blue Planet") var Planet = "Main Menu"
@onready var backgroundTexture = $BG/BackgroundTexture
@onready var dinerTexture = $DinerTexture
@onready var logo = $Logo

func _ready():
	backgroundTexture.texture = BG_TEXTURES[Planet]
	logo.texture = LOGO_SPRITES[Planet]
	dinerTexture.texture = DINER_TEXTURES[Planet]

func _process(delta):
	scroll_offset.x -= SCROLL_SPEED * delta
	if logo.texture:
		time += delta * LOGO_FREQUENCY
		logo.position = LOGO_DEFAULT_POSITION + Vector2(0, sin(time) * LOGO_AMPLITUDE)

func _physics_process(_delta):
	# Update textures in the editor interface
	if Engine.is_editor_hint(): _ready()
