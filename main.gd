extends Node

@export var coin_scene: PackedScene
@export var playtime = 30

var level = 1
var score = 0
var time_left = 0
var screensize = Vector2.ZERO
var playing = false

func _ready():
    screensize = get_viewport().get_visible_rect().size
    $Player.screensize = screensize
    new_game()

func new_game():
    playing = true
    level = 1
    score = 0
    time_left = playtime
    $Player.show()
    $Player.start()
    $GameTimer.start()
    spawn_coins()

func spawn_coins():
    for i in level + 4:
        var c = coin_scene.instantiate()
        add_child(c)
        c.screensize = screensize
        c.position = Vector2(randi_range(20, int(screensize.x) - 20),
            randi_range(20, int(screensize.y) - 20))

func _process(_delta):
    if playing and get_tree().get_nodes_in_group("coins").size() == 0:
        level += 1
        time_left += 5
        spawn_coins()

func _on_game_timer_timeout():
    if not playing:
        return
    time_left -= 1
    if time_left <= 0:
        playing = false
        $GameTimer.stop()
        $Player.die()
        print("Fim de jogo! Pontuação: ", score)

func _on_player_pickup():
    if playing:
        score += 1
        print("Moedas coletadas: ", score)
