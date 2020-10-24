# frozen_string_literal: true

require_relative '../../lib/pieces/knight'
require_relative '../../lib/pieces/piece'
require_relative '../../lib/board'

RSpec.describe Knight do
  let(:board) { instance_double(Board) }

  before do
    allow(board).to receive(:add_observer)
  end

  describe '#find_possible_moves' do
    let(:pic) { instance_double(Piece) }

    context 'when all moves are blocked' do
      subject(:bnt) { described_class.new(board, { color: :black, location: [3, 3] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, pic, nil, pic, nil, nil, nil],
          [nil, pic, nil, nil, nil, pic, nil, nil],
          [nil, nil, nil, bnt, nil, nil, nil, nil],
          [nil, pic, nil, nil, nil, pic, nil, nil],
          [nil, nil, pic, nil, pic, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has no moves' do
        allow(board).to receive(:data).and_return(data)
        results = bnt.find_possible_moves(board)
        expect(results).to be_empty
      end
    end

    context 'during initial board setup' do
      subject(:bnt) { described_class.new(board, { color: :black, location: [0, 1] }) }
      let(:data) do
        [
          [pic, bnt, pic, pic, pic, pic, pic, pic],
          [pic, pic, pic, pic, pic, pic, pic, pic],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has two moves' do
        allow(board).to receive(:data).and_return(data)
        results = bnt.find_possible_moves(board)
        expect(results).to contain_exactly([2, 0], [2, 2])
      end
    end

    context 'when board is empty' do
      subject(:bnt) { described_class.new(board, { color: :black, location: [3, 3] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, bnt, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has eight moves' do
        allow(board).to receive(:data).and_return(data)
        results = bnt.find_possible_moves(board)
        expect(results).to contain_exactly([1, 2], [1, 4], [2, 1], [2, 5], [4, 1], [4, 5], [5, 2], [5, 4])
      end
    end
  end

  describe '#find_possible_captures' do
    let(:wpc) { instance_double(Piece, color: :white) }
    let(:bpc) { instance_double(Piece, color: :black) }

    context 'when there are no opposing pieces to capture' do
      subject(:bnt) { described_class.new(board, { color: :black, location: [4, 7] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, bpc, nil],
          [nil, nil, nil, nil, nil, bpc, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, bnt],
          [nil, nil, nil, nil, nil, bpc, nil, nil],
          [nil, nil, nil, nil, nil, nil, bpc, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has no captures' do
        allow(board).to receive(:data).and_return(data)
        result = bnt.find_possible_captures(board)
        expect(result).to be_empty
      end
    end

    context 'when there is four opposing pieces and four other pieces' do
      subject(:bnt) { described_class.new(board, { color: :black, location: [3, 3] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, wpc, nil, wpc, nil, nil, nil],
          [nil, bpc, nil, nil, nil, bpc, nil, nil],
          [nil, nil, nil, bnt, nil, nil, nil, nil],
          [nil, bpc, nil, nil, nil, bpc, nil, nil],
          [nil, nil, wpc, nil, wpc, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has four captures' do
        allow(board).to receive(:data).and_return(data)
        result = bnt.find_possible_captures(board)
        expect(result).to contain_exactly([1, 2], [1, 4], [5, 2], [5, 4])
      end
    end

    context 'when there is four opposing pieces and four empty places' do
      subject(:bnt) { described_class.new(board, { color: :black, location: [3, 3] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, wpc, nil, nil, nil, wpc, nil, nil],
          [nil, nil, nil, bnt, nil, nil, nil, nil],
          [nil, wpc, nil, nil, nil, wpc, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has four captures' do
        allow(board).to receive(:data).and_return(data)
        result = bnt.find_possible_captures(board)
        expect(result).to contain_exactly([2, 1], [2, 5], [4, 1], [4, 5])
      end
    end
  end
end
