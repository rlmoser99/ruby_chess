# frozen_string_literal: true

require_relative '../lib/move_validator'
require_relative '../lib/board'
require_relative '../lib/pieces/piece'
require_relative '../lib/pieces/king'
require_relative '../lib/pieces/rook'

RSpec.describe MoveValidator do
  describe '#verify_possible_moves' do
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

      it 'does not return moves that put King in check' do
        allow(board).to receive(:data).and_return(data)
        allow(board).to receive(:black_king).and_return(black_king)
        allow(black_queen).to receive(:symbol).and_return(" \u265B ")
        allow(validator).to receive(:safe_king?).and_return(true, true, true, true, false, false)
        results = validator.verify_possible_moves
        expect(results).to contain_exactly([1, 4], [3, 4], [4, 4], [5, 4])
      end
    end

    context 'king is in check at start of turn' do
      subject(:validator) { described_class.new([0, 4], board, [[0, 3], [1, 3]]) }
      let(:board) { instance_double(Board) }
      let(:white_rook) { instance_double(Piece, { color: :white, location: [0, 3] }) }
      let(:black_king) { instance_double(Piece, { color: :black, location: [0, 4] }) }
      let(:piece) { instance_double(Piece) }
      let(:data) do
        [
          [nil, nil, nil, white_rook, black_king, piece, nil, nil],
          [nil, nil, nil, nil, piece, piece, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'does only returns move to capture rook' do
        allow(board).to receive(:data).and_return(data)
        allow(validator).to receive(:safe_king?).and_return(true, false)
        allow(board).to receive(:black_king).and_return(black_king)
        allow(piece).to receive(:color).and_return(:black)
        allow(black_king).to receive(:symbol).and_return(" \u265A ")
        results = validator.verify_possible_moves
        expect(results).to contain_exactly([0, 3])
      end
    end
  end
end
