extends CharacterBody3D
const SPEED = 3.0
const JUMP_VELOCITY = 7
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var collider_disabled = false
const max_jump = 2
var used_jump = 0
func _physics_process(delta):
	if collider_disabled:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept"):
		$jumpAudio.play()
		velocity.y = JUMP_VELOCITY


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("right", "left", "backward", "forward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
	var min_position = Vector3(5, 0.2, -1000)
	var max_position = Vector3(6, 2.5, 1000)
	global_position = global_position.clamp(min_position, max_position)
	# game over	
	await get_tree().create_timer(3.5).timeout #upstart
	#to fix early collission on the start of the game
	var collision = get_last_slide_collision()
	if collision:
		if !collider_disabled:
			print("Collided with: ", collision.get_collider())
			print("Gameover!")
			get_tree().change_scene_to_file("res://scenes/Gameover.tscn")# gameover func
# some buttons
func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/control.tscan")

func _on_left_pressed():
	var left_direction = -transform.basis.x
	left_direction = left_direction.normalized()
	velocity = left_direction * SPEED
	print("pressed for left")
#func _on_play_pressed() -> void:
	#var min_position = Vector3(-5, 0.2, -1000)
	#var max_position = Vector3(5, 10, 1000)
	#global_position = global_position.clamp(min_position, max_position)
func _on_rightt_pressed() -> void:
	print("pressed for right")

func _on_jump_pressed() -> void:
	var jumped = 0
	used_jump =  jumped + 1
	print_debug("added one jump")
	if used_jump > max_jump:
		await get_tree().create_timer(3.5).timeout
		print_debug("wait for cooldown")
	elif used_jump < max_jump:
		$jumpAudio.play()
		velocity.y = JUMP_VELOCITY



func _on_timer_timeout() -> void:
	print_debug("Jump cooldown over. You can jump again now.")
	# Any other instructions you want to execute when the cooldown ends
