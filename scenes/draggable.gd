extends Node3D
class_name Draggable

@export var camera: Camera3DRayCaster

@onready var rigid_body: RigidBody3D = %RigidBody3D
@onready var ghost_mesh: MeshInstance3D = %Ghost

var is_dragged: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("object_drag"):
		var ray_cast_result = camera.ray_cast()
		if ray_cast_result == rigid_body:
			is_dragged = true
			rigid_body.freeze = true

			# Spawn a ghost if the new position is very different from the original position
			if not ghost_mesh.visible:
				var current_local_position: Vector3 = rigid_body.position
				ghost_mesh.position = current_local_position
				ghost_mesh.activate()

	if is_dragged:
		var current_position: Vector3 = rigid_body.global_position

		var mouse_position: Vector2 = get_viewport().get_mouse_position()
		var from: Vector3 = camera.project_ray_origin(mouse_position)
		var to: Vector3 = camera.project_ray_normal(mouse_position)
		var depth: float = from.distance_to(rigid_body.global_position)
		var final_position: Vector3 = from + to * depth

		var influence: Vector3 = final_position - current_position
		influence.z = current_position.z
		rigid_body.move_and_collide(influence)
			
	if Input.is_action_just_released("object_drag"):
		is_dragged = false
		rigid_body.freeze = false

func move_by_poltergeist(influence):
	# rigid_body.freeze = true

	if not ghost_mesh.visible:
		var current_local_position: Vector3 = rigid_body.position
		ghost_mesh.position = current_local_position
		ghost_mesh.activate()

	var current_position: Vector3 = rigid_body.global_position

	influence.z = current_position.z
	rigid_body.apply_impulse(influence)

	# rigid_body.freeze = false