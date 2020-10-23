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
        allow(board).to receive(:check?).and_return(true)
        checkmate = "\e[36mBlack\e[0m wins! The white king is in checkmate.\n"
        expect { game.send(:final_message) }.to output(checkmate).to_stdout
      end
    end

    context 'when game does not have a king in check' do
      subject(:game) { described_class.new(board) }
      let(:board) { instance_double(Board) }

      it 'outputs stalemate message' do
        allow(board).to receive(:check?).and_return(false)
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

  describe '#update_game_board_mode' do
    subject(:game) { described_class.new(board) }
    subject(:board) { instance_double(Board) }

    it 'changes mode to :computer' do
      allow(board).to receive(:update_game_mode)
      game.send(:update_game_board_mode)
      result = game.instance_variable_get(:@mode)
      expect(result).to eq(:computer)
    end

    it 'sends update_game_mode to board' do
      expect(board).to receive(:update_game_mode)
      game.send(:update_game_board_mode)
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
