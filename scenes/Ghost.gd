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
func _process(delta):
	pass

func activate():
	visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "surface_material_override/0:albedo_color:a", max_opacity, fade_speed)
	await tween.finished

	%Timer.start(ghosting_timer)
	await %Timer.timeout

	var deactivate_tween = get_tree().create_tween()
	deactivate_tween.tween_property(self, "surface_material_override/0:albedo_color:a", min_opacity, fade_speed)
	await deactivate_tween.finished
	visible = false
