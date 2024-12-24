package crawler

import rl "vendor:raylib"

EntityId :: distinct int

ActorType :: enum {
	PLAYER,
}

Actor :: struct {
	actor_type: ActorType,
	position:   rl.Vector2,
}
