extends Node3D

var haunted_antique: Draggable = null
@export var levels: Array[Marker3D] = []
@export var number_of_shelf_objects: int = 4
@export var possible_objects: Array[PackedScene] = []

@export var score_thresholds: Dictionary = {
	"E": 0.9,
	"D" : 0.6,
	"C" : 0.4,
	"B" : 0.25,
	"A" : 0.12,
}

func _enter_tree() -> void:
	assert(len(score_thresholds) == 5, "Score thresholds must only be five.")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	# Create haunted objects
	for i in range(number_of_shelf_objects):
		var selected_object: PackedScene = possible_objects.pick_random()
		var level: Marker3D = levels.pick_random()

		var new_object: Draggable = selected_object.instantiate() as Draggable
		# print_debug(new_object.get_class())
		# assert(new_object.is_class("Draggable"))
		new_object.camera = %Camera3D
		add_child(new_object)
		new_object.global_position = level.global_position
		new_object.global_translate(Vector3(randf_range(-0.75, 0.75), 0, 0)) # Move object left or right
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_poltergeist_timer_timeout() -> void:

	if haunted_antique:
		haunted_antique.move_by_poltergeist(Vector3(randf_range(-2.5, 2.5), randf_range(-2.5, 2.5), 0))

	var antiques: Array[Node] = get_tree().get_nodes_in_group("antiques")
	haunted_antique = antiques.pick_random() as Draggable
	assert(haunted_antique != null, "There are no valid haunted antiques!")
	haunted_antique.select_for_haunt()


func compute_average_distance(antiques: Array[Node]) -> float:
	var ave_distance: float = 0.0
	var num_of_antiques: int = len(antiques)
	for antique: Draggable in antiques:
		# Use the local position of the antique's rigid body to determine if it is far from its original position
		ave_distance += antique.rigid_body.position.length()
		# ave_rotation_diff += antique.quaternion.get_angle()
	return ave_distance / num_of_antiques

func compute_average_normalized_angles(antiques: Array[Node]) -> float:
	var ave_normalized_angles: float = 0.0
	var num_of_antiques: int = len(antiques)
	for antique: Draggable in antiques:
		# Use the local angle of the antique's rigid body to determine if it is far from its original position
		ave_normalized_angles += antique.rigid_body.quaternion.get_angle() / 360.0
		# ave_rotation_diff += antique.quaternion.get_angle()

	return ave_normalized_angles / num_of_antiques

func get_overall_score(antiques: Array[Node]) -> float:
	return (compute_average_distance(antiques) + compute_average_normalized_angles(antiques)) / 2

func get_letter_score(overall_score: float) -> String:
	
	print_debug("score:", str(overall_score))

	for letter: String in score_thresholds:
		if overall_score > score_thresholds[letter]:
			return letter

	return "S"

func _on_game_timer_timeout() -> void:
	
	var antiques: Array[Node] = get_tree().get_nodes_in_group("antiques")
	# var ave_rotation_diff: float = 0.0
	
	# ave_rotation_diff /= num_of_antiques
	var overall_score: float = get_overall_score(antiques)
	var letter_score: String = get_letter_score(overall_score)
	print_debug("overall difference is ", overall_score)
	# Stop poltergeist
	%PoltergeistTimer.stop()
	if haunted_antique != null:
		haunted_antique.deselect_for_haunt()

	# Display game over
	%ScoreLabel.text = str(int(overall_score * 100)) + "%"
	%LetterScore.text = letter_score
	%LetterScore.visible = true
	%GameOverSection.visible = true
