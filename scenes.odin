package truck

import "core:fmt"
import rl "vendor:raylib"

game_over_scene :: proc(sk: ^SceneKind) {
    rl.DrawRectangle(0,0,1000,1000, rl.RED)
}

menu_scene :: proc(sk: ^SceneKind) {
    rl.DrawRectangle(0,0,1000,1000, rl.GREEN)
}

