package crawler

import rl "vendor:raylib"

menu_scene_update :: proc() {

}

menu_scene_draw :: proc() {

	rl.ClearBackground(rl.BLACK)

	rl.DrawText("here the menu", 10, 10, 20, rl.GRAY)

}
