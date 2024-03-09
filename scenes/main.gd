extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_poltergeist_timer_timeout():
	var antiques: Array[Node] = get_tree().get_nodes_in_group("antiques")
	var antique: Draggable = antiques.pick_random() as Draggable

	if antique:
		antique.move_by_poltergeist(Vector3(randf_range(-0.5, 0.5) * 1, randf_range(-0.5, 0.5) * 1, 1) * 10)
