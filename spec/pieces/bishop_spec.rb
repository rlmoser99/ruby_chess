# frozen_string_literal: true

require_relative '../../lib/pieces/bishop'
require_relative '../../lib/pieces/piece'

RSpec.describe Bishop do
  describe '#current_moves' do
    context 'when there are 2 spaces up rank/down file' do
      subject(:black_bishop) { described_class.new({ color: :black, location: [0, 2] }) }
      let(:piece) { instance_double(Piece) }
      let(:board) do
        [
          [nil, nil, black_bishop, nil, nil, nil, nil, nil],
          [nil, nil, nil, piece, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has two moves' do
        results = black_bishop.current_moves(board)
        expect(results).to contain_exactly([1, 1], [2, 0])
      end
    end

    context 'when there are 2 spaces up rank/up file' do
      subject(:black_bishop) { described_class.new({ color: :black, location: [0, 5] }) }
      let(:piece) { instance_double(Piece) }
      let(:board) do
        [
          [nil, nil, nil, nil, nil, black_bishop, nil, nil],
          [nil, nil, nil, nil, piece, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has two moves' do
        results = black_bishop.current_moves(board)
        expect(results).to contain_exactly([1, 6], [2, 7])
      end
    end

    context 'when there are 4 spaces down rank/up file' do
      subject(:black_bishop) { described_class.new({ color: :black, location: [5, 3] }) }
      let(:piece) { instance_double(Piece) }
      let(:board) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, piece, nil, nil, nil, nil, nil],
          [nil, nil, nil, black_bishop, nil, nil, nil, nil],
          [nil, nil, piece, nil, piece, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has four moves' do
        results = black_bishop.current_moves(board)
        expect(results).to contain_exactly([4, 4], [3, 5], [2, 6], [1, 7])
      end
    end

    context 'when there are 3 spaces down rank/down file' do
      subject(:black_bishop) { described_class.new({ color: :black, location: [5, 3] }) }
      let(:piece) { instance_double(Piece) }
      let(:board) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, piece, nil, nil, nil],
          [nil, nil, nil, black_bishop, nil, nil, nil, nil],
          [nil, nil, piece, nil, piece, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has four moves' do
        results = black_bishop.current_moves(board)
        expect(results).to contain_exactly([4, 2], [3, 1], [2, 0])
      end
    end

    context 'when there are 2 spaces in up file' do
      subject(:white_bishop) { described_class.new({ color: :white, location: [4, 0] }) }
      let(:piece) { instance_double(Piece) }
      let(:board) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, piece, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [white_bishop, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, piece, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has two moves' do
        results = white_bishop.current_moves(board)
        expect(results).to contain_exactly([3, 1], [5, 1])
      end
    end

    context 'when there are no spaces to move' do
      subject(:white_bishop) { described_class.new({ color: :white, location: [4, 0] }) }
      let(:piece) { instance_double(Piece) }
      let(:board) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, piece, nil, nil, nil, nil, nil, nil],
          [white_bishop, nil, nil, nil, nil, nil, nil, nil],
          [nil, piece, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has no moves' do
        results = white_bishop.current_moves(board)
        expect(results).to be_empty
      end
    end

    context 'when there are board is completely empty' do
      subject(:white_bishop) { described_class.new({ color: :white, location: [3, 3] }) }
      let(:piece) { instance_double(Piece) }
      let(:open_board) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, white_bishop, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has thirteen moves' do
        results = white_bishop.current_moves(open_board)
        expect(results).to contain_exactly([0, 0], [0, 6], [1, 1], [1, 5], [2, 2], [2, 4], [4, 2], [4, 4], [5, 1], [5, 5], [6, 0], [6, 6], [7, 7])
      end
    end
  end

  describe '#current_captures' do
    context 'when there are 1 opposing piece to capture' do
      subject(:white_bishop) { described_class.new({ color: :white, location: [7, 2] }) }
      let(:black_piece) { instance_double(Piece) }
      let(:white_piece) { instance_double(Piece) }
      let(:board) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [black_piece, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, white_piece, nil, nil, nil, nil],
          [nil, nil, white_bishop, nil, nil, nil, nil, nil]
        ]
      end

      before do
        allow(black_piece).to receive(:color).and_return(:black)
        allow(white_piece).to receive(:color).and_return(:white)
      end

      it 'has one captures' do
        results = white_bishop.current_captures(board)
        expect(results).to contain_exactly([5, 0])
      end
    end

    context 'when there are 2 opposing piece to capture' do
      subject(:white_bishop) { described_class.new({ color: :white, location: [3, 3] }) }
      let(:black_piece) { instance_double(Piece) }
      let(:white_piece) { instance_double(Piece) }
      let(:board) do
        [
          [white_piece, nil, nil, nil, nil, nil, black_piece, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, white_bishop, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [black_piece, nil, nil, nil, nil, nil, white_piece, nil]
        ]
      end

      before do
        allow(black_piece).to receive(:color).and_return(:black)
        allow(white_piece).to receive(:color).and_return(:white)
      end

      it 'has two captures' do
        results = white_bishop.current_captures(board)
        expect(results).to contain_exactly([0, 6], [6, 0])
      end
    end

    context 'when there are no opposing piece to capture' do
      subject(:white_bishop) { described_class.new({ color: :white, location: [3, 3] }) }
      let(:piece) { instance_double(Piece) }
      let(:open_board) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, white_bishop, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has no moves' do
        results = white_bishop.current_captures(open_board)
        expect(results).to be_empty
      end
    end
  end
end
