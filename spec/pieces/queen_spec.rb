# frozen_string_literal: true

require_relative '../../lib/pieces/queen'
require_relative '../../lib/pieces/king'
require_relative '../../lib/pieces/piece'
require_relative '../../lib/board'

RSpec.describe Queen do
  let(:board) { instance_double(Board) }

  before do
    allow(board).to receive(:add_observer)
  end

  describe '#find_possible_moves' do
    let(:piece) { instance_double(Piece) }

    context 'queen is surrounded by pieces' do
      subject(:black_queen) { described_class.new(board, { color: :black, location: [0, 3] }) }
      let(:data) do
        [
          [nil, nil, piece, black_queen, piece, nil, nil, nil],
          [nil, nil, piece, piece, piece, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has no moves' do
        allow(board).to receive(:data).and_return(data)
        result = black_queen.find_possible_moves(board)
        expect(result).to be_empty
      end
    end

    context 'queen has 4 moves before running into another piece' do
      subject(:white_queen) { described_class.new(board, { color: :white, location: [5, 3] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, piece, nil, piece, nil, nil],
          [nil, nil, piece, nil, nil, nil, nil, nil],
          [nil, piece, nil, white_queen, piece, nil, nil, nil],
          [nil, nil, piece, piece, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, piece, nil, nil]
        ]
      end

      it 'has four moves' do
        allow(board).to receive(:data).and_return(data)
        result = white_queen.find_possible_moves(board)
        expect(result).to contain_exactly([5, 2], [4, 3], [4, 4], [6, 4])
      end
    end

    context 'queen can move any direction' do
      subject(:black_queen) { described_class.new(board, { color: :black, location: [3, 3] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, black_queen, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has 27 moves' do
        allow(board).to receive(:data).and_return(data)
        result = black_queen.find_possible_moves(board)
        expect(result).to contain_exactly([3, 0], [3, 1], [3, 2], [3, 4], [3, 5], [3, 6], [3, 7], [1, 3], [2, 3], [4, 3], [5, 3], [6, 3], [7, 3], [2, 2], [2, 4], [1, 1], [1, 5], [0, 0], [0, 3], [0, 6], [4, 2], [4, 4], [5, 1], [5, 5], [6, 0], [6, 6], [7, 7])
      end
    end
  end

  describe '#find_possible_captures' do
    let(:white_piece) { instance_double(Piece, color: :white) }
    let(:black_piece) { instance_double(Piece, color: :black) }

    context 'when there are no opposing pieces' do
      subject(:white_queen) { described_class.new(board, { color: :white, location: [7, 3] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, white_piece, white_piece, white_piece, nil, nil, nil],
          [nil, nil, white_piece, white_queen, white_piece, nil, nil, nil]
        ]
      end

      it 'has no captures' do
        allow(board).to receive(:data).and_return(data)
        result = white_queen.find_possible_captures(board)
        expect(result).to be_empty
      end
    end

    context 'when there is 4 opposing pieces and 4 other pieces to ignore' do
      subject(:white_queen) { described_class.new(board, { color: :white, location: [4, 3] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, black_piece],
          [nil, nil, nil, black_piece, nil, nil, nil, nil],
          [nil, white_piece, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [white_piece, nil, nil, white_queen, nil, nil, nil, black_piece],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, white_piece, nil, white_piece, nil, black_piece, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has four captures' do
        allow(board).to receive(:data).and_return(data)
        result = white_queen.find_possible_captures(board)
        expect(result).to contain_exactly([0, 7], [1, 3], [4, 7], [6, 5])
      end
    end
  end
end
