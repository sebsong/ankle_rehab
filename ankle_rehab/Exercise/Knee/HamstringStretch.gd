extends "res://Exercise/Exercise.gd"


func _ready():
	exercise_name = "Hamstring Stretch"
	exercise_type = Progress.ExerciseType.HAMSTRING_STRETCH
	Progress.register_exercise(exercise_name, exercise_type)
