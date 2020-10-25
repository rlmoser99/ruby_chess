# lib/board.rb -- 16 warnings:
[11]:Attribute: Board#active_piece is a writable attribute -> IGNORE
[11]:Attribute: Board#data is a writable attribute -> IGNORE
[11]:Attribute: Board#previous_piece is a writable attribute -> IGNORE
[66]:ControlParameter: Board#king_in_check? is controlled by argument 'color' -> IGNORE
[222]:ControlParameter: Board#no_legal_moves_captures? is controlled by argument 'color' -> IGNORE
[222, 224, 224]:FeatureEnvy: Board#no_legal_moves_captures? refers to 'piece' more than self -> IGNORE
[194, 194]:FeatureEnvy: Board#promotion_rank? refers to 'color' more than self -> IGNORE
[194, 194]:FeatureEnvy: Board#promotion_rank? refers to 'rank' more than self -> IGNORE
[79, 81, 81]:FeatureEnvy: Board#random_black_piece refers to 'piece' more than self -> IGNORE
[42, 42]:FeatureEnvy: Board#valid_piece? refers to 'coords' more than self -> IGNORE
[7]:TooManyInstanceVariables: Board has at least 6 instance variables -> IGNORE
[7]:TooManyMethods: Board has at least 28 methods -> IGNORE
[208]:TooManyStatements: Board#castling_moves? has approx 6 statements -> IGNORE
[108]:TooManyStatements: Board#initial_placement has approx 7 statements -> IGNORE
[65]:TooManyStatements: Board#king_in_check? has approx 6 statements -> IGNORE
[76]:TooManyStatements: Board#random_black_piece has approx 6 statements -> IGNORE

# lib/displayable.rb -- 7 warnings:
[68]:ControlParameter: Displayable#print_square is controlled by argument 'column_index' -> IGNORE
[68]:ControlParameter: Displayable#print_square is controlled by argument 'row_index' -> IGNORE
[22, 24]:DuplicateMethodCall: Displayable#print_board calls '8 - index' 2 times -> IGNORE
[22, 24]:DuplicateMethodCall: Displayable#print_board calls 'print "\e[36m #{8 - index} \e[0m"' 2 times -> IGNORE
[12, 14]:DuplicateMethodCall: Displayable#print_chess_board calls 'puts "\e[36m    a  b  c  d  e  f  g  h \e[0m"' 2 times -> IGNORE
[64]:LongParameterList: Displayable#print_square has 4 parameters -> IGNORE
[9]:TooManyStatements: Displayable#print_chess_board has approx 6 statements -> IGNORE

# lib/game.rb -- 10 warnings:
[76, 80]:DuplicateMethodCall: Game#computer_player_turn calls 'sleep(1.5)' 2 times -> IGNORE
[6]:TooManyMethods: Game has at least 19 methods -> IGNORE
[75]:TooManyStatements: Game#computer_player_turn has approx 7 statements -> IGNORE
[43]:TooManyStatements: Game#play has approx 6 statements -> IGNORE
[98]:TooManyStatements: Game#select_move_coordinates has approx 7 statements -> IGNORE
[86]:TooManyStatements: Game#select_piece_coordinates has approx 8 statements -> IGNORE
[118]:TooManyStatements: Game#user_select_move has approx 6 statements -> IGNORE
[103]:UncommunicativeVariableName: Game#select_move_coordinates has the variable name 'e' -> IGNORE
[92]:UncommunicativeVariableName: Game#select_piece_coordinates has the variable name 'e' -> IGNORE
[172]:UtilityFunction: Game#translate_coordinates doesn't depend on instance state -> IGNORE

# lib/move_validator.rb -- 1 warning:
[50, 52]:FeatureEnvy: MoveValidator#safe_king? refers to 'piece' more than self -> IGNORE

# lib/movement/castling_movement.rb -- 1 warning:
[24]:TooManyStatements: CastlingMovement#update_castling_moves has approx 7 statements -> IGNORE

# lib/movement/pawn_promotion_movement.rb -- 1 warning:
[24]:TooManyStatements: PawnPromotionMovement#update_pawn_promotion_moves has approx 6 statements -> IGNORE

# lib/pieces/bishop.rb -- 1 warning:
[6]:TooManyInstanceVariables: Bishop has at least 5 instance variables -> IGNORE

# lib/pieces/king.rb -- 3 warnings:
[92, 92, 94]:FeatureEnvy: King#safe_passage? refers to 'piece' more than self -> IGNORE
[85]:NilCheck: King#king_pass_through_safe? performs a nil-check -> IGNORE
[6]:TooManyInstanceVariables: King has at least 6 instance variables -> IGNORE

# lib/pieces/knight.rb -- 3 warnings:
[6]:TooManyInstanceVariables: Knight has at least 5 instance variables -> IGNORE
[30]:TooManyStatements: Knight#find_possible_captures has approx 7 statements -> IGNORE
[17]:TooManyStatements: Knight#find_possible_moves has approx 7 statements -> IGNORE

# lib/pieces/pawn.rb -- 1 warning:
[6]:TooManyInstanceVariables: Pawn has at least 7 instance variables -> IGNORE

# lib/pieces/piece.rb -- 4 warnings:
[7]:TooManyInstanceVariables: Piece has at least 6 instance variables -> IGNORE
[92]:TooManyStatements: Piece#create_captures has approx 6 statements -> IGNORE
[77]:TooManyStatements: Piece#create_moves has approx 8 statements -> IGNORE
[105]:UtilityFunction: Piece#valid_location? doesn't depend on instance state -> IGNORE

# lib/pieces/queen.rb -- 1 warning:
[6]:TooManyInstanceVariables: Queen has at least 5 instance variables -> IGNORE

# lib/pieces/rook.rb -- 1 warning:
[6]:TooManyInstanceVariables: Rook has at least 6 instance variables -> IGNORE

# 50 total warnings