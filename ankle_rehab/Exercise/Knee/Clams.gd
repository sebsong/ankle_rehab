extends "res://Exercise/Exercise.gd"


func _ready():
	exercise_name = "Clams"
	exercise_type = Progress.ExerciseType.CLAMS
	Progress.register_exercise(exercise_name, exercise_type)
