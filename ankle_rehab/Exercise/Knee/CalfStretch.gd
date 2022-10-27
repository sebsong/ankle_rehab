extends "res://Exercise/Exercise.gd"


func _ready():
	exercise_name = "Calf Stretch"
	exercise_type = Progress.ExerciseType.CALF_STRETCH
	Progress.register_exercise(exercise_name, exercise_type)
