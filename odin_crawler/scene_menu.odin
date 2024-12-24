package crawler

import "core:log"

import rl "vendor:raylib"

menu_scene_update :: proc(general_game_state: ^GeneralGameState, delta_time: f32) {

	if !general_game_state.assets_loaded {
		load_assets(general_game_state)
		general_game_state.assets_loaded = true
	}
	//will be updated later, for now jump to next state for the sake of testing
	general_game_state.current_scene_state = Scene.PLAYING
	log.debug("change scene from menu to playing")
}

menu_scene_draw :: proc(general_game_state: ^GeneralGameState) {

	rl.ClearBackground(rl.BLACK)

	rl.DrawText("here the menu", 10, 10, 20, rl.GRAY)
}

load_assets :: proc(general_game_state: ^GeneralGameState) {
	log.debug("start loading assets")

	general_game_state.texture_atlas = rl.LoadTexture("assets/0x72_DungeonTilesetII_v1.7.png")

	log.debug("end loading assets")
}
