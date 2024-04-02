extends SpotLight3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var camera: Camera3D = %Camera3D
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	var from: Vector3 = camera.project_ray_origin(mouse_position)
	var to: Vector3 = camera.project_ray_normal(mouse_position)
	var depth: float = from.distance_to(%RigidBody3D.global_position)
	var final_position: Vector3 = from + to * depth
	global_position = Vector3(final_position.x, final_position.y, global_position.z)
