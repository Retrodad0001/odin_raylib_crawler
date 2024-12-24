package crawler

import "base:runtime"
import "core:c"
import "core:log"
import "core:mem"

import rl "vendor:raylib"
import stbsp "vendor:stb/sprintf"

g_ctx: runtime.Context

Scene :: enum {
	MENU,
	PLAYING,
	GAMEOVER,
}

GeneralGameState :: struct {
	assets_loaded:       bool,
	current_scene_state: Scene,
	texture_atlas:       rl.Texture2D,
}

SpriteType::enum{
	PLAYER_IDLE_1,
	PLAYER_IDLE_2,
	PLAYER_IDLE_3,
}

main :: proc() {
	context.logger = log.create_console_logger(.Debug)
	g_ctx = context

	rl.SetTraceLogLevel(.ALL)
	rl.SetTraceLogCallback(
		proc "c" (rl_level: rl.TraceLogLevel, message: cstring, args: ^c.va_list) {
			context = g_ctx

			level: log.Level
			switch rl_level {
			case .TRACE, .DEBUG:
				level = .Debug
			case .INFO:
				level = .Info
			case .WARNING:
				level = .Warning
			case .ERROR:
				level = .Error
			case .FATAL:
				level = .Fatal
			case .ALL, .NONE:
				fallthrough
			case:
				log.panicf("unexpected log level %v", rl_level)
			}

			@(static) buf: [dynamic]byte
			log_len: i32
			for {
				buf_len := i32(len(buf))
				log_len = stbsp.vsnprintf(raw_data(buf), buf_len, message, args)
				if log_len <= buf_len {
					break
				}

				non_zero_resize(&buf, max(128, len(buf) * 2))
			}

			context.logger.procedure(
				context.logger.data,
				level,
				string(buf[:log_len]),
				context.logger.options,
			)
		},
	)

	if ODIN_DEBUG {
		log.debug("-- Memory detection is online! --")

		track: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		context.allocator = mem.tracking_allocator(&track)

		defer {
			if len(track.allocation_map) > 0 {
				log.warnf("=== %v allocations not freed: ===\n", len(track.allocation_map))
				for _, entry in track.allocation_map {
					log.warnf("- %v bytes @ %v\n", entry.size, entry.location)
				}
			}
			if len(track.bad_free_array) > 0 {
				log.warnf("=== %v incorrect frees: ===\n", len(track.bad_free_array))
				for entry in track.bad_free_array {
					log.warnf("- %p @ %v\n", entry.memory, entry.location)
				}
			}
			mem.tracking_allocator_destroy(&track)
		}
	}

	SCREEN_WIDTH :: i32(1920)
	SCREEN_HEIGHT :: i32(1080)

	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "raylib Odin crawler demo")
	defer rl.CloseWindow()

	rl.SetTargetFPS(60)

	//setup initial game state 
	general_game_state: GeneralGameState = {
		assets_loaded       = false,
		current_scene_state = Scene.MENU,
	}

	sprite_info := map[SpriteType]rl.Rectangle {
		SpriteType.PLAYER_IDLE_1 = {1, 1, 30, 30},
	}

	delta_time: f32 = rl.GetFrameTime()

	for !rl.WindowShouldClose() {

		delta_time: f32 = rl.GetFrameTime()

		rl.BeginDrawing()

		switch general_game_state.current_scene_state {
		case .MENU:
			menu_scene_update(&general_game_state, delta_time)
			menu_scene_draw(&general_game_state)
		case .PLAYING:
			play_scene_update(&general_game_state, delta_time)
			play_scene_draw(&general_game_state, sprite_info)
		case .GAMEOVER:
			game_over_scene_update(&general_game_state, delta_time)
			game_over_scene_draw(&general_game_state)
		}

		rl.EndDrawing()

		free_all(context.temp_allocator)
	}
}
