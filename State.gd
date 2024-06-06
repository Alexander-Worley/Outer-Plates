extends Node
class_name State

signal Transitioned

#this block only works because customer is always initially a child of teleporter
@onready var teleporter = get_node("../../../")
@onready var TeleportSpot = teleporter.find_child("TeleportSpot")
@onready var BottomOfStairs = teleporter.find_child("BottomOfStairs")
@onready var WaitSpot = get_node("../../../../HostingStand/WaitSpot")
@onready var TableManager = get_node("../../../../TableManager")
@onready var MoneyLabel = get_node("../../../../../MoneyLabel")

#establish customer vars
@onready var customer = get_node("../../")
@onready var sprite = customer.find_child("AnimatedSprite2D")
@onready var collisionShape = customer.find_child("CollisionShape2D")

#establish state machine timer vars
@onready var TeleportTimer = get_node("../TeleportTimer")
@onready var WaitForTableTimer = get_node("../WaitForTableTimer")
@onready var TweakOutTimer = get_node("../TweakOutTimer")
@onready var EatingTimer = get_node("../EatingTimer")



func Enter():
	pass

func Exit():
	pass
	
func Update(_delta: float):
	pass
	
func Physics_Update(_delta: float):
	pass
	
