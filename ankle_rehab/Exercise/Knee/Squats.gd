extends "res://Exercise/Exercise.gd"


func _ready():
	exercise_name = "Squats"
	exercise_type = Progress.ExerciseType.SQUATS
	Progress.register_exercise(exercise_name, exercise_type)
