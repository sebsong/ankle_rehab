extends "res://Exercise/Exercise.gd"


func _ready():
	exercise_name = "Upward Press"
	exercise_type = Progress.ExerciseType.PRESS
	Progress.register_exercise(exercise_name, exercise_type)
	
