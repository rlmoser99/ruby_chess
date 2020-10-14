# lib/board.rb -- 9 warnings:
[181, 182]:DuplicateMethodCall: Board#remove_en_passant_capture calls '@data[row]' 2 times -> IGNORE
[59, 59, 60]:DuplicateMethodCall: Board#update_new_coordinates calls '@data[row]' 3 times -> IGNORE
[59, 59]:DuplicateMethodCall: Board#update_new_coordinates calls '@data[row][column]' 2 times -> IGNORE
[40, 40]:FeatureEnvy: Board#piece? refers to 'coords' more than self -> IGNORE
[71, 71]:FeatureEnvy: Board#update_active_piece_location refers to 'coords' more than self -> IGNORE
[146]:NestedIterators: Board#update_all_moves_captures contains iterators nested 2 deep -> IGNORE
[7]:TooManyInstanceVariables: Board has at least 5 instance variables -> IGNORE
[7]:TooManyMethods: Board has at least 21 methods -> IGNORE
[107]:TooManyStatements: Board#initial_placement has approx 7 statements -> IGNORE

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


# lib/move_validator.rb -- 7 warnings:
[23, 26]:DuplicateMethodCall: MoveValidator#legal_move? calls 'move[0]' 2 times -> IGNORE
[23, 26]:DuplicateMethodCall: MoveValidator#legal_move? calls 'move[1]' 2 times -> IGNORE
[23, 26]:DuplicateMethodCall: MoveValidator#legal_move? calls 'temp_board.data' 2 times -> IGNORE
[23, 26]:DuplicateMethodCall: MoveValidator#legal_move? calls 'temp_board.data[move[0]]' 2 times -> IGNORE
[33, 35]:FeatureEnvy: MoveValidator#safe_king? refers to 'square' more than self -> IGNORE
[32]:NestedIterators: MoveValidator#safe_king? contains iterators nested 2 deep -> IGNORE
[21]:TooManyStatements: MoveValidator#legal_move? has approx 6 statements -> IGNORE

# lib/pieces/bishop.rb -- 1 warnings:
[6]:TooManyInstanceVariables: Bishop has at least 5 instance variables -> IGNORE

# lib/pieces/king.rb -- 1 warning:
[6]:TooManyInstanceVariables: King has at least 5 instance variables 

# lib/pieces/knight.rb -- 3 warnings:
[6]:TooManyInstanceVariables: Knight has at least 5 instance variables
[30]:TooManyStatements: Knight#find_possible_captures has approx 7 statements 
[17]:TooManyStatements: Knight#find_possible_moves has approx 7 statements 

# lib/pieces/pawn.rb -- 2 warnings:
[6]:TooManyInstanceVariables: Pawn has at least 7 instance variables 

# lib/pieces/piece.rb -- 4 warnings:
[7]:TooManyInstanceVariables: Piece has at least 6 instance variables 
[90]:TooManyStatements: Piece#create_captures has approx 6 statements 
[76]:TooManyStatements: Piece#create_moves has approx 8 statements 
[102]:UtilityFunction: Piece#valid_location? doesn't depend on instance state

# lib/pieces/queen.rb -- 1 warning:
[6]:TooManyInstanceVariables: Queen has at least 5 instance variables 

# lib/pieces/rook.rb -- 1 warning:
[6]:TooManyInstanceVariables: Rook has at least 5 instance variables 

# TOTAL: 41 total warnings