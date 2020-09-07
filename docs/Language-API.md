# Language API
## Core
### `count : float` / `count(n: float) : float`, alias: `i`
Return the `n` th value from the top of the count stack. The default value of n is 0 (top of the stack). `n` must be a non-negative integer float literal and less than the depth of nested blocks.

### `shot`
Shots bullets at the current setting. It must be used inside a block command.

### `sound`
Sound the shot.　It must be used inside a block command.

## Bullets setting(Core)
### `init_pos vec` / `init_pos: vec`, alias: `p0`
Set the value of `init_pos` or return the current value.

### `init_vel vec` / `init_vel: vec`, alias: `v0`
Set the value of `init_vel` or return the current value.

### `acc vec` / `acc: vec`, alias: `a`
Set the value of `acc` or return the current value.

### `init_color color` / `init_color: color`, alias: `c0`
Set the value of `init_color` or return the current value.

### `delta_color color` / `delta_color: color`, alias: `dc`
Set the value of `delta_color` or return the current value.

### `init_radius float` / `init_radius: float`, alias: `r0`
Set the value of `init_radius` or return the current value.

### `delta_radius float` / `delta_radius: float`, alias: `dr`
Set the value of `delta_radius` or return the current value.

### `lifetime float` / `lifetime: float`
Set the value of `lifetime` or return the current value.

## Block Cmd
### `per_sec n: float { ... }`
Run `n` times per second. It must to be used at the top level.  
The `count` is the number of times it has been executed.

### `sec_per n: float { ... }`
This equals `per_sec 1 / n`.

### `times n: float { ... }`
Repeat `n` times. It is not available at the top level. `n` must be a positive integer float literal.
The `count` is a loop variable.

### `cycle n: float { ... }`
Set `count` to a mod of `n` and run it. It is not available at the top level.  

### `skip n: float { ... }`
Skip execution if count is less than `n`.
`count` is the value minus n.

### `take n: float { ... }`
Execute when count is less than `n`. It is not available at the top level.
`count` is unchanged.

### `thin n: float { ... }`
Execute when count is a multiple of `n`. It is not available at the top level.
`count` is the value divided by `n`.

## Bullets setting(Utils)
### `fadeout t: float init_alpha: float = 1`
Set the `init_color.a` and `delta_color.a` to become transparent from `init_alpha` in t seconds.

### `fadein t: float init_alpha: float = 0`
Set the `init_color.a` and `delta_color.a` to become `init_alpha` from transparent in t seconds.

### `color_to_color c0: color ct: color t: float`, alias: `c2c`
Set `init_color` and `delta_color` to change color from `c0` to `ct` in t seconds.

### `vel_up k: float`
Set `delta_vel` so that `vel` is increased by `k` times per second.

### `vel_down k: float`
This equals `vel_up -k`.

## Float
### `PI: float`
### `E: float`
### `float + float: float`
### `float - float: float`
### `float * float: float`
### `float / float: float`
### `float % float: float`
### `+float: float`
### `-float: float`
### `sin(float): float`
### `cos(float): float`
### `tan(float): float`
### `log(float): float`
### `exp(float): float`
### `max(float, float): float`
### `min(float, float): float`
### `sqrt(float): float`
### `abs(float): float`
### `pow(float, float): float`
### `round(float): float`
### `ceil(float): float`
### `floor(float): float`
### `atan(float): float`
### `asin(float): float`
### `acos(float): float`
### `atan2(float, float): float`
### `to_rad(float): float`
Converts an angle to a radian.
### `rand_theta(): float`
Returns a random number from `0 to 2π`.
### `rand() : float` / `rand(max: float): float` / `rand(min: float, max: float): float`
Returns a random number from `0 to 1` / `0 to max` / `min to max`.

## Vec
### `vec(float, float, float): vec`
Create a vec from xyz.
### `vec_rl(float, float, float): vec`
Create a vec from two angles and length.

## Color
### `color(float, float, float, float = 1): color`
Create a vec from rgba.
### `red: color`
### `green: color`
### `blue: color`
### `cyan: color`
### `magenta: color`
### `yellow: color`
### `black: color`
### `white: color`
