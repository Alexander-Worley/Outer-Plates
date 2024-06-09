extends Label

@onready var line = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_pressed():
	line += 1
	if line == 0:
		text = "You and your Earthling friends have always been the adventurous bunch, roaming all that space has to offer. Upon traveling to the Outer Plates galaxy, you are lured in by the vibrant, oceanic planet of Azurea…."
	elif line == 1:
		text = "But…. the alien residents of the Outer Planets are no friends to humans. Lucky for you, killing is not in their nature, but getting away won’t be easy…. Luckily, word has gotten around the galaxy of the culinary talents of humans…"
	elif line == 2:
		text = "Offering to open a diner to eventually buy your freedom, you and your friend must work together to cook for the local aliens, fending off outside invaders who wish to sabotage your mission"
	elif line == 3:
		text = "Adventure awaits you in the Outer Plates….\nGood luck humans."
	else:
		#move to Day1T
		const nextScene = preload("res://Scenes/InputSelection/p1InputSelection.tscn")
		Utils.setScene(nextScene, false)

