extends "res://Exercise/Exercise.gd"


func _ready():
	exercise_name = "Knee Hug"
	exercise_type = Progress.ExerciseType.KNEE_HUG
	Progress.register_exercise(exercise_name, exercise_type)
