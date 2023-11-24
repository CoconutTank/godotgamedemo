extends Node

@export var mob_blueprint: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	#new_game()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func new_game():
	score = 0
	get_tree().call_group("mobs", "queue_free")
	$Player.player_start_at($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready...")
	$Music.play()


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$GameOverSound.play()


func _on_start_timer_timeout():
	$ScoreTimer.start()
	$MobTimer.start()


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_mob_timer_timeout():
	# Create a new instance of the Mob.
	var mob = mob_blueprint.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(mob.min_mob_speed, mob.max_mob_speed), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Resize the mob and their collision area.
	var newTransform = Transform2D()
	var rescale = randf_range(mob.min_mob_scale, mob.max_mob_scale)
	newTransform.x *= rescale
	newTransform.y *= rescale
	mob.get_node("MobAnimations").transform = newTransform
	mob.get_node("MobCollision").transform = newTransform

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
