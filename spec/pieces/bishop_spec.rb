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
  end
end
