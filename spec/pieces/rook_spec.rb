# frozen_string_literal: true

require_relative '../../lib/pieces/rook'
require_relative '../../lib/pieces/piece'

RSpec.describe Rook do
  describe '#current_moves' do
    context 'when 2 increasing rank squares are empty' do
      subject(:black_rook) { described_class.new({ color: :black, location: [0, 0] }) }
      let(:piece) { Piece.new({ color: :white, location: [0, 3] }) }
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

    context 'when 2 increasing rank squares are empty' do
      subject(:black_rook) { described_class.new({ color: :black, location: [0, 5] }) }
      let(:piece) { Piece.new({ color: :white, location: [0, 4] }) }
      let(:board_two) do
        [
          [nil, nil, nil, nil, piece, black_rook, nil, nil],
          [piece, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has two moves' do
        results = black_rook.current_moves(board_two)
        expect(results).to contain_exactly([0, 6], [0, 7])
      end
    end

    context 'when 4 increasing & decreasing rank squares are empty' do
      subject(:black_rook) { described_class.new({ color: :black, location: [0, 2] }) }
      let(:piece) { Piece.new({ color: :white, location: [0, 5] }) }
      let(:board_four) do
        [
          [nil, nil, black_rook, nil, nil, piece, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has four moves' do
        results = black_rook.current_moves(board_four)
        expect(results).to contain_exactly([0, 0], [0, 1], [0, 3], [0, 4])
      end
    end
  end
end
