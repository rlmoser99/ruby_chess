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


# lib/pieces/rook.rb -- 2 warnings:
[51]:UtilityFunction: Rook#row_decrease doesn't depend on instance state -> IGNORE
[42]:UtilityFunction: Rook#row_increase doesn't depend on instance state -> IGNORE
[39, 48, 71, 78, 85, 90]:DataClump: Rook takes parameters ['index', 'row'] to 6 methods -> IGNORE

# lib/pieces/knight.rb -- 2 warnings:
[28]:TooManyStatements: Knight#current_captures has approx 8 statements -> IGNORE
[15]:TooManyStatements: Knight#current_moves has approx 8 statements -> IGNORE

# lib/pieces/bishop.rb -- 3 warnings:
[49]:TooManyStatements: Bishop#diagonal_captures has approx 7 statements -> IGNORE
[35]:TooManyStatements: Bishop#diagonal_moves has approx 8 statements -> IGNORE
[66]:UtilityFunction: Bishop#invalid_location? doesn't depend on instance state -> IGNORE
