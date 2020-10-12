# frozen_string_literal: true

require_relative '../lib/move_validator'
require_relative '../lib/board'
require_relative '../lib/pieces/piece'

RSpec.describe MoveValidator do
  require 'pry'

  describe '#verify_possible_moves' do
    context 'when a black queens move puts King in check' do
      subject(:validator) { described_class.new([2, 4], board, [[1, 4], [3, 4], [4, 4], [5, 4], [2, 5]]) }
      let(:black_queen) { instance_double(Piece, location: [2, 4], color: :black) }
      let(:black_king) { instance_double(Piece, location: [0, 4], color: :black) }
      let(:white_queen) { instance_double(Piece, location: [6, 4], color: :white) }
      let(:board) { instance_double(Board) }
      let(:data) do
        [
          [nil, nil, nil, nil, black_king, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, black_queen, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, white_queen, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      before do
        allow(board).to receive(:data).and_return(data)
        allow(board).to receive(:black_king).and_return(black_king)
        allow(white_queen).to receive(:format_valid_captures).and_return([[2, 4]], [[2, 4]], [[2, 4]], [[2, 4]], [[2, 4], [0, 4]])
      end

      it 'does not return move that put King in check' do
        results = validator.verify_possible_moves
        expect(results).to contain_exactly([1, 4], [3, 4], [4, 4], [5, 4])
      end
    end

    context 'queen can put king in check' do
      subject(:validator) { described_class.new([2, 4], board, [[1, 4], [3, 4], [4, 4], [5, 4], [2, 3], [2, 5]]) }
      let(:board) { instance_double(Board) }
      let(:black_queen) { instance_double(Piece, { color: :black, location: [2, 4] }) }
      let(:black_king) { instance_double(Piece, color: :black, location: [0, 4]) }
      let(:white_queen) { instance_double(Piece, color: :white, location: [6, 4]) }
      let(:piece) { instance_double(Piece, color: :black) }
      let(:data) do
        [
          [nil, nil, nil, nil, black_king, nil, nil, nil],
          [nil, nil, nil, piece, nil, piece, nil, nil],
          [nil, nil, piece, nil, black_queen, nil, piece, nil],
          [nil, nil, nil, piece, nil, piece, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, white_queen, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      before do
        allow(board).to receive(:data).and_return(data)
        allow(board).to receive(:black_king).and_return(black_king)
        allow(board).to receive(:white_king).and_return(nil)
        allow(white_queen).to receive(:format_valid_captures).and_return([], [], [], [], [[0, 4]], [[0, 4]])
      end

      it 'does not return moves that put King in check' do
        results = validator.verify_possible_moves
        expect(results).to contain_exactly([1, 4], [3, 4], [4, 4], [5, 4])
      end
    end
  end
end
