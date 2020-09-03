ChessBoard.print_square
It should not show a red dot when it the square already has a piece on the board. (currently over-writes piece).

# lib/chess_board.rb -- 11 warnings:

[126, 139, 146]:DataClump: ChessBoard takes parameters ['column_index', 'row_index'] to 3 methods 
[https://github.com/troessner/reek/blob/v6.0.1/docs/Data-Clump.md]

[67, 67]:DuplicateMethodCall: ChessBoard#update_original_coordinates calls '@active_piece.location' 2 times 
[https://github.com/troessner/reek/blob/v6.0.1/docs/Duplicate-Method-Call.md]

[146]:LongParameterList: ChessBoard#print_square has 4 parameters 
[https://github.com/troessner/reek/blob/v6.0.1/docs/Long-Parameter-List.md]

[32]:NilCheck: ChessBoard#valid_empty_moves? performs a nil-check 
[https://github.com/troessner/reek/blob/v6.0.1/docs/Nil-Check.md]

[4]:TooManyMethods: ChessBoard has at least 19 methods 
[https://github.com/troessner/reek/blob/v6.0.1/docs/Too-Many-Methods.md]

# lib/game.rb -- 5 warnings:

[71]:TooManyStatements: Game#select_move_coordinates has approx 9 statements 
[https://github.com/troessner/reek/blob/v6.0.1/docs/Too-Many-Statements.md]

[55]:TooManyStatements: Game#select_piece_coordinates has approx 10 statements 
[https://github.com/troessner/reek/blob/v6.0.1/docs/Too-Many-Statements.md]

[101]:UtilityFunction: Game#translate_coordinates doesn't depend on instance state (maybe move it to another class?) 
[https://github.com/troessner/reek/blob/v6.0.1/docs/Utility-Function.md]

# lib/pieces/pawn.rb -- 4 warnings:

[33, 34]:DuplicateMethodCall: Pawn#update_captures calls 'row + movement' 2 times 
[https://github.com/troessner/reek/blob/v6.0.1/docs/Duplicate-Method-Call.md]

[22, 32, 40]:RepeatedConditional: Pawn tests 'color == :white' at least 3 times 
[https://github.com/troessner/reek/blob/v6.0.1/docs/Repeated-Conditional.md]

[6]:TooManyInstanceVariables: Pawn has at least 5 instance variables 
[https://github.com/troessner/reek/blob/v6.0.1/docs/Too-Many-Instance-Variables.md]

[28]:TooManyStatements: Pawn#update_captures has approx 7 statements 
[https://github.com/troessner/reek/blob/v6.0.1/docs/Too-Many-Statements.md]
20 total warnings

[48, 48]:FeatureEnvy: Pawn#valid_capture_moves? refers to 'moves' more than self (maybe move it to another class?) [https://github.com/troessner/reek/blob/v6.0.1/docs/Feature-Envy.md]

[44, 44]:FeatureEnvy: Pawn#valid_empty_moves? refers to 'moves' more than self (maybe move it to another class?) [https://github.com/troessner/reek/blob/v6.0.1/docs/Feature-Envy.md]

