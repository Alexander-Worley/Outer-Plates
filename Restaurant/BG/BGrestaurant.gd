extends ParallaxBackground

const SCROLL_SPEED: int = 100

func _process(delta):
	scroll_offset.x -= SCROLL_SPEED * delta
