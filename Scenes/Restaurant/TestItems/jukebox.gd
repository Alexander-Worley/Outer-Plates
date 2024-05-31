extends Area2D

var playing = false

var songArr = ["res://Assets/Music/space flute.mp3", "res://Assets/Music/messages from the stars.mp3", "res://Assets/Music/rhinestone eyes.mp3", "res://Assets/Music/symphony of a forgotten sprite.mp3"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func playMusic():
	if not playing:
		$AnimatedSprite2D.play("default")
		$AudioStreamPlayer2D.stream = load(getRandomSong())
		$AudioStreamPlayer2D.play()
		playing = true
	else:
		$AnimatedSprite2D.stop()
		$AudioStreamPlayer2D.stop()
		playing = false

func getRandomSong():
	return songArr.pick_random()