extends Node3D

var antique: Draggable = null

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_poltergeist_timer_timeout():

	if antique:
		antique.move_by_poltergeist(Vector3(randf_range(-2.5, 2.5), randf_range(-2.5, 2.5), 0))

	var antiques: Array[Node] = get_tree().get_nodes_in_group("antiques")
	antique = antiques.pick_random() as Draggable
	antique.select_for_haunt()
