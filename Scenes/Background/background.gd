extends ParallaxBackground

const SCROLL_SPEED: int = 100
const LOGO_AMPLITUDE: float = 1.0
const LOGO_FREQUENCY: float = 1.0
const BG_TEXTURES = {
	"Main Menu": preload("res://Assets/BGs/mainMenuBG.png"),
	"Green Planet": preload("res://Assets/BGs/greenPlanetBG.png"),
	"Blue Planet": preload("res://Assets/BGs/bluePlanetBG.png")
}
const DINER_TEXTURES = {
	"Main Menu": null,
	"Green Planet": preload("res://Assets/BGs/greenPlanetDiner.png"),
	"Blue Planet": preload("res://Assets/BGs/bluePlanetDiner.png")
}
@export_category("Developer Tools :0")
@export_enum("Main Menu", "Green Planet", "Blue Planet") var Planet = "Main Menu"
@onready var backgroundTexture = $BG/BackgroundTexture.texture
@onready var dinerTexture = $DinerTexture.texture

func _ready():
	backgroundTexture = BG_TEXTURES[Planet]
	dinerTexture = DINER_TEXTURES[Planet]

func _process(delta):
	scroll_offset.x -= SCROLL_SPEED * delta
