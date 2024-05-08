extends Node3D

var antique: Draggable = null
@export var levels: Array[Marker3D] = []
@export var number_of_shelf_objects: int = 12
@export var possible_objects: Array[PackedScene] = []

# Called when the node enters the scene tree for the first time.
func _ready():
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
		new_object.global_translate(Vector3(randf_range(-0.5, 0.5), 0, 0))
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_poltergeist_timer_timeout() -> void:

	if antique:
		antique.move_by_poltergeist(Vector3(randf_range(-2.5, 2.5), randf_range(-2.5, 2.5), 0))

	var antiques: Array[Node] = get_tree().get_nodes_in_group("antiques")
	antique = antiques.pick_random() as Draggable
	antique.select_for_haunt()
