extends Node3D
class_name Draggable

@export var camera: Camera3DRayCaster

@onready var rigid_body: RigidBody3D = %RigidBody3D
@onready var ghost_mesh: MeshInstance3D = %Ghost
@onready var original_orientation: Quaternion = Quaternion.from_euler(rigid_body.rotation).normalized()

var is_dragged: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
	if Input.is_action_just_pressed("object_drag"):
		var ray_cast_result = camera.ray_cast()
		if ray_cast_result == rigid_body:
			is_dragged = true
			rigid_body.freeze = true

			# Reset rotation of object to original
			var tween = get_tree().create_tween()
			tween.tween_property(rigid_body, "quaternion", original_orientation, 0.25)

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

func show_object() -> void:
	%RigidBody3D.visible = true
	ghost_mesh.visible = false

func hide_object() -> void:
	if %RigidBody3D.visible:
		var current_local_position: Vector3 = rigid_body.position
		ghost_mesh.position = current_local_position
		ghost_mesh.activate()

	%RigidBody3D.visible = false

func select_for_haunt() -> void:
	%RigidBody3D/MeshInstance3D.set_instance_shader_parameter("is_for_selection", true)

func deselect_for_haunt() -> void:
	%RigidBody3D/MeshInstance3D.set_instance_shader_parameter("is_for_selection", false)

func move_by_poltergeist(influence) -> void:
	# rigid_body.freeze = true

	var current_position: Vector3 = rigid_body.global_position

	influence.z = current_position.z
	rigid_body.apply_impulse(influence)

	# if not ghost_mesh.visible:
	# 	var current_local_position: Vector3 = rigid_body.position
	# 	ghost_mesh.position = current_local_position
	# 	ghost_mesh.activate()

	deselect_for_haunt()
