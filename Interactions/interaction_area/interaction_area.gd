extends Area2D
class_name InteractionArea

var interact: Callable = func():
	# This has default functionality since this function should always be overridden
	# by whatever is imbued with InteractionArea. If this is showing up in the console,
	# it indicates that the interaction function isn't being set correctly. 
	print("An error has occurred.")

func is_interaction_area():
	pass

func _on_body_entered(body):
	if body.is_in_group("player"):
		InteractionManager.register_area(self)

func _on_body_exited(body):
	if body.is_in_group("player"):
		InteractionManager.unregister_area(self)
