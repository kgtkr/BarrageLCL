# Language Document
The language is like a function that takes a frameCount on each frame and returns bullets to be shotted on that frame. After setting the bullet, shot with the `shot` command.

Program is a sequence of commands. The command takes an expression as its parameter. Commands, functions and operators are overloaded. See [Language API](./docs/Language-API.md) for the available commands, functions and operators.

## Valid Character
* ASCII alphanumeric characters and symbols
* newline (LF)
* space

## Comments
The code after `#` is ignored.

## Commands
There are two commands: the proc command and the block command.

### Proc Command
The proc command changes the settings of the bullets, for example. 

The syntax is `command_name param1 param2 param3...;`.

### Block Command
A block command is a command with a sequence of commands as children. For example, there is a repetition of the command.

The syntax is `command_name param1 param2 param3... { commands... }`.

The block command scopes the settings of the bullet. The setting is inherited from the parent, but it is not passed from the child to the parent. However, if you add a `@` before the `{`, then it will be passed from the child to the parent.

It also pushes a new value on the count stack. Counts represent things like loop variables.

## Expressions
### Operator
There is a unary operator and a binary operator. The operator can use a sequence of `+-*/%`. The binary operator is a left associative. The precedence of the operator is determined by the first character of the symbol sequence.

1. `*/%`
2. `+-`

### Float Literal
The float literal is `<sequence of digits>` or `<sequence of digits>.<sequence of digits>`.

### Function Call
The function call is `function_name(param1, param2, ..., paramN)`.

### Variable Reference
The variable reference is `variable_name`.

## Data Types
* `float`
* `vec`
    * 3D vector
    * have three floats
* `color`
    * rgba
    * have four floats
    * For the color element, `0` is the lowest and `1` is the highest.
## Bullet settings
* `init_pos : vec`
    * initial position
* `init_vel : vec`
    * initial velocity
* `init_acc : vec`
    * acceleration
* `init_color : color`
    * initial color
* `delta_color : color`
    * color change per second.
* `init_radius`
    * initial radius
* `delta_radius`
    * radius change per second.
* `lifetime`
    * bullet lifetime
