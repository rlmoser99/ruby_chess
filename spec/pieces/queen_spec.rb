# frozen_string_literal: true

require_relative '../../lib/pieces/queen'
require_relative '../../lib/pieces/piece'

RSpec.describe Queen do
  describe '#current_moves' do
    context 'queen is surrounded by pieces' do
      subject(:black_queen) { described_class.new({ color: :black, location: [0, 3] }) }
      let(:piece) { instance_double(Piece) }
      let(:board) do
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
        results = black_queen.current_moves(board)
        expect(results).to be_empty
      end
    end

    context 'queen can only move up rank' do
      subject(:black_queen) { described_class.new({ color: :black, location: [0, 3] }) }
      let(:piece) { instance_double(Piece) }
      let(:board) do
        [
          [nil, nil, piece, black_queen, piece, nil, nil, nil],
          [nil, nil, piece, nil, piece, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has seven moves' do
        results = black_queen.current_moves(board)
        expect(results).to contain_exactly([1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3], [7, 3])
      end
    end

    context 'queen can only move diagonally' do
      subject(:black_queen) { described_class.new({ color: :black, location: [0, 3] }) }
      let(:piece) { instance_double(Piece) }
      let(:board) do
        [
          [nil, nil, piece, black_queen, piece, nil, nil, nil],
          [nil, nil, nil, piece, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has seven moves' do
        results = black_queen.current_moves(board)
        expect(results).to contain_exactly([1, 2], [1, 4], [2, 1], [2, 5], [3, 0], [3, 6], [4, 7])
      end
    end

    context 'queen can move any direction' do
      subject(:black_queen) { described_class.new({ color: :black, location: [3, 3] }) }
      let(:piece) { instance_double(Piece) }
      let(:board) do
        [
          [nil, nil, nil, piece, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, black_queen, nil, nil, nil, piece],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has 25 moves' do
        results = black_queen.current_moves(board)
        expect(results).to contain_exactly([3, 0], [3, 1], [3, 2], [3, 4], [3, 5], [3, 6], [1, 3], [2, 3], [4, 3], [5, 3], [6, 3], [7, 3], [2, 2], [2, 4], [1, 1], [1, 5], [0, 0], [0, 6], [4, 2], [4, 4], [5, 1], [5, 5], [6, 0], [6, 6], [7, 7])
      end
    end
  end

  describe '#current_captures' do
    context 'when there are no opposing pieces' do
      subject(:white_queen) { described_class.new({ color: :white, location: [7, 3] }) }
      let(:white_piece) { instance_double(Piece) }
      let(:board) do
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

      before do
        allow(white_piece).to receive(:color).and_return(:white)
      end

      it 'has no captures' do
        results = white_queen.current_captures(board)
        expect(results).to be_empty
      end
    end

    context 'when there is one opposing pieces down rank' do
      subject(:white_queen) { described_class.new({ color: :white, location: [7, 3] }) }
      let(:black_piece) { instance_double(Piece) }
      let(:white_piece) { instance_double(Piece) }
      let(:board) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, black_piece, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, white_piece, white_queen, white_piece, nil, nil, nil]
        ]
      end

      before do
        allow(black_piece).to receive(:color).and_return(:black)
        allow(white_piece).to receive(:color).and_return(:white)
      end

      it 'has one capture' do
        results = white_queen.current_captures(board)
        expect(results).to contain_exactly([1, 3])
      end
    end

    context 'when there is one opposing pieces diagonally' do
      subject(:white_queen) { described_class.new({ color: :white, location: [6, 1] }) }
      let(:black_piece) { instance_double(Piece) }
      let(:white_piece) { instance_double(Piece) }
      let(:board) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, black_piece, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, white_piece, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, white_queen, nil, nil, nil, nil, nil, white_piece],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      before do
        allow(black_piece).to receive(:color).and_return(:black)
        allow(white_piece).to receive(:color).and_return(:white)
      end

      it 'has one capture' do
        results = white_queen.current_captures(board)
        expect(results).to contain_exactly([2, 5])
      end
    end

    context 'when there is four opposing pieces' do
      subject(:white_queen) { described_class.new({ color: :white, location: [4, 3] }) }
      let(:black_piece) { instance_double(Piece) }
      let(:white_piece) { instance_double(Piece) }
      let(:board) do
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

      before do
        allow(black_piece).to receive(:color).and_return(:black)
        allow(white_piece).to receive(:color).and_return(:white)
      end

      it 'has four captures' do
        results = white_queen.current_captures(board)
        expect(results).to contain_exactly([0, 7], [1, 3], [4, 7], [6, 5])
      end
    end
  end
end
