# frozen_string_literal: true

require_relative '../../lib/pieces/rook'
require_relative '../../lib/pieces/piece'
require_relative '../../lib/board'

RSpec.describe Rook do
  let(:piece) { instance_double(Piece) }
  let(:board) { instance_double(Board) }

  before do
    allow(board).to receive(:add_observer)
  end

  describe '#format_valid_moves' do
    context 'when 2 increasing ranks are empty before a piece' do
      subject(:black_rook) { described_class.new(board, { color: :black, location: [0, 0] }) }
      let(:black_king) { instance_double(Piece, color: :black, location: [0, 7]) }
      let(:data) do
        [
          [black_rook, nil, nil, piece, nil, nil, nil, black_king],
          [piece, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      before do
        allow(board).to receive(:data).and_return(data)
        allow(piece).to receive(:color).and_return(:black)
      end

      it 'has two moves' do
        result = black_rook.format_valid_moves(board)
        expect(result).to contain_exactly([0, 1], [0, 2])
      end
    end

    context 'when 2 increasing ranks are empty before the end of the data' do
      subject(:black_rook) { described_class.new(board, { color: :black, location: [0, 5] }) }
      let(:black_king) { instance_double(Piece, color: :black, location: [0, 0]) }
      let(:data) do
        [
          [black_king, nil, nil, nil, piece, black_rook, nil, nil],
          [nil, nil, nil, nil, nil, piece, nil, nil]
        ]
      end

      before do
        allow(board).to receive(:data).and_return(data)
        allow(piece).to receive(:color).and_return(:black)
      end

      it 'has two moves' do
        result = black_rook.format_valid_moves(board)
        expect(result).to contain_exactly([0, 6], [0, 7])
      end
    end

    context 'when 2 increasing ranks to piece & 2 decreasing ranks to end are empty' do
      subject(:black_rook) { described_class.new(board, { color: :black, location: [0, 2] }) }
      let(:black_king) { instance_double(Piece, color: :black, location: [0, 7]) }
      let(:data) do
        [
          [nil, nil, black_rook, nil, nil, piece, nil, black_king],
          [nil, nil, piece, nil, nil, nil, nil, nil]
        ]
      end

      before do
        allow(board).to receive(:data).and_return(data)
        allow(piece).to receive(:color).and_return(:black)
      end

      it 'has four moves' do
        result = black_rook.format_valid_moves(board)
        expect(result).to contain_exactly([0, 0], [0, 1], [0, 3], [0, 4])
      end
    end

    context 'when 2 increasing files are empty before a piece' do
      subject(:black_rook) { described_class.new(board, { color: :black, location: [0, 2] }) }
      let(:black_king) { instance_double(Piece, color: :black, location: [0, 7]) }
      let(:data) do
        [
          [nil, piece, black_rook, piece, nil, nil, nil, black_king],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, piece, nil, nil, nil, nil, nil]
        ]
      end

      before do
        allow(board).to receive(:data).and_return(data)
        allow(piece).to receive(:color).and_return(:black)
      end

      it 'has two moves' do
        result = black_rook.format_valid_moves(board)
        expect(result).to contain_exactly([1, 2], [2, 2])
      end
    end

    context 'when 2 decreasing ranks to end & 2 increasing file to end are empty' do
      subject(:black_rook) { described_class.new(board, { color: :black, location: [5, 2] }) }
      let(:black_king) { instance_double(Piece, color: :black, location: [0, 7]) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, black_king],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, piece, nil, nil, nil, nil, nil],
          [nil, nil, black_rook, piece, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      before do
        allow(board).to receive(:data).and_return(data)
        allow(piece).to receive(:color).and_return(:black)
      end

      it 'has four moves' do
        result = black_rook.format_valid_moves(board)
        expect(result).to contain_exactly([5, 0], [5, 1], [6, 2], [7, 2])
      end
    end

    context 'when 3 increasing ranks to end & 3 decreasing files to end are empty' do
      subject(:white_rook) { described_class.new(board, { color: :white, location: [3, 4] }) }
      let(:white_king) { instance_double(Piece, color: :white, location: [7, 4]) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, piece, white_rook, nil, nil, nil],
          [nil, nil, nil, nil, piece, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, white_king, nil, nil, nil]
        ]
      end

      before do
        allow(board).to receive(:data).and_return(data)
        allow(piece).to receive(:color).and_return(:white)
      end

      it 'has six moves' do
        result = white_rook.format_valid_moves(board)
        expect(result).to contain_exactly([3, 5], [3, 6], [3, 7], [2, 4], [1, 4], [0, 4])
      end
    end

    context 'when there are no moves' do
      subject(:white_rook) { described_class.new(board, { color: :white, location: [7, 0] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [piece, nil, nil, nil, nil, nil, nil, nil],
          [white_rook, piece, nil, nil, nil, nil, nil, nil]
        ]
      end

      before do
        allow(board).to receive(:data).and_return(data)
      end

      it 'has no moves' do
        result = white_rook.format_valid_moves(board)
        expect(result).to be_empty
      end
    end
  end

  describe '#format_valid_captures' do
    let(:white_piece) { instance_double(Piece, color: :white) }
    let(:black_piece) { instance_double(Piece, color: :black) }

    context 'when 1 opposing piece is up rank' do
      subject(:black_rook) { described_class.new(board, { color: :black, location: [1, 1] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, black_rook, nil, nil, nil, white_piece, nil, nil],
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
      end

      it 'has one capture' do
        result = black_rook.format_valid_captures(board)
        expect(result).to contain_exactly([1, 5])
      end
    end

    context 'when 1 opposing piece is down rank' do
      subject(:black_rook) { described_class.new(board, { color: :black, location: [1, 5] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, black_piece, nil, nil],
          [white_piece, nil, nil, nil, nil, black_rook, nil, nil],
          [nil, nil, nil, nil, nil, black_piece, nil, nil]
        ]
      end

      before do
        allow(board).to receive(:data).and_return(data)
      end

      it 'has one capture' do
        result = black_rook.format_valid_captures(board)
        expect(result).to contain_exactly([1, 0])
      end
    end

    context 'when 0 opposing pieces' do
      subject(:black_rook) { described_class.new(board, { color: :black, location: [1, 5] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, black_piece, nil, nil],
          [black_piece, nil, nil, nil, nil, black_rook, nil, black_piece],
          [nil, nil, nil, nil, nil, black_piece, nil, nil]
        ]
      end

      before do
        allow(board).to receive(:data).and_return(data)
      end

      it 'has no captures' do
        result = black_rook.format_valid_captures(board)
        expect(result).to be_empty
      end
    end

    context 'when 1 opposing piece is up file and ignores piece down file' do
      subject(:white_rook) { described_class.new(board, { color: :white, location: [4, 7] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, black_piece],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, white_piece],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, white_piece, nil, nil, white_rook],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, black_piece]
        ]
      end

      before do
        allow(board).to receive(:data).and_return(data)
      end

      it 'has 1 captures' do
        result = white_rook.format_valid_captures(board)
        expect(result).to contain_exactly([7, 7])
      end
    end

    context 'when 1 opposing piece is down file' do
      subject(:white_rook) { described_class.new(board, { color: :white, location: [5, 2] }) }
      let(:data) do
        [
          [nil, nil, black_piece, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, white_rook, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      before do
        allow(board).to receive(:data).and_return(data)
      end

      it 'has 1 captures' do
        result = white_rook.format_valid_captures(board)
        expect(result).to contain_exactly([0, 2])
      end
    end

    context 'when 1 opposing piece is up file and 1 opposing piece is down rank' do
      subject(:white_rook) { described_class.new(board, { color: :white, location: [3, 3] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, black_piece, nil, white_rook, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, black_piece, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      before do
        allow(board).to receive(:data).and_return(data)
      end

      it 'has 2 captures' do
        result = white_rook.format_valid_captures(board)
        expect(result).to contain_exactly([3, 1], [6, 3])
      end
    end

    context 'when 1 opposing piece is down file and ignores piece down rank' do
      subject(:white_rook) { described_class.new(board, { color: :white, location: [4, 4] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, black_piece, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [black_piece, nil, white_piece, nil, white_rook, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      before do
        allow(board).to receive(:data).and_return(data)
      end

      it 'has 1 captures' do
        result = white_rook.format_valid_captures(board)
        expect(result).to contain_exactly([1, 4])
      end
    end
  end
end
