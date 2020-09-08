# lib/board.rb -- 1 warnings:

[58, 58]:FeatureEnvy: Board#update_active_piece_location refers to 'coords' more than self -> IGNORE


# lib/displayable.rb -- 7 warnings:
[61]:ControlParameter: Displayable#print_square is controlled by argument 'column_index' -> IGNORE
[61]:ControlParameter: Displayable#print_square is controlled by argument 'row_index' -> IGNORE
[17, 19]:DuplicateMethodCall: Displayable#print_board calls '8 - index' 2 times -> IGNORE
[17, 19]:DuplicateMethodCall: Displayable#print_board calls 'print' 2 times -> IGNORE
[9, 11]:DuplicateMethodCall: Displayable#print_chess_game calls 'puts' 2 times -> IGNORE
[57]:LongParameterList: Displayable#print_square has 4 parameters -> IGNORE
[6]:TooManyStatements: Displayable#print_chess_game has approx 6 statements -> IGNORE


# lib/game.rb -- 6 warnings:
[51, 54]:DuplicateMethodCall: Game#player_turn calls '@board.to_s' 2 times -> IGNORE
[70]:TooManyStatements: Game#select_move_coordinates has approx 8 statements -> IGNORE
[57]:TooManyStatements: Game#select_piece_coordinates has approx 9 statements -> IGNORE
[80]:UncommunicativeVariableName: Game#select_move_coordinates has the variable name 'e' -> IGNORE
[64]:UncommunicativeVariableName: Game#select_piece_coordinates has the variable name 'e' -> IGNORE
[109]:UtilityFunction: Game#translate_coordinates doesn't depend on instance state -> IGNORE


# lib/pieces/pawn.rb -- 2 warnings:
[28]:TooManyStatements: Pawn#current_captures has approx 7 statements -> IGNORE
[17]:TooManyStatements: Pawn#current_moves has approx 7 statements -> IGNORE


# lib/pieces/rook.rb -- 6 warnings:

[49, 58, 67, 76]:DataClump: Rook takes parameters ['index', 'row'] to 4 methods 
[https://github.com/troessner/reek/blob/v6.0.1/docs/Data-Clump.md]

[78, 80]:FeatureEnvy: Rook#file_decrease refers to 'index' more than self (maybe move it to another class?) 
[https://github.com/troessner/reek/blob/v6.0.1/docs/Feature-Envy.md]

[69, 71]:FeatureEnvy: Rook#file_increase refers to 'index' more than self (maybe move it to another class?) 
[https://github.com/troessner/reek/blob/v6.0.1/docs/Feature-Envy.md]

[60, 62]:FeatureEnvy: Rook#rank_decrease refers to 'index' more than self (maybe move it to another class?) 
[https://github.com/troessner/reek/blob/v6.0.1/docs/Feature-Envy.md]

[51, 53]:FeatureEnvy: Rook#rank_increase refers to 'index' more than self (maybe move it to another class?) 
[https://github.com/troessner/reek/blob/v6.0.1/docs/Feature-Envy.md]

[40]:TooManyStatements: Rook#file_moves has approx 6 statements 
[https://github.com/troessner/reek/blob/v6.0.1/docs/Too-Many-Statements.md]
