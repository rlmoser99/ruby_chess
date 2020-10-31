# REMOVE INSTANCE VARIABLE SET
spec/board_spec.rb:
  326        it 'returns true' do
  327:         board.instance_variable_set(:@previous_piece, white_pawn)
  328          allow(black_pawn).to receive(:captures).and_return([[4, 3]])

  352        it 'returns false' do
  353:         board.instance_variable_set(:@previous_piece, white_pawn)
  354          allow(black_pawn).to receive(:captures).and_return([[4, 3]])

  378        it 'returns false' do
  379:         board.instance_variable_set(:@previous_piece, black_pawn)
  380          allow(white_pawn).to receive(:captures).and_return([[3, 3]])

  406        it 'returns true' do
  407:         board.instance_variable_set(:@white_king, white_king)
  408          result = board.king_in_check?(:white)

  430        it 'returns false' do
  431:         board.instance_variable_set(:@white_king, white_king)
  432          result = board.king_in_check?(:white)

  476        it 'is not game over' do
  477:         board.instance_variable_set(:@previous_piece, black_queen)
  478:         board.instance_variable_set(:@white_king, white_king)
  479          expect(board.game_over?).to be false

  500        it 'is not game over' do
  501:         board.instance_variable_set(:@previous_piece, black_queen)
  502:         board.instance_variable_set(:@white_king, white_king)
  503          expect(board.game_over?).to be false

  525        it 'is game over' do
  526:         board.instance_variable_set(:@previous_piece, bqn)
  527:         board.instance_variable_set(:@white_king, wkg)
  528          expect(board.game_over?).to be true

  551        it 'is game over' do
  552:         board.instance_variable_set(:@previous_piece, bqn)
  553:         board.instance_variable_set(:@white_king, wkg)
  554          expect(board.game_over?).to be true

  576        it 'returns true' do
  577:         board.instance_variable_set(:@active_piece, white_pawn)
  578          coords = { row: 0, column: 1 }

  600        it 'returns false' do
  601:         board.instance_variable_set(:@active_piece, white_rook)
  602          coords = { row: 0, column: 1 }

  624        it 'returns true' do
  625:         board.instance_variable_set(:@active_piece, black_pawn)
  626          coords = { row: 7, column: 3 }

  648        it 'returns false' do
  649:         board.instance_variable_set(:@active_piece, black_rook)
  650          coords = { row: 7, column: 3 }

spec/game_spec.rb:
   98          allow(game).to receive(:puts)
   99:         game.instance_variable_set(:@current_turn, :black)
  100          allow(board).to receive(:to_s)

  113          allow(game).to receive(:puts)
  114:         game.instance_variable_set(:@current_turn, :white)
  115          allow(board).to receive(:to_s)

  128          allow(game).to receive(:puts)
  129:         game.instance_variable_set(:@current_turn, :black)
  130          allow(board).to receive(:to_s)

  363        it 'changes to :black' do
  364:         game.instance_variable_set(:@current_turn, :white)
  365          game.send(:switch_color)

  372        it 'changes to :white' do
  373:         game.instance_variable_set(:@current_turn, :black)
  374          game.send(:switch_color)

spec/move_validator_spec.rb:
   33        it 'returns move for king to capture rook' do
   34:         board.instance_variable_set(:@black_king, board.data[0][4])
   35:         validator.instance_variable_set(:@current_piece, board.data[0][4])
   36          results = validator.verify_possible_moves

   62        it 'return moves that will not put King in check' do
   63:         board.instance_variable_set(:@black_king, board.data[0][4])
   64:         validator.instance_variable_set(:@current_piece, board.data[2][4])
   65          results = validator.verify_possible_moves

   86          it 'returns move to kill the queen' do
   87:           board.instance_variable_set(:@white_king, board.data[7][6])
   88:           validator.instance_variable_set(:@current_piece, board.data[2][7])
   89            results = validator.verify_possible_moves

  101          it 'returns move to block the queen' do
  102:           board.instance_variable_set(:@white_king, board.data[7][6])
  103:           validator.instance_variable_set(:@current_piece, board.data[3][4])
  104            results = validator.verify_possible_moves

  116          it 'returns move to block the queen' do
  117:           board.instance_variable_set(:@white_king, board.data[7][6])
  118:           validator.instance_variable_set(:@current_piece, board.data[4][5])
  119            results = validator.verify_possible_moves

  131          it 'returns two moves to block the queen' do
  132:           board.instance_variable_set(:@white_king, board.data[7][6])
  133:           validator.instance_variable_set(:@current_piece, board.data[5][7])
  134            results = validator.verify_possible_moves

  145          it 'returns four legal moves' do
  146:           board.instance_variable_set(:@white_king, board.data[7][6])
  147:           validator.instance_variable_set(:@current_piece, board.data[7][6])
  148            results = validator.verify_possible_moves

  160          it 'has no moves' do
  161:           board.instance_variable_set(:@white_king, board.data[7][6])
  162:           pawn_validator.instance_variable_set(:@current_piece, board.data[6][4])
  163            results = pawn_validator.verify_possible_moves

