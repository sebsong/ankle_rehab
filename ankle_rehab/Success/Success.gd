extends Node2D

func _ready():
	Progress.reset_progress()

func _process(delta):
	$Label.rect_rotation += 50 * delta
	$Button.rect_rotation -= 50 * delta

func _on_Button_pressed():
	get_tree().change_scene("res://Main.tscn")
