# frozen_string_literal: true

require_relative '../../lib/pieces/rook'
require_relative '../../lib/pieces/piece'

RSpec.describe Rook do
  describe '#current_moves' do
    context 'when 2 increasing ranks are empty before a piece' do
      subject(:black_rook) { described_class.new({ color: :black, location: [0, 0] }) }
      let(:piece) { instance_double(Piece) }
      let(:board_two) do
        [
          [black_rook, nil, nil, piece, nil, nil, nil, nil],
          [piece, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has two moves' do
        results = black_rook.current_moves(board_two)
        expect(results).to contain_exactly([0, 1], [0, 2])
      end
    end

    context 'when 2 increasing ranks are empty before the end of the board' do
      subject(:black_rook) { described_class.new({ color: :black, location: [0, 5] }) }
      let(:piece) { instance_double(Piece) }
      let(:board_two) do
        [
          [nil, nil, nil, nil, piece, black_rook, nil, nil],
          [nil, nil, nil, nil, nil, piece, nil, nil]
        ]
      end

      it 'has two moves' do
        results = black_rook.current_moves(board_two)
        expect(results).to contain_exactly([0, 6], [0, 7])
      end
    end

    context 'when 2 increasing ranks to piece & 2 decreasing ranks to end are empty' do
      subject(:black_rook) { described_class.new({ color: :black, location: [0, 2] }) }
      let(:piece) { instance_double(Piece) }
      let(:board_four) do
        [
          [nil, nil, black_rook, nil, nil, piece, nil, nil],
          [nil, nil, piece, nil, nil, nil, nil, nil]
        ]
      end

      it 'has four moves' do
        results = black_rook.current_moves(board_four)
        expect(results).to contain_exactly([0, 0], [0, 1], [0, 3], [0, 4])
      end
    end

    context 'when 2 increasing files are empty before a piece' do
      subject(:black_rook) { described_class.new({ color: :black, location: [0, 2] }) }
      let(:piece) { instance_double(Piece) }
      let(:board_two) do
        [
          [nil, piece, black_rook, piece, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, piece, nil, nil, nil, nil, nil]
        ]
      end

      it 'has two moves' do
        results = black_rook.current_moves(board_two)
        expect(results).to contain_exactly([1, 2], [2, 2])
      end
    end

    context 'when 2 decreasing ranks to end & 2 increasing file to end are empty' do
      subject(:black_rook) { described_class.new({ color: :black, location: [5, 2] }) }
      let(:piece) { instance_double(Piece) }
      let(:board_four) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, piece, nil, nil, nil, nil, nil],
          [nil, nil, black_rook, piece, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has four moves' do
        results = black_rook.current_moves(board_four)
        expect(results).to contain_exactly([5, 0], [5, 1], [6, 2], [7, 2])
      end
    end

    context 'when 3 increasing ranks to end & 3 decreasing files to end are empty' do
      subject(:white_rook) { described_class.new({ color: :white, location: [3, 4] }) }
      let(:piece) { instance_double(Piece) }
      let(:board_four) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, piece, white_rook, nil, nil, nil],
          [nil, nil, nil, nil, piece, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has six moves' do
        results = white_rook.current_moves(board_four)
        expect(results).to contain_exactly([3, 5], [3, 6], [3, 7], [2, 4], [1, 4], [0, 4])
      end
    end
  end
end
