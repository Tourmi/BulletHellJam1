extends KinematicBody2D

class_name Character


export var speed : int = 500
export var shooting_cooldown: float = 0.5
export var maximum_health : int = 3
export var is_enemy : bool
export var cant_shoot : bool = false

onready var can_be_hit : bool = true
onready var health : int = maximum_health
onready var curr_cooldown : float = shooting_cooldown


func hit(damage : int):
	health -= damage
