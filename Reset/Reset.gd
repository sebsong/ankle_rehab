extends Node2D


func _ready():
	Progress.reset_progress()
	get_tree().change_scene("res://Main.tscn")
