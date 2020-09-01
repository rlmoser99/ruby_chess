# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/chess_board'
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
  class MoveError < StandardError
    def message
      'Invalid input! Enter column & row that has a chess piece.'
    end
  end
  # subject(:game) { described_class.new }

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

  describe '#validate_coordinates' do
    subject(:game_validate) { described_class.new(board_validate) }
    let(:board_validate) { ChessBoard.new(data_validate) }
    let(:rook) { instance_double(Rook) }
    let(:data_validate) do
      [
        [rook, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil],
        [nil, nil, nil, nil, nil, nil, nil, nil]
      ]
    end

    context 'when board coordinates are not nil' do
      it 'does not raise an error' do
        expect { game_validate.validate_coordinates({ row: 0, column: 0 }) }.not_to raise_error
      end

      it 'returns coordinates' do
        coordinates = { row: 0, column: 0 }
        result = game_validate.validate_coordinates(coordinates)
        expect(result).to eq(coordinates)
      end
    end

    context 'when board coordinates is nil' do
      it 'raises an error' do
        expect { game_validate.validate_coordinates({ row: 1, column: 0 }) }.to raise_error(Game::EmptySquareError)
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

  describe '#validate_move' do
    subject(:game_move) { described_class.new(board_move) }
    let(:board_move) { instance_double(ChessBoard) }
    let(:pawn) { instance_double(Pawn) }

    before do
      allow(board_move).to receive(:active_piece).and_return(pawn)
      allow(pawn).to receive(:moves).and_return([[2, 4]])
    end

    context 'when board coordinates are valid' do
      it 'does not raise an error' do
        expect { game_move.validate_move({ row: 2, column: 4 }) }.not_to raise_error
      end
    end

    context 'when board coordinates are not valid' do
      it 'raises an error' do
        expect { game_move.validate_move({ row: 1, column: 7 }) }.to raise_error(Game::MoveError)
      end
    end
  end
end
