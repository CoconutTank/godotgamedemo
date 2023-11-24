extends RigidBody2D

@export var min_mob_speed = 100.0
@export var max_mob_speed = 300.0

@export var min_mob_scale = 0.5
@export var max_mob_scale = 1.5

# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $MobAnimations.sprite_frames.get_animation_names()
	$MobAnimations.play(mob_types[randi() % mob_types.size()])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mob_visible_notifier_screen_exited():
	queue_free()


func decorate_self():
	pass
