extends Node

# GLOBAL FUNCTIONS
# This file contains this project's global functions
# To access global function "x", call "Utils.x" anywhere.
	# "Utils.x" is case-specific
# example: func saveGame(): ...
# example: func loadGame(): ...

func setScene(newScene: PackedScene, hasPlayers: bool = true):
	Global.currentScene = newScene.instantiate()
	Global.isPlayersInScene = hasPlayers
	get_tree().change_scene_to_file("res://Scenes/SceneManager/sceneManager.tscn")
