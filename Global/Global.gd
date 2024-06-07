extends Node

# GLOBAL VARIABLES
# This file contains this project's global variables (and global constants)
# To access global variable "x", call "Global.x" anywhere.
	# "Global.x" is case-specific
# example: const TIME_LIMIT = 300
# example: var health = 10

const PIXEL_DIMENSION: int = 32 # Deimension of pixel art assets
var currentScene: Node2D = preload("res://Scenes/MainMenu/mainMenu.tscn").instantiate()
var isPlayersInScene: bool = false # Does currentScene spawn players?
var isP1UsingKeyboard: bool = true # Is P1 using a keyboard?
var isAcceptAllInput: bool = true # Accept all input sources?
