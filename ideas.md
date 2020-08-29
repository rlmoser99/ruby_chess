lib/game.rb -- 10 warnings:
  [42, 44]:DuplicateMethodCall: Game#player_turn calls 'piece_coords[:column]' 2 times [https://github.com/troessner/reek/blob/v6.0.1/docs/Duplicate-Method-Call.md]
  [42, 44]:DuplicateMethodCall: Game#player_turn calls 'piece_coords[:row]' 2 times [https://github.com/troessner/reek/blob/v6.0.1/docs/Duplicate-Method-Call.md]
  [92]:UtilityFunction: Game#translate_coordinates doesn't depend on instance state (maybe move it to another class?) [https://github.com/troessner/reek/blob/v6.0.1/docs/Utility-Function.md]
lib/pieces/pawn.rb -- 4 warnings:
  [14]:TooManyStatements: Pawn#update_moves has approx 6 statements [https://github.com/troessner/reek/blob/v6.0.1/docs/Too-Many-Statements.md]
20 total warnings
