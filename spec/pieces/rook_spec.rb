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

  describe '#find_possible_moves' do
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

      it 'has no moves' do
        allow(board).to receive(:data).and_return(data)
        result = white_rook.find_possible_moves(board)
        expect(result).to be_empty
      end
    end

    context 'when 3 decreasing ranks & 3 increasing files are empty' do
      subject(:white_rook) { described_class.new(board, { color: :white, location: [3, 4] }) }
      let(:data) do
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
        allow(board).to receive(:data).and_return(data)
        result = white_rook.find_possible_moves(board)
        expect(result).to contain_exactly([3, 5], [3, 6], [3, 7], [2, 4], [1, 4], [0, 4])
      end
    end

    context 'when 4 increasing ranks & 4 decreasing files are empty' do
      subject(:white_rook) { described_class.new(board, { color: :white, location: [3, 4] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, piece, nil, nil, nil],
          [nil, nil, nil, nil, white_rook, piece, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has eight moves' do
        allow(board).to receive(:data).and_return(data)
        result = white_rook.find_possible_moves(board)
        expect(result).to contain_exactly([3, 0], [3, 1], [3, 2], [3, 3], [4, 4], [5, 4], [6, 4], [7, 4])
      end
    end
  end

  describe '#find_possible_captures' do
    let(:white_piece) { instance_double(Piece, color: :white) }
    let(:black_piece) { instance_double(Piece, color: :black) }

    context 'when there are no opposing pieces' do
      subject(:black_rook) { described_class.new(board, { color: :black, location: [1, 5] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, black_piece, nil, nil],
          [black_piece, nil, nil, nil, nil, black_rook, nil, black_piece],
          [nil, nil, nil, nil, nil, black_piece, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has no captures' do
        allow(board).to receive(:data).and_return(data)
        result = black_rook.find_possible_captures(board)
        expect(result).to be_empty
      end
    end

    context 'when there are 2 opposing pieces up rank & file' do
      subject(:white_rook) { described_class.new(board, { color: :white, location: [3, 3] }) }
      let(:data) do
        [
          [nil, nil, nil, white_piece, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [white_piece, nil, nil, white_rook, nil, nil, nil, black_piece],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, black_piece, nil, nil, nil, nil]
        ]
      end

      it 'has two captures' do
        allow(board).to receive(:data).and_return(data)
        result = white_rook.find_possible_captures(board)
        expect(result).to contain_exactly([3, 7], [7, 3])
      end
    end

    context 'when there are 2 opposing pieces down rank & file' do
      subject(:white_rook) { described_class.new(board, { color: :white, location: [3, 3] }) }
      let(:data) do
        [
          [nil, nil, nil, black_piece, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [black_piece, nil, nil, white_rook, nil, nil, nil, white_piece],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, white_piece, nil, nil, nil, nil]
        ]
      end

      it 'has two captures' do
        allow(board).to receive(:data).and_return(data)
        result = white_rook.find_possible_captures(board)
        expect(result).to contain_exactly([3, 0], [0, 3])
      end
    end
  end
end
