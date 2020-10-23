# frozen_string_literal: true

require_relative '../lib/move_validator'
require_relative '../lib/board'
require_relative '../lib/pieces/piece'
require_relative '../lib/pieces/king'
require_relative '../lib/pieces/rook'

RSpec.describe MoveValidator do
  describe '#verify_possible_moves' do
    context 'when moving queen can put king in check' do
      subject(:validator) { described_class.new([2, 4], board, [[1, 4], [3, 4], [4, 4], [5, 4], [2, 3], [2, 5]]) }
      let(:board) { instance_double(Board, data: data, black_king: bkg, check?: false) }
      let(:bqn) { instance_double(Piece, color: :black, location: [2, 4], symbol: " \u265B ") }
      let(:bkg) { instance_double(Piece, color: :black, location: [0, 4]) }
      let(:bpc) { instance_double(Piece, color: :black) }
      let(:wqn) { instance_double(Piece, color: :white, location: [6, 4]) }
      let(:data) do
        [
          [nil, nil, nil, nil, bkg, nil, nil, nil],
          [nil, nil, nil, bpc, nil, bpc, nil, nil],
          [nil, nil, bpc, nil, bqn, nil, bpc, nil],
          [nil, nil, nil, bpc, nil, bpc, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, wqn, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'return moves that will not put King in check' do
        validator.instance_variable_set(:@current_piece, bqn)
        allow(wqn).to receive(:find_possible_captures).and_return([], [], [], [], [[0, 4]], [[0, 4]])
        results = validator.verify_possible_moves
        expect(results).to contain_exactly([1, 4], [3, 4], [4, 4], [5, 4])
      end
    end

    context 'when king is in check at start of turn and only king has valid moves' do
      subject(:validator) { described_class.new([0, 4], board, [[0, 3], [1, 3]]) }
      let(:board) { instance_double(Board, data: data, black_king: bkg) }
      let(:wrk) { instance_double(Piece, color: :white, location: [0, 3]) }
      let(:bkg) { instance_double(Piece, color: :black, location: [0, 4], symbol: " \u265A ") }
      let(:bpc) { instance_double(Piece, color: :black) }
      let(:data) do
        [
          [nil, nil, nil, wrk, bkg, bpc, nil, nil],
          [nil, nil, nil, nil, bpc, bpc, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'returns move for king to capture rook' do
        validator.instance_variable_set(:@current_piece, bkg)
        allow(board).to receive(:check?).and_return(true, false, true)
        results = validator.verify_possible_moves
        expect(results).to contain_exactly([0, 3])
      end
    end

    context 'when king is in check at start of turn and other piece has valid moves' do
      subject(:validator) { described_class.new([0, 6], board, [[0, 5], [4, 6]]) }
      let(:board) { instance_double(Board, data: data, black_king: bkg) }
      let(:brk) { instance_double(Piece, color: :black, location: [0, 6], symbol: " \u265C ") }
      let(:wqn) { instance_double(Piece, color: :white, location: [0, 5]) }
      let(:bkg) { instance_double(Piece, color: :black, location: [0, 4], symbol: " \u265A ") }
      let(:wpn) { instance_double(Piece, color: :white, location: [4, 6]) }
      let(:pic) { instance_double(Piece, color: :black) }
      let(:data) do
        [
          [nil, nil, nil, pic, bkg, wqn, brk, nil],
          [nil, nil, nil, pic, nil, pic, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, wpn, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'returns move for rook to capture white queen' do
        validator.instance_variable_set(:@current_piece, brk)
        allow(board).to receive(:check?).and_return(true, false, true)
        allow(wqn).to receive(:find_possible_captures).and_return([], [[0, 4]])
        allow(wpn).to receive(:find_possible_captures).and_return([], [])
        results = validator.verify_possible_moves
        expect(results).to contain_exactly([0, 5])
      end
    end
  end
end