spec/movement/castling_movement_spec.rb:
  90        allow(board).to receive(:data).and_return(data)
  91:       movement.instance_variable_set(:@board, board)
  92:       movement.instance_variable_set(:@row, 0)
  93:       movement.instance_variable_set(:@column, 6)
  94        result = movement.send(:find_castling_rook)

spec/movement/pawn_promotion_movement_spec.rb:
   71        it 'creates a new Queen' do
   72:         movement.instance_variable_set(:@board, board)
   73:         movement.instance_variable_set(:@row, 7)
   74:         movement.instance_variable_set(:@column, 1)
   75          allow(board).to receive(:mode).and_return(:computer)

   87        before do
   88:         movement.instance_variable_set(:@board, board)
   89:         movement.instance_variable_set(:@row, 7)
   90:         movement.instance_variable_set(:@column, 1)
   91          allow(movement).to receive(:puts)

  121      it 'creates a new piece' do
  122:       movement.instance_variable_set(:@board, board)
  123:       movement.instance_variable_set(:@row, 7)
  124:       movement.instance_variable_set(:@column, 1)
  125        pawn_move_info = { color: :black, location: [7, 1] }


# REMOVE SEND

spec/board_spec.rb:
  209      before do
  210:       board.send(:reset_board_values)
  211      end

  270          coordinates = { row: 0, column: 0 }
  271:         board.send(:create_movement, coordinates)
  272        end

  280          coordinates = { row: 0, column: 0 }
  281:         board.send(:create_movement, coordinates)
  282        end

  291          coordinates = { row: 0, column: 0 }
  292:         board.send(:create_movement, coordinates)
  293        end

  302          coordinates = { row: 0, column: 0 }
  303:         board.send(:create_movement, coordinates)
  304        end

  578          coords = { row: 0, column: 1 }
  579:         result = board.send(:pawn_promotion?, coords)
  580          expect(result).to be true

  602          coords = { row: 0, column: 1 }
  603:         result = board.send(:pawn_promotion?, coords)
  604          expect(result).to be false

  626          coords = { row: 7, column: 3 }
  627:         result = board.send(:pawn_promotion?, coords)
  628          expect(result).to be true

  650          coords = { row: 7, column: 3 }
  651:         result = board.send(:pawn_promotion?, coords)
  652          expect(result).to be false

spec/game_spec.rb:
  102          expect(game).to receive(:human_player_turn)
  103:         game.send(:player_turn)
  104        end

  117          expect(game).to receive(:human_player_turn)
  118:         game.send(:player_turn)
  119        end

  132          expect(game).to receive(:computer_player_turn)
  133:         game.send(:player_turn)
  134        end

  148        expect(board).to receive(:update).with(coords)
  149:       game.send(:human_player_turn)
  150      end

  165        expect(board).to receive(:update_active_piece).with(coords)
  166:       game.send(:computer_player_turn)
  167      end

  176        expect(board).to receive(:update).with(coords)
  177:       game.send(:computer_player_turn)
  178      end

  192        expect(board).to receive(:update_active_piece).with(coords)
  193:       game.send(:select_piece_coordinates)
  194      end

  204          allow(game).to receive(:gets).and_return(input)
  205:         result = game.send(:select_game_mode)
  206          expect(result).to eq('1')

  216          allow(game).to receive(:gets).and_return(invalid_input, valid_input)
  217:         game.send(:select_game_mode)
  218        end

  225          allow(game).to receive(:gets).and_return(invalid_input, valid_input)
  226:         result = game.send(:select_game_mode)
  227          expect(result).to eq('1')

  237        it 'does not raise an error' do
  238:         expect { game.send(:validate_move_input, 'c7') }.not_to raise_error
  239        end

  243        it 'raises an error' do
  244:         expect { game.send(:validate_move_input, '7c') }.to raise_error(Game::InputError)
  245        end

  247        it 'raises an error' do
  248:         expect { game.send(:validate_move_input, '77') }.to raise_error(Game::InputError)
  249        end

  251        it 'raises an error' do
  252:         expect { game.send(:validate_move_input, 'cc') }.to raise_error(Game::InputError)
  253        end

  265          coords = { row: 1, column: 0 }
  266:         expect { game.send(:validate_piece_coordinates, coords) }.not_to raise_error
  267        end

  273          coords = { row: 1, column: 0 }
  274:         expect { game.send(:validate_piece_coordinates, coords) }.to raise_error(Game::CoordinatesError)
  275        end

  287          coords = { row: 1, column: 0 }
  288:         expect { game.send(:validate_move, coords) }.not_to raise_error
  289        end

  295          coords = { row: 1, column: 0 }
  296:         expect { game.send(:validate_move, coords) }.to raise_error(Game::MoveError)
  297        end

  308          allow(board).to receive(:active_piece_moveable?).and_return(true)
  309:         expect { game.send(:validate_active_piece) }.not_to raise_error
  310        end

  315          allow(board).to receive(:active_piece_moveable?).and_return(false)
  316:         expect { game.send(:validate_active_piece) }.to raise_error(Game::PieceError)
  317        end

  327        expect_any_instance_of(NotationTranslator).to receive(:translate_notation).with(user_input)
  328:       game.send(:translate_coordinates, user_input)
  329      end

  340          checkmate = "\e[36mBlack\e[0m wins! The white king is in checkmate.\n"
  341:         expect { game.send(:final_message) }.to output(checkmate).to_stdout
  342        end

  352          checkmate = "\e[36mBlack\e[0m wins in a stalemate!\n"
  353:         expect { game.send(:final_message) }.to output(checkmate).to_stdout
  354        end

  364          game.instance_variable_set(:@current_turn, :white)
  365:         game.send(:switch_color)
  366          result = game.instance_variable_get(:@current_turn)

  373          game.instance_variable_set(:@current_turn, :black)
  374:         game.send(:switch_color)
  375          result = game.instance_variable_get(:@current_turn)

  391        expect(board).to receive(:update).with({ row: 1, column: 1 })
  392:       game.send(:human_player_turn)
  393      end

  411        expect(board).to receive(:update_active_piece).with({ row: 0, column: 0 })
  412:       game.send(:computer_player_turn)
  413      end

  416        expect(board).to receive(:update).with({ row: 1, column: 1 })
  417:       game.send(:computer_player_turn)
  418      end

  427        expect(board).to receive(:random_black_piece)
  428:       game.send(:computer_select_random_piece)
  429      end

  438        expect(board).to receive(:random_black_move)
  439:       game.send(:computer_select_random_move)
  440      end

