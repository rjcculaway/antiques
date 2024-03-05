extends Node3D
class_name Draggable

@export var rigid_body: RigidBody3D
@export var camera: Camera3DRayCaster
var is_dragged: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("object_drag"):
		# print(camera.ray_cast())
		rigid_body.freeze = true

	var ray_cast_result = camera.ray_cast()
	if ray_cast_result == rigid_body and Input.is_action_pressed("object_drag"):

		var current_position: Vector3 = rigid_body.global_position

		var mouse_position: Vector2 = get_viewport().get_mouse_position()
		var from: Vector3 = camera.project_ray_origin(mouse_position)
		var to: Vector3 = camera.project_ray_normal(mouse_position)
		var depth: float = from.distance_to(rigid_body.global_position)
		var final_position: Vector3 = from + to * depth

		var influence: Vector3 = final_position - current_position
		influence.z = current_position.z
		rigid_body.move_and_collide(influence)
		# rigid_body.global_position = Vector3(final_position.x, final_position.y, rigid_body.global_position.z)

	if Input.is_action_just_released("object_drag"):
		rigid_body.freeze = false