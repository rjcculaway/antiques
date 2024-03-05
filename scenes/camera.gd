extends Camera3D
class_name Camera3DRayCaster

const RAY_LENGTH: float = 1000.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func ray_cast():

	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state

	var mouse_position = get_viewport().get_mouse_position()
	var from: Vector3 = project_ray_origin(get_viewport().get_mouse_position())
	var to: Vector3 = from + project_ray_normal(mouse_position) * RAY_LENGTH

	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = space_state.intersect_ray(query)

	return result.get("collider")