spec/movement/castling_movement_spec.rb:
  93        movement.instance_variable_set(:@column, 6)
  94:       result = movement.send(:find_castling_rook)
  95        expect(result).to eq(black_rook)

spec/movement/pawn_promotion_movement_spec.rb:
   76          allow(board).to receive(:add_observer)
   77:         result = movement.send(:new_promotion_piece)
   78          expect(result).to be_a(Queen)

   98        after do
   99:         movement.send(:new_promotion_piece)
  100        end

  127        user_input = '1'
  128:       movement.send(:create_promotion_piece, user_input)
  129      end

  140          allow(movement).to receive(:gets).and_return(user_input)
  141:         result = movement.send(:select_promotion_piece)
  142          expect(result).to eq('1')

  152          allow(movement).to receive(:gets).and_return(letter_input, user_input)
  153:         movement.send(:select_promotion_piece)
  154        end

  161          allow(movement).to receive(:puts).with(warning).once
  162:         result = movement.send(:select_promotion_piece)
  163          expect(result).to eq('1')

spec/pieces/king_spec.rb:
  200          allow(bpc).to receive(:find_possible_moves).and_return([[1, 4]])
  201:         result = wkg.send(:king_side_castling?, board)
  202          expect(result).to be true

  224          allow(board).to receive(:data).and_return(data)
  225:         result = wkg.send(:king_side_castling?, board)
  226          expect(result).to be false

  249          allow(bpc).to receive(:find_possible_moves).and_return([[7, 5]])
  250:         result = wkg.send(:king_side_castling?, board)
  251          expect(result).to be false

  273          allow(board).to receive(:data).and_return(data)
  274:         result = wkg.send(:king_side_castling?, board)
  275          expect(result).to be false

  297          allow(board).to receive(:data).and_return(data)
  298:         result = wkg.send(:king_side_castling?, board)
  299          expect(result).to be false

  324          allow(wpc).to receive(:find_possible_moves).and_return([[6, 4]])
  325:         result = bkg.send(:queen_side_castling?, board)
  326          expect(result).to be true

  350          allow(wpc).to receive(:find_possible_moves).and_return([])
  351:         result = bkg.send(:queen_side_castling?, board)
  352          expect(result).to be false

  375          allow(wpc).to receive(:find_possible_moves).and_return([[0, 3]])
  376:         result = bkg.send(:queen_side_castling?, board)
  377          expect(result).to be false

  399          allow(board).to receive(:data).and_return(data)
  400:         result = bkg.send(:queen_side_castling?, board)
  401          expect(result).to be false

  423          allow(board).to receive(:data).and_return(data)
  424:         result = bkg.send(:queen_side_castling?, board)
  425          expect(result).to be false

  447          allow(board).to receive(:data).and_return(data)
  448:         result = bkg.send(:queen_side_castling?, board)
  449          expect(result).to be false