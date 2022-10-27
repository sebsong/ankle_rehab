extends "res://Exercise/Exercise.gd"


func _ready():
	exercise_name = "Figure 4 Hip Stretch"
	exercise_type = Progress.ExerciseType.FIG_4_HIP_STRETCH
	Progress.register_exercise(exercise_name, exercise_type)
