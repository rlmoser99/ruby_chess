# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/notation_translator'
require_relative '../lib/pieces/rook'
require_relative '../lib/pieces/pawn'

RSpec.describe Game do
  # Declares error message when user enters invalid input
  class InputError < StandardError
    def message
      'Invalid input! Enter column & row, for example: d2'
    end
  end

  # Declares error message when user enters invalid move
  class CoordinatesError < StandardError
    def message
      'Invalid coordinates! Enter column & row that has a chess piece.'
    end
  end

  # Declares error message when user enters invalid move
  class MoveError < StandardError
    def message
      'Invalid coordinates! Enter a valid column & row to move.'
    end
  end

  # Declares error message when user enters invalid move
  class PieceError < StandardError
    def message
      'Invalid piece! This piece can not move. Please enter a different column & row.'
    end
  end

  describe '#play' do
    context 'when user input is 1' do
      subject(:game) { described_class.new(board) }
      let(:board) { instance_double(Board) }

      it 'calls update_game_board_mode' do
        allow(game).to receive(:select_game_mode).and_return('1')
        allow(board).to receive(:initial_placement)
        allow(board).to receive(:to_s)
        allow(game).to receive(:player_turn)
        allow(board).to receive(:game_over?).and_return(true)
        allow(game).to receive(:final_message)
        expect(board).to receive(:update_mode)
        game.play
      end
    end

    context 'when user input is not 1' do
      subject(:game) { described_class.new(board) }
      let(:board) { instance_double(Board) }

      it 'does not call update_game_board_mode' do
        allow(game).to receive(:select_game_mode).and_return('2')
        allow(board).to receive(:initial_placement)
        allow(board).to receive(:to_s)
        allow(game).to receive(:player_turn)
        allow(board).to receive(:game_over?).and_return(true)
        allow(game).to receive(:final_message)
        expect(board).not_to receive(:update_mode)
        game.play
      end
    end

    context 'when game_over? is false four times' do
      subject(:game) { described_class.new(board) }
      let(:board) { instance_double(Board) }

      it 'calls #player_turn four times' do
        allow(game).to receive(:select_game_mode).and_return('2')
        allow(board).to receive(:initial_placement)
        allow(board).to receive(:to_s)
        allow(board).to receive(:game_over?).and_return(false, false, false, false, true)
        allow(game).to receive(:final_message)
        expect(game).to receive(:player_turn).exactly(4).times
        game.play
      end
    end
  end

  describe '#player_turn' do
    context 'when board mode is not :computer' do
      subject(:game) { described_class.new(board) }
      let(:board) { instance_double(Board, mode: :user_prompts) }

      it 'calls #human_player_turn' do
        allow(game).to receive(:puts)
        game.instance_variable_set(:@current_turn, :black)
        allow(board).to receive(:to_s)
        allow(game).to receive(:switch_color)
        expect(game).to receive(:human_player_turn)
        game.send(:player_turn)
      end
    end

    context 'when board mode is :computer and @current_turn is :white' do
      subject(:game) { described_class.new(board) }
      let(:board) { instance_double(Board, mode: :computer) }

      it 'calls #human_player_turn' do
        allow(game).to receive(:puts)
        game.instance_variable_set(:@current_turn, :white)
        allow(board).to receive(:to_s)
        allow(game).to receive(:switch_color)
        expect(game).to receive(:human_player_turn)
        game.send(:player_turn)
      end
    end

    context 'when board mode is :computer and @current_turn is :black' do
      subject(:game) { described_class.new(board) }
      let(:board) { instance_double(Board, mode: :computer) }

      it 'calls #computer_player_turn' do
        allow(game).to receive(:puts)
        game.instance_variable_set(:@current_turn, :black)
        allow(board).to receive(:to_s)
        allow(game).to receive(:switch_color)
        expect(game).to receive(:computer_player_turn)
        game.send(:player_turn)
      end
    end
  end

  describe '#human_player_turn' do
    subject(:game) { described_class.new(board) }
    let(:board) { instance_double(Board, mode: :user_prompts) }

    it 'sends #update to board' do
      allow(game).to receive(:select_piece_coordinates)
      allow(board).to receive(:to_s)
      coords = { row: 6, column: 5 }
      allow(game).to receive(:select_move_coordinates).and_return(coords)
      expect(board).to receive(:update).with(coords)
      game.send(:human_player_turn)
    end
  end

  describe '#computer_player_turn' do
    subject(:game) { described_class.new(board) }
    let(:board) { instance_double(Board, mode: :user_prompts) }

    it 'sends #update_active_piece to board' do
      allow(game).to receive(:sleep)
      allow(board).to receive(:to_s)
      allow(game).to receive(:computer_select_random_move)
      allow(board).to receive(:update)
      coords = { row: 6, column: 5 }
      allow(game).to receive(:computer_select_random_piece).and_return(coords)
      expect(board).to receive(:update_active_piece).with(coords)
      game.send(:computer_player_turn)
    end

    it 'sends #update to board' do
      allow(game).to receive(:sleep)
      allow(game).to receive(:computer_select_random_piece)
      allow(board).to receive(:update_active_piece)
      allow(board).to receive(:to_s)
      coords = { row: 6, column: 5 }
      allow(game).to receive(:computer_select_random_move).and_return(coords)
      expect(board).to receive(:update).with(coords)
      game.send(:computer_player_turn)
    end
  end

  describe '#select_piece_coordinates' do
    subject(:game) { described_class.new(board) }
    let(:board) { instance_double(Board) }

    it 'sends #update_active_piece to board' do
      allow(game).to receive(:user_select_piece)
      coords = { row: 6, column: 5 }
      allow(game).to receive(:translate_coordinates).and_return(coords)
      allow(game).to receive(:validate_piece_coordinates).with(coords)
      allow(game).to receive(:validate_active_piece)
      expect(board).to receive(:update_active_piece).with(coords)
      game.send(:select_piece_coordinates)
    end
  end

  describe '#select_game_mode' do
    subject(:game) { described_class.new }

    context 'when user input is valid' do
      it 'returns valid user input' do
        input = '1'
        allow(game).to receive(:user_input).and_return(input)
        result = game.send(:select_game_mode)
        expect(result).to eq('1')
      end
    end

    context 'when user input is not valid' do
      it 'outputs an input error warning' do
        warning = 'Input error! Enter 1-digit (1 or 2).'
        expect(game).to receive(:puts).with(warning).once
        valid_input = '1'
        invalid_input = 'a'
        allow(game).to receive(:user_input).and_return(invalid_input, valid_input)
        game.send(:select_game_mode)
      end

      it 'returns second valid user input' do
        warning = 'Input error! Enter 1-digit (1 or 2).'
        expect(game).to receive(:puts).with(warning).once
        valid_input = '1'
        invalid_input = 'a'
        allow(game).to receive(:user_input).and_return(invalid_input, valid_input)
        result = game.send(:select_game_mode)
        expect(result).to eq('1')
      end
    end
  end

  describe '#validate_input' do
    subject(:game) { described_class.new }

    context 'when input is valid' do
      it 'does not raise an error' do
        expect { game.send(:validate_input, 'c7') }.not_to raise_error
      end
    end

    context 'when input is not valid' do
      it 'raises an error' do
        expect { game.send(:validate_input, '7c') }.to raise_error(Game::InputError)
      end

      it 'raises an error' do
        expect { game.send(:validate_input, '77') }.to raise_error(Game::InputError)
      end

      it 'raises an error' do
        expect { game.send(:validate_input, 'cc') }.to raise_error(Game::InputError)
      end
    end
  end

  describe '#validate_piece_coordinates' do
    subject(:game) { described_class.new(board) }
    let(:board) { instance_double(Board) }

    context 'when board coordinates contains a piece' do
      it 'does not raise an error' do
        allow(board).to receive(:valid_piece?).and_return(true)
        coords = { row: 1, column: 0 }
        expect { game.send(:validate_piece_coordinates, coords) }.not_to raise_error
      end
    end

    context 'when board coordinates do not contain a piece' do
      it 'raises an error' do
        allow(board).to receive(:valid_piece?).and_return(false)
        coords = { row: 1, column: 0 }
        expect { game.send(:validate_piece_coordinates, coords) }.to raise_error(Game::CoordinatesError)
      end
    end
  end

  describe '#validate_move' do
    subject(:game) { described_class.new(board) }
    let(:board) { instance_double(Board) }

    context 'when coordinates is a valid piece movement' do
      it 'does not raise an error' do
        allow(board).to receive(:valid_piece_movement?).and_return(true)
        coords = { row: 1, column: 0 }
        expect { game.send(:validate_move, coords) }.not_to raise_error
      end
    end

    context 'when coordinates is not a valid piece movement' do
      it 'raises an error' do
        allow(board).to receive(:valid_piece_movement?).and_return(false)
        coords = { row: 1, column: 0 }
        expect { game.send(:validate_move, coords) }.to raise_error(Game::MoveError)
      end
    end
  end

  describe '#validate_active_piece' do
    subject(:game) { described_class.new(board) }
    let(:board) { instance_double(Board) }

    context 'when active piece is moveable' do
      it 'does not raise an error' do
        allow(board).to receive(:active_piece_moveable?).and_return(true)
        expect { game.send(:validate_active_piece) }.not_to raise_error
      end
    end

    context 'when active piece is not moveable' do
      it 'raises an error' do
        allow(board).to receive(:active_piece_moveable?).and_return(false)
        expect { game.send(:validate_active_piece) }.to raise_error(Game::PieceError)
      end
    end
  end

  describe '#translate_coordinates' do
    subject(:game) { described_class.new }

    it 'sends command message to NotationTranslator' do
      user_input = 'd2'
      expect_any_instance_of(NotationTranslator).to receive(:translate_notation).with(user_input)
      game.send(:translate_coordinates, user_input)
    end
  end

  describe '#final_message' do
    context 'when game has a king in check' do
      subject(:game) { described_class.new(board) }
      let(:board) { instance_double(Board) }

      it 'outputs checkmate message' do
        allow(board).to receive(:king_in_check?).and_return(true)
        checkmate = "\e[36mBlack\e[0m wins! The white king is in checkmate.\n"
        expect { game.send(:final_message) }.to output(checkmate).to_stdout
      end
    end

    context 'when game does not have a king in check' do
      subject(:game) { described_class.new(board) }
      let(:board) { instance_double(Board) }

      it 'outputs stalemate message' do
        allow(board).to receive(:king_in_check?).and_return(false)
        checkmate = "\e[36mBlack\e[0m wins in a stalemate!\n"
        expect { game.send(:final_message) }.to output(checkmate).to_stdout
      end
    end
  end

  describe '#switch_color' do
    subject(:game) { described_class.new }

    context 'when current_turn is :white' do
      it 'changes to :black' do
        game.instance_variable_set(:@current_turn, :white)
        game.send(:switch_color)
        result = game.instance_variable_get(:@current_turn)
        expect(result).to eq(:black)
      end
    end

    context 'when current_turn is :black' do
      it 'changes to :white' do
        game.instance_variable_set(:@current_turn, :black)
        game.send(:switch_color)
        result = game.instance_variable_get(:@current_turn)
        expect(result).to eq(:white)
      end
    end
  end

  describe '#human_player_turn' do
    subject(:game) { described_class.new(board) }
    let(:board) { instance_double(Board) }

    it 'send update to board' do
      allow(game).to receive(:select_piece_coordinates)
      allow(board).to receive(:to_s)
      allow(game).to receive(:select_move_coordinates).and_return({ row: 1, column: 1 })
      allow(board).to receive(:update)
      expect(board).to receive(:update).with({ row: 1, column: 1 })
      game.send(:human_player_turn)
    end
  end

  describe '#computer_player_turn' do
    subject(:game) { described_class.new(board) }
    let(:board) { instance_double(Board) }

    before do
      allow(game).to receive(:computer_select_random_piece).and_return({ row: 0, column: 0 })
      allow(game).to receive(:computer_select_random_move).and_return({ row: 1, column: 1 })
      allow(board).to receive(:update_active_piece)
      allow(board).to receive(:update)
      allow(board).to receive(:to_s)
      allow(game).to receive(:sleep)
    end

    it 'send update_active_piece to board' do
      expect(board).to receive(:update_active_piece).with({ row: 0, column: 0 })
      game.send(:computer_player_turn)
    end

    it 'send update to board' do
      expect(board).to receive(:update).with({ row: 1, column: 1 })
      game.send(:computer_player_turn)
    end
  end

  describe '#computer_select_random_piece' do
    subject(:game) { described_class.new(board) }
    let(:board) { instance_double(Board) }

    it 'send random_black_piece to board' do
      expect(board).to receive(:random_black_piece)
      game.send(:computer_select_random_piece)
    end
  end

  describe '#computer_select_random_move' do
    subject(:game) { described_class.new(board) }
    let(:board) { instance_double(Board) }

    it 'send random_black_move to board' do
      expect(board).to receive(:random_black_move)
      game.send(:computer_select_random_move)
    end
  end
end
