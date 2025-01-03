package crawler

import "core:log"
import rl "vendor:raylib"

menu_scene_update :: proc(game_state: ^GameState, delta_time: f32) {
	if !game_state.assets_loaded {
		load_assets(game_state)
		game_state.assets_loaded = true
	}
	//will be updated later, for now jump to next state for the sake of testing
	game_state.current_scene_state = Scene.PLAYING
	crawler_log("change scene from menu to playing", LogLevel.DEBUG)
}

menu_scene_draw :: proc(game_state: ^GameState) {
	rl.ClearBackground(rl.BLACK)
	rl.DrawText("here the menu", 10, 10, 10, rl.GRAY)
}

load_assets :: proc(game_state: ^GameState) {
	crawler_log("start loading assets", LogLevel.DEBUG)
	game_state.texture_atlas = rl.LoadTexture("assets/0x72_DungeonTilesetII_v1.7.png")
	crawler_log("end loading assets", LogLevel.DEBUG)
}