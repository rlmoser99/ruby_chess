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
    subject(:game_input) { described_class.new }

    context 'when input is valid' do
      it 'does not raise an error' do
        expect { game_input.validate_input('c7') }.not_to raise_error
      end
    end

    context 'when input is not valid' do
      it 'raises an error' do
        expect { game_input.validate_input('7c') }.to raise_error(Game::InputError)
      end

      it 'raises an error' do
        expect { game_input.validate_input('77') }.to raise_error(Game::InputError)
      end

      it 'raises an error' do
        expect { game_input.validate_input('cc') }.to raise_error(Game::InputError)
      end
    end
  end

  describe '#validate_piece_coordinates' do
    subject(:game_coords) { described_class.new(board_coords) }
    let(:board_coords) { instance_double(Board) }

    context 'when board.piece? returns true' do
      before do
        allow(board_coords).to receive(:piece?).and_return(true)
      end

      it 'does not raise an error' do
        coords = { row: 1, column: 0 }
        expect { game_coords.validate_piece_coordinates(coords) }.not_to raise_error
      end
    end

    context 'when board.piece? returns false' do
      before do
        allow(board_coords).to receive(:piece?).and_return(false)
      end

      it 'raises an error' do
        coords = { row: 1, column: 0 }
        expect { game_coords.validate_piece_coordinates(coords) }.to raise_error(Game::CoordinatesError)
      end
    end
  end

  describe '#validate_move' do
    subject(:game_move) { described_class.new(board_move) }
    let(:board_move) { instance_double(Board) }

    context 'when board.valid_piece_movement? returns true' do
      before do
        allow(board_move).to receive(:valid_piece_movement?).and_return(true)
      end

      it 'does not raise an error' do
        coords = { row: 1, column: 0 }
        expect { game_move.validate_move(coords) }.not_to raise_error
      end
    end

    context 'when board.valid_piece_movement? returns false' do
      before do
        allow(board_move).to receive(:valid_piece_movement?).and_return(false)
      end

      it 'raises an error' do
        coords = { row: 1, column: 0 }
        expect { game_move.validate_move(coords) }.to raise_error(Game::MoveError)
      end
    end
  end

  describe '#validate_active_piece' do
    subject(:game_piece) { described_class.new(board_piece) }
    let(:board_piece) { instance_double(Board) }

    context 'when board.valid_piece_movement? returns true' do
      before do
        allow(board_piece).to receive(:active_piece_moveable?).and_return(true)
      end

      it 'does not raise an error' do
        expect { game_piece.validate_active_piece }.not_to raise_error
      end
    end

    context 'when board.valid_piece_movement? returns false' do
      before do
        allow(board_piece).to receive(:active_piece_moveable?).and_return(false)
      end

      it 'raises an error' do
        expect { game_piece.validate_active_piece }.to raise_error(Game::PieceError)
      end
    end
  end

  describe '#translate_coordinates' do
    subject(:game_translate) { described_class.new }

    it 'sends command message to NotationTranslator' do
      user_input = 'd2'
      expect_any_instance_of(NotationTranslator).to receive(:translate_notation).with(user_input)
      game_translate.translate_coordinates(user_input)
    end
  end
end
