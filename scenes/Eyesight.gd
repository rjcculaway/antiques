extends SpotLight3D

class_name Eyesight

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
	var camera: Camera3D = %Camera3D

	if not Engine.is_editor_hint():
		var mouse_position: Vector2 = get_viewport().get_mouse_position()
		var from: Vector3 = camera.project_ray_origin(mouse_position)
		var to: Vector3 = camera.project_ray_normal(mouse_position)
		var depth: float = from.distance_to(%RigidBody3D.global_position)
		var final_position: Vector3 = from + to * depth
		global_position = Vector3(final_position.x, final_position.y, global_position.z)

	for antique: Draggable in get_tree().get_nodes_in_group("antiques"):
		
		var antique_rigid_body: RigidBody3D = antique.get_node("RigidBody3D") as RigidBody3D

		var antique_rigid_body_position: Vector3 = antique_rigid_body.global_position
		#			 v1    v2
		#\      |    /  /
		# \     |   /  /
		#  \    |  /  /
		#   \   | /  /
		#-------o---------
		var angle_to_flashlight = Vector3(global_position.x, global_position.y, antique_rigid_body_position.z).direction_to(global_position).angle_to(antique_rigid_body_position.direction_to(global_position))
		
		if angle_to_flashlight < deg_to_rad(spot_angle):
			antique.show_object()
		else:
			antique.hide_object()


func _on_eyesight_angle_control_value_changed(value: float) -> void:
	
	spot_angle = value

	return