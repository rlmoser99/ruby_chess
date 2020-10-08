# frozen_string_literal: true

require_relative '../../lib/pieces/bishop'
require_relative '../../lib/pieces/piece'
require_relative '../../lib/board'

RSpec.describe Bishop do
  let(:board) { instance_double(Board) }

  before do
    allow(board).to receive(:add_observer)
  end

  describe '#current_moves' do
    let(:piece) { instance_double(Piece) }

    context 'when there are 2 spaces up rank/down file' do
      subject(:black_bishop) { described_class.new(board, { color: :black, location: [0, 2] }) }
      let(:black_king) { instance_double(Piece, color: :black, location: [0, 3]) }
      let(:data) do
        [
          [nil, nil, black_bishop, black_king, nil, nil, nil, nil],
          [nil, nil, nil, piece, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      before do
        allow(board).to receive(:data).and_return(data)
        allow(board).to receive(:black_king).and_return(black_king)
        allow(piece).to receive(:color).and_return(:black)
      end

      it 'has two moves' do
        black_bishop.current_moves(board)
        moves = black_bishop.moves
        expect(moves).to contain_exactly([1, 1], [2, 0])
      end
    end

    context 'when there are 2 spaces up rank/up file' do
      subject(:black_bishop) { described_class.new(board, { color: :black, location: [0, 5] }) }
      let(:black_king) { instance_double(Piece, color: :black, location: [0, 0]) }
      let(:data) do
        [
          [black_king, nil, nil, nil, nil, black_bishop, nil, nil],
          [nil, nil, nil, nil, piece, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      before do
        allow(board).to receive(:data).and_return(data)
        allow(board).to receive(:black_king).and_return(black_king)
        allow(piece).to receive(:color).and_return(:black)
      end

      it 'has two moves' do
        black_bishop.current_moves(board)
        moves = black_bishop.moves
        expect(moves).to contain_exactly([1, 6], [2, 7])
      end
    end

    context 'when there are 4 spaces down rank/up file' do
      subject(:black_bishop) { described_class.new(board, { color: :black, location: [5, 3] }) }
      let(:black_king) { instance_double(Piece, color: :black, location: [0, 0]) }
      let(:data) do
        [
          [black_king, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, piece, nil, nil, nil, nil, nil],
          [nil, nil, nil, black_bishop, nil, nil, nil, nil],
          [nil, nil, piece, nil, piece, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      before do
        allow(board).to receive(:data).and_return(data)
        allow(board).to receive(:black_king).and_return(black_king)
        allow(piece).to receive(:color).and_return(:black)
      end

      it 'has four moves' do
        black_bishop.current_moves(board)
        moves = black_bishop.moves
        expect(moves).to contain_exactly([4, 4], [3, 5], [2, 6], [1, 7])
      end
    end

    context 'when there are 3 spaces down rank/down file' do
      subject(:black_bishop) { described_class.new(board, { color: :black, location: [5, 3] }) }
      let(:black_king) { instance_double(Piece, color: :black, location: [0, 0]) }
      let(:data) do
        [
          [black_king, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, piece, nil, nil, nil],
          [nil, nil, nil, black_bishop, nil, nil, nil, nil],
          [nil, nil, piece, nil, piece, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      before do
        allow(board).to receive(:data).and_return(data)
        allow(board).to receive(:black_king).and_return(black_king)
        allow(piece).to receive(:color).and_return(:black)
      end

      it 'has four moves' do
        black_bishop.current_moves(board)
        moves = black_bishop.moves
        expect(moves).to contain_exactly([4, 2], [3, 1], [2, 0])
      end
    end

    context 'when there are 2 spaces in up file' do
      subject(:white_bishop) { described_class.new(board, { color: :white, location: [4, 0] }) }
      let(:white_king) { instance_double(Piece, color: :white, location: [7, 4]) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, piece, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [white_bishop, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, piece, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, white_king, nil, nil, nil]
        ]
      end

      before do
        allow(board).to receive(:data).and_return(data)
        allow(board).to receive(:white_king).and_return(white_king)
        allow(piece).to receive(:color).and_return(:white)
      end

      it 'has two moves' do
        white_bishop.current_moves(board)
        moves = white_bishop.moves
        expect(moves).to contain_exactly([3, 1], [5, 1])
      end
    end

    context 'when there are no spaces to move' do
      subject(:white_bishop) { described_class.new(board, { color: :white, location: [4, 0] }) }
      let(:data) do
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

      before do
        allow(board).to receive(:data).and_return(data)
      end

      it 'has no moves' do
        white_bishop.current_moves(board)
        moves = white_bishop.moves
        expect(moves).to be_empty
      end
    end

    context 'when there are board is completely empty' do
      subject(:white_bishop) { described_class.new(board, { color: :white, location: [3, 3] }) }
      let(:white_king) { instance_double(Piece, color: :white, location: [7, 4]) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, white_bishop, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, white_king, nil, nil, nil]
        ]
      end

      before do
        allow(board).to receive(:data).and_return(data)
        allow(board).to receive(:white_king).and_return(white_king)
        allow(piece).to receive(:color).and_return(:white)
      end

      it 'has thirteen moves' do
        white_bishop.current_moves(board)
        moves = white_bishop.moves
        expect(moves).to contain_exactly([0, 0], [0, 6], [1, 1], [1, 5], [2, 2], [2, 4], [4, 2], [4, 4], [5, 1], [5, 5], [6, 0], [6, 6], [7, 7])
      end
    end
  end

  describe '#current_captures' do
    let(:white_piece) { instance_double(Piece, color: :white) }
    let(:black_piece) { instance_double(Piece, color: :black) }

    context 'when there are 1 opposing piece to capture' do
      subject(:white_bishop) { described_class.new(board, { color: :white, location: [7, 2] }) }
      let(:data) do
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

      it 'has one captures' do
        results = white_bishop.current_captures(data, black_piece)
        expect(results).to contain_exactly([5, 0])
      end
    end

    context 'when there are 2 opposing piece to capture' do
      subject(:white_bishop) { described_class.new(board, { color: :white, location: [3, 3] }) }
      let(:data) do
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

      it 'has two captures' do
        results = white_bishop.current_captures(data, black_piece)
        expect(results).to contain_exactly([0, 6], [6, 0])
      end
    end

    context 'when there are no opposing piece to capture' do
      subject(:white_bishop) { described_class.new(board, { color: :white, location: [3, 3] }) }
      let(:data) do
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
        results = white_bishop.current_captures(data, black_piece)
        expect(results).to be_empty
      end
    end
  end
end
