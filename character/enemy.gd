extends "res://character/base_character.gd"


var vision_range: float = 300
var last_seen_position: Vector2 = Vector2.ZERO
var player: Node2D = null
var has_seen_player: bool = false


func _ready():
	player = get_node_or_null("../MainCharacter")  # Убедитесь, что путь к герою верный
	assert(player != null, "Player node not found! Check the path.")


func _physics_process(delta):
	if not player:
		return 

	var direction = Vector2.ZERO

	if can_see_player():
		# Если видим игрока, следуем за ним
		last_seen_position = player.global_position
		direction = (last_seen_position - global_position).normalized()
		has_seen_player = true
	elif has_seen_player:
		# Если не видим игрока, но знаем, где он был, идем к последней точке
		direction = (last_seen_position - global_position).normalized()
		
		# Если достигли последней точки, перестаем двигаться
		if global_position.distance_to(last_seen_position) < 10:
			has_seen_player = false
	else:
		# Если ни игрока, ни его следов нет, NPC остается на месте или выполняет другую логику
		direction = Vector2.ZERO

	# Движение NPC
	velocity = direction * SPEED
	move_and_slide()

# Проверяем, видит ли NPC игрока
func can_see_player() -> bool:
	if global_position.distance_to(player.global_position) > vision_range:
		return false  # Игрок слишком далеко

	# Создаем параметры для raycast
	var ray_parameters = PhysicsRayQueryParameters2D.new()
	ray_parameters.from = global_position
	ray_parameters.to = player.global_position
	ray_parameters.exclude = [self]  # Исключаем самого NPC из проверки

	# Выполняем запрос
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(ray_parameters)

	# Если результат пустой, пересечений нет
	if not result:
		return true  # Видимость есть, так как нет препятствий

	# Если есть пересечение, проверяем, не является ли это пересечение игроком
	if result["collider"] == player:
		return true  # Прямой путь к игроку

	return false
