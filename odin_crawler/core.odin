package crawler

import rl "vendor:raylib"

Scene :: enum {
	MENU,
	PLAYING,
	GAMEOVER,
}

GameState :: struct {
	assets_loaded:       bool,
	current_scene_state: Scene,
	show_debug:          bool,
	texture_atlas:       rl.Texture2D,
	camera:              rl.Camera2D,
	player:              Actor,
}

game_state_create :: proc(camera: ^rl.Camera2D, player: Actor) -> GameState {
	game_state: GameState = {
		assets_loaded       = false,
		current_scene_state = Scene.MENU,
		show_debug          = true,
		camera              = camera^,
		player              = player,
	}

	return game_state
}
