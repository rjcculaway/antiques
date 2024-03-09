extends MeshInstance3D
class_name GhostMesh

@export var min_opacity: float = 0.0
@export var max_opacity: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func activate():
	visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "surface_material_override/0:albedo_color:a", max_opacity, 0.25)

	await get_tree().create_timer(5.0).timeout

	var deactivate_tween = get_tree().create_tween()
	deactivate_tween.tween_property(self, "surface_material_override/0:albedo_color:a", min_opacity, 0.25)
	visible = false