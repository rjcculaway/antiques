extends MeshInstance3D
class_name GhostMesh

@export var fade_speed: float = 0.125
@export var min_opacity: float = 0.0
@export var max_opacity: float = 0.5
@export var ghosting_timer: float = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func activate() -> void:
	# Have the "ghost" object copy the orientation of the real object.
	var parent: Draggable = get_parent() as Draggable
	quaternion = parent.rigid_body.quaternion

	visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "instance_shader_parameters/Maximum_Opacity", max_opacity, fade_speed)
	await tween.finished

	# The "ghost" object is retained for <ghosting_timer> seconds.
	%Timer.start(ghosting_timer)
	await %Timer.timeout

	var deactivate_tween = get_tree().create_tween()
	deactivate_tween.tween_property(self, "instance_shader_parameters/Maximum_Opacity", min_opacity, fade_speed)
	await deactivate_tween.finished
	visible = false