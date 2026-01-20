# Chess

The game Chess that is played on the command line. It works for both human and computer players (using a very basic AI picking moves at random). The game can be saved to a file and resumed later.

The game is set up in the menu, where the game can be loaded or a new one created. Once the game begins players take turns playing Chess until the game is over or the game is exited. This returns the user to the menu to play again or completely close the program.

Here is a nice summary of the rules, which this program also uses: https://www.chessvariants.org/d.chess/chess.html

If the link does not work then do a basic Google search, should you want to learn the rules yourself. 

From The Odin Project: https://www.theodinproject.com/lessons/ruby-ruby-final-project

## Input

### Move Notation

Each move is input in an altered reversible-algebraic form, where the piece taken is ignored in the notation: https://en.wikipedia.org/wiki/Chess_notation

This makes for easier transfer of information from human to computer (with no piece ambiguity).  

#### Examples: 
- e2-e4
- Ng1-f3
- Bf8-b4+
- Bb5xc6
- 0-0
- 0-0-0
- Ng8-f6#
- h7-h8=Q
- h7xg8=N#

#### Form:

[piece]start[-/x]end[=promotion/''][+/#/'']

#### Pieces:
- '' = Pawn
- R = Rook
- N = Knight
- B = Bishop
- Q = Queen
- K = King

#### Square Coordinates:

- a, b, c, d, e, f, g, h = files (columns)

- 1, 2, 3, 4, 5, 6, 7, 8 = ranks (rows)

- start/end = [file][rank] (e.g. e2, c6)

- a1 = bottom-left for White

- h8 = top-right for White

#### Other Parts: 
- \- means normal move (no taking)
- x means moving to take an opponent piece
- =promotion indicates the pawn promotion option: =Q, =R, =N, =B
- \+ means check (not required for input)
- \# means mate (not required for input)
- '' indicates nothing
- 0-0 = Castle king-side
- 0-0-0 = Castle queen-side
- En Passant is ignored for input

### Commands

#### Form:

command argument1 argument2 ...

Below, [parameter = argument, ...] is used to explain what the parameter is and the constraints of the arguments. The parameter is omitted when typing out the arguments to the terminal. 

#### Game Commands:
- move [move = Ng1-f3, etc.]
- force-draw [condition = 3-fold/50-move]
- offer-draw
- resign
- save [file_name]
- exit [optional: file_name]

#### Menu Commands:
- load [file_name]
- delete [file_name]
- close
- play [player1 = human/pc, player2 = human/pc, optional: random_color = random_color]

Note: All file names must use alphanumeric characters and - only.

#### Examples: 
- move Ng1-f3
- exit my-game
- play human pc
- resign

#### Invalid Input:
- Any commands not listed here
- Missing required arguments
- Too many arguments
- Invalid arguments (including moves in the incorrect format or invalid for the current state of the game)
- Extra space at the start, end, and between command/argument strings

## Output

The board is printed to the terminal after each move, making use of Chess symbols in Unicode.

Background colors are used to create the checker pattern of the board.

Other things are printed too, such as declaring check/mate, user input instructions, etc.

Lastly, save files can be saved to your file system.