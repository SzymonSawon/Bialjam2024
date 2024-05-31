package truck

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

draw_puff :: proc(w: ^World, position: rl.Vector3, duration, seed: f32) {
    t := (w.now - w.start_round_time) / duration
    for i := 0; i < 20; i +=1  {
        seed := math.mod(math.sin(rl.Vector2DotProduct(rl.Vector2{auto_cast i, seed}, rl.Vector2{12.9898, 78.233})) * 43758.5453, 1);
        direction := rl.Vector3{math.cos(seed * 251.25215), 0, math.sin(seed * 251.25215)}
        up := math.pow(math.cos(seed * 22.23132), 2)
        offset := direction + rl.Vector3{0, up, 0}
        rl.DrawBillboard(w.main_camera, w.assets.smoke_sprite, position + direction * 0.15 + offset * t * 0.5, 0.5 * (1-t), rl.WHITE)
    }
}
