extends KinematicBody2D

class_name Character


export var speed : int = 500
export var maximum_health : int = 3
export var is_enemy : bool
export var cant_shoot : bool = false

onready var can_be_hit : bool = true
onready var health : int = maximum_health
onready var offscreen : bool = false

func hit(damage : int):
	health -= damage
