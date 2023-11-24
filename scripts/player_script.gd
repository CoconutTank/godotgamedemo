extends Area2D

signal player_hit

@export var speed = 400 # player speed in pixels / second
var screen_size # size of screen window

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if (Input.is_action_pressed("kb_right")):
		velocity.x += 1
	if (Input.is_action_pressed("kb_down")):
		velocity.y += 1
	if (Input.is_action_pressed("kb_left")):
		velocity.x -= 1
	if (Input.is_action_pressed("kb_up")):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$PlayerAnimations.play()
	else:
		$PlayerAnimations.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$PlayerAnimations.animation = "walk"
		$PlayerAnimations.flip_v = false
		$PlayerAnimations.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$PlayerAnimations.animation = "up"
		$PlayerAnimations.flip_v = velocity.y > 0


func _on_body_entered(body):
	hide() # Player disappears after being hit.
	player_hit.emit()
	$PlayerCollision.set_deferred("disabled", true)


func player_start_at(new_pos):
	position = new_pos
	show()
	$PlayerCollision.disabled = false
