package crawler

import rl "vendor:raylib"

SpriteType :: enum {
	knight_m_idle_anim_f0,
	knight_m_idle_anim_f1,
	knight_m_idle_anim_f2,
	knight_m_idle_anim_f3,
	knight_m_run_anim_f0,
	knight_m_run_anim_f1,
	knight_m_run_anim_f2,
	knight_m_run_anim_f3,
	knight_m_hit_anim_f0,
}

sprite_info_create :: proc() -> map[SpriteType]rl.Rectangle {
	sprite_info := map[SpriteType]rl.Rectangle {
		SpriteType.knight_m_idle_anim_f0 = {128, 100, 16, 28},
		SpriteType.knight_m_idle_anim_f1 = {144, 100, 16, 28},
		SpriteType.knight_m_idle_anim_f2 = {160, 100, 16, 28},
		SpriteType.knight_m_idle_anim_f3 = {176, 100, 16, 28},
		SpriteType.knight_m_run_anim_f0  = {192, 100, 16, 28},
		SpriteType.knight_m_run_anim_f1  = {208, 100, 16, 28},
		SpriteType.knight_m_run_anim_f2  = {224, 100, 16, 28},
		SpriteType.knight_m_run_anim_f3  = {240, 100, 16, 28},
		SpriteType.knight_m_hit_anim_f0  = {256, 100, 16, 28},
	}

	return sprite_info
}


//knight_m_idle_anim_f0 128 100 16 28
//knight_m_idle_anim_f1 144 100 16 28
//knight_m_idle_anim_f2 160 100 16 28
//knight_m_idle_anim_f3 176 100 16 28
//knight_m_run_anim_f0 192 100 16 28
//knight_m_run_anim_f1 208 100 16 28
//knight_m_run_anim_f2 224 100 16 28
//knight_m_run_anim_f3 240 100 16 28
//knight_m_hit_anim_f0 256 100 16 28
