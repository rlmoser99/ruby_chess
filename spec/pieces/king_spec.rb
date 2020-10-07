# frozen_string_literal: true

require_relative '../../lib/pieces/king'
require_relative '../../lib/pieces/piece'
require_relative '../../lib/board'

RSpec.describe King do
  let(:board) { instance_double(Board) }

  before do
    allow(board).to receive(:add_observer)
  end

  describe '#current_moves' do
    let(:piece) { instance_double(Piece) }

    context 'when the king is surrounded by pieces' do
      subject(:black_king) { described_class.new(board, { color: :black, location: [0, 4] }) }
      let(:data) do
        [
          [nil, nil, nil, piece, black_king, piece, nil, nil],
          [nil, nil, nil, piece, piece, piece, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has no moves' do
        results = black_king.current_moves(data)
        expect(results).to be_empty
      end
    end

    context 'when the king has two open squares' do
      subject(:black_king) { described_class.new(board, { color: :black, location: [0, 4] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, black_king, piece, nil, nil],
          [nil, nil, nil, piece, piece, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has two moves' do
        results = black_king.current_moves(data)
        expect(results).to contain_exactly([0, 3], [1, 5])
      end
    end

    context 'when the king is on the edge of an empty data' do
      subject(:black_king) { described_class.new(board, { color: :black, location: [3, 7] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, black_king],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has five moves' do
        results = black_king.current_moves(data)
        expect(results).to contain_exactly([2, 7], [2, 6], [3, 6], [4, 6], [4, 7])
      end
    end
  end

  describe '#current_captures' do
    let(:black_piece) { instance_double(Piece) }
    let(:white_piece) { instance_double(Piece) }

    before do
      allow(black_piece).to receive(:color).and_return(:black)
      allow(white_piece).to receive(:color).and_return(:white)
    end

    context 'when the king is surrounded by same-colored pieces' do
      subject(:white_king) { described_class.new(board, { color: :white, location: [7, 4] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, white_piece, white_piece, white_piece, nil, nil],
          [nil, nil, nil, white_piece, white_king, white_piece, nil, nil]
        ]
      end

      it 'has no captures' do
        results = white_king.current_captures(data, black_piece)
        expect(results).to be_empty
      end
    end

    context 'when the king is adjacent to one opposing pieces' do
      subject(:white_king) { described_class.new(board, { color: :white, location: [7, 4] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, black_piece, white_piece, nil, nil, nil],
          [nil, nil, nil, nil, white_king, white_piece, nil, nil]
        ]
      end

      it 'has one capture' do
        results = white_king.current_captures(data, black_piece)
        expect(results).to contain_exactly([6, 3])
      end
    end

    context 'when the king is adjacent to two opposing pieces' do
      subject(:white_king) { described_class.new(board, { color: :white, location: [4, 2] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, white_piece, nil, nil, nil, nil, nil],
          [nil, nil, white_king, black_piece, nil, nil, nil, nil],
          [nil, black_piece, nil, white_piece, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has two captures' do
        results = white_king.current_captures(data, black_piece)
        expect(results).to contain_exactly([4, 3], [5, 1])
      end
    end
  end
end
