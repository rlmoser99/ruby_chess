# frozen_string_literal: true

require_relative '../../lib/pieces/king'
require_relative '../../lib/pieces/piece'
require_relative '../../lib/pieces/rook'
require_relative '../../lib/board'

RSpec.describe King do
  let(:board) { instance_double(Board) }

  before do
    allow(board).to receive(:add_observer)
  end

  describe '#find_possible_moves' do
    let(:pic) { instance_double(Piece) }

    context 'when the king is surrounded by pieces' do
      subject(:bkg) { described_class.new(board, { color: :black, location: [0, 4] }) }
      let(:data) do
        [
          [nil, nil, nil, pic, bkg, pic, nil, nil],
          [nil, nil, nil, pic, pic, pic, nil, nil],
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
        result = bkg.find_possible_moves(board)
        expect(result).to be_empty
      end
    end

    context 'when the king has 3 open squares' do
      subject(:bkg) { described_class.new(board, { color: :black, location: [1, 4] }) }
      let(:data) do
        [
          [nil, nil, nil, pic, nil, pic, nil, nil],
          [nil, nil, nil, nil, bkg, pic, nil, nil],
          [nil, nil, nil, pic, pic, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has three moves' do
        allow(board).to receive(:data).and_return(data)
        result = bkg.find_possible_moves(board)
        expect(result).to contain_exactly([0, 4], [1, 3], [2, 5])
      end
    end

    context 'when the king is on the edge of an empty board' do
      subject(:bkg) { described_class.new(board, { color: :black, location: [3, 7] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, bkg],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has five moves' do
        allow(board).to receive(:data).and_return(data)
        result = bkg.find_possible_moves(board)
        expect(result).to contain_exactly([2, 7], [2, 6], [3, 6], [4, 6], [4, 7])
      end
    end

    context 'when king can castle king-side' do
      subject(:wkg) { described_class.new(board, { color: :white, location: [7, 4] }) }
      let(:wrk) { instance_double(Rook, color: :white, symbol: " \u265C ", moved: false, location: [7, 7]) }
      let(:wpc) { instance_double(Piece, color: :white, moved: false, location: [0, 4], captures: [[1, 4]]) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, wpc, wpc, wpc, nil, nil],
          [nil, nil, nil, wpc, wkg, nil, nil, wrk]
        ]
      end

      it 'has two moves' do
        allow(board).to receive(:data).and_return(data)
        result = wkg.find_possible_moves(board)
        expect(result).to contain_exactly([7, 5], [7, 6])
      end
    end
  end

  describe '#find_possible_captures' do
    let(:wpc) { instance_double(Piece, color: :white) }
    let(:bpc) { instance_double(Piece, color: :black) }

    context 'when there are no opposing piece to capture' do
      subject(:wkg) { described_class.new(board, { color: :white, location: [7, 4] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, wpc, wpc, wpc, nil, nil],
          [nil, nil, nil, wpc, wkg, wpc, nil, nil]
        ]
      end

      it 'has no captures' do
        allow(board).to receive(:data).and_return(data)
        result = wkg.find_possible_captures(board)
        expect(result).to be_empty
      end
    end

    context 'when the king is adjacent to 1 opposing piece' do
      subject(:wkg) { described_class.new(board, { color: :white, location: [7, 4] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, bpc, wpc, nil, nil, nil],
          [nil, nil, nil, nil, wkg, wpc, nil, nil]
        ]
      end

      it 'has one capture' do
        allow(board).to receive(:data).and_return(data)
        result = wkg.find_possible_captures(board)
        expect(result).to contain_exactly([6, 3])
      end
    end

    context 'when the king is adjacent to 2 opposing pieces' do
      subject(:wkg) { described_class.new(board, { color: :white, location: [4, 2] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, wpc, nil, nil, nil, nil, nil],
          [nil, nil, wkg, bpc, nil, nil, nil, nil],
          [nil, bpc, nil, wpc, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has two captures' do
        allow(board).to receive(:data).and_return(data)
        result = wkg.find_possible_captures(board)
        expect(result).to contain_exactly([4, 3], [5, 1])
      end
    end
  end

  describe '#king_side_castling?' do
    context 'when king can castle king-side' do
      subject(:wkg) { described_class.new(board, { color: :white, location: [7, 4] }) }
      let(:wrk) { instance_double(Rook, color: :white, symbol: " \u265C ", moved: false, location: [7, 7]) }
      let(:bpc) { instance_double(Piece, color: :black, symbol: " \u265C ", moved: false, location: [0, 4]) }
      let(:data) do
        [
          [nil, nil, nil, nil, bpc, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, wkg, nil, nil, wrk]
        ]
      end

      it 'returns true' do
        allow(board).to receive(:data).and_return(data)
        allow(bpc).to receive(:find_possible_moves).and_return([[1, 4]])
        result = wkg.send(:king_side_castling?, board)
        expect(result).to be true
      end
    end

    context 'when king has moved' do
      subject(:wkg) { described_class.new(board, { color: :white, location: [7, 4] }) }
      let(:wrk) { instance_double(Rook, color: :white, symbol: " \u265C ", moved: false, location: [7, 7]) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, wkg, nil, nil, wrk]
        ]
      end

      it 'returns false' do
        wkg.update_location(7, 5)
        allow(board).to receive(:data).and_return(data)
        result = wkg.send(:king_side_castling?, board)
        expect(result).to be false
      end
    end

    context 'when king can not safely pass through square' do
      subject(:wkg) { described_class.new(board, { color: :white, location: [7, 4] }) }
      let(:wrk) { instance_double(Rook, color: :white, symbol: " \u265C ", moved: false, location: [7, 7]) }
      let(:bpc) { instance_double(Piece, color: :black, symbol: " \u265C ", moved: false, location: [0, 4]) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, bpc, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, wkg, nil, nil, wrk]
        ]
      end

      it 'returns false' do
        allow(board).to receive(:data).and_return(data)
        allow(bpc).to receive(:find_possible_moves).and_return([[7, 5]])
        result = wkg.send(:king_side_castling?, board)
        expect(result).to be false
      end
    end

    context 'when pass through square is occupied' do
      subject(:wkg) { described_class.new(board, { color: :white, location: [7, 4] }) }
      let(:wrk) { instance_double(Rook, color: :white, symbol: " \u265C ", moved: false, location: [7, 7]) }
      let(:wpc) { instance_double(Piece, color: :white, moved: false, location: [7, 5]) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, wkg, wpc, nil, wrk]
        ]
      end

      it 'returns false' do
        allow(board).to receive(:data).and_return(data)
        result = wkg.send(:king_side_castling?, board)
        expect(result).to be false
      end
    end

    context 'when other square is occupied' do
      subject(:wkg) { described_class.new(board, { color: :white, location: [7, 4] }) }
      let(:wrk) { instance_double(Rook, color: :white, symbol: " \u265C ", moved: false, location: [7, 7]) }
      let(:wpc) { instance_double(Piece, color: :white, moved: false, location: [7, 6]) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, wkg, nil, wpc, wrk]
        ]
      end

      it 'returns false' do
        allow(board).to receive(:data).and_return(data)
        result = wkg.send(:king_side_castling?, board)
        expect(result).to be false
      end
    end
  end

  describe '#queen_side_castling?' do
    context 'when king can castle king-side' do
      subject(:bkg) { described_class.new(board, { color: :black, location: [0, 4] }) }
      let(:brk) { instance_double(Rook, color: :black, symbol: " \u265C ", moved: false, location: [0, 0]) }
      let(:wpc) { instance_double(Piece, color: :white, symbol: " \u265C ", moved: false, location: [7, 4]) }
      let(:data) do
        [
          [brk, nil, nil, nil, bkg, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, wpc, nil, nil, nil]
        ]
      end

      it 'returns true' do
        allow(board).to receive(:data).and_return(data)
        allow(wpc).to receive(:find_possible_moves).and_return([[6, 4]])
        result = bkg.send(:queen_side_castling?, board)
        expect(result).to be true
      end
    end

    context 'when king has moved' do
      subject(:bkg) { described_class.new(board, { color: :black, location: [0, 4] }) }
      let(:brk) { instance_double(Rook, color: :black, symbol: " \u265C ", moved: false, location: [0, 0]) }
      let(:wpc) { instance_double(Piece, color: :white, symbol: " \u265C ", moved: false, location: [7, 4], moves: [[6, 4]]) }
      let(:data) do
        [
          [brk, nil, nil, nil, bkg, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, wpc, nil, nil, nil]
        ]
      end

      it 'returns false' do
        bkg.update_location(7, 5)
        allow(board).to receive(:data).and_return(data)
        allow(wpc).to receive(:find_possible_moves).and_return([])
        result = bkg.send(:queen_side_castling?, board)
        expect(result).to be false
      end
    end

    context 'when king can not safely pass through square' do
      subject(:bkg) { described_class.new(board, { color: :black, location: [0, 4] }) }
      let(:brk) { instance_double(Rook, color: :black, symbol: " \u265C ", moved: false, location: [0, 0]) }
      let(:wpc) { instance_double(Piece, color: :white, symbol: " \u265C ", moved: false, location: [7, 4]) }
      let(:data) do
        [
          [brk, nil, nil, nil, bkg, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, wpc, nil, nil, nil, nil]
        ]
      end

      it 'returns false' do
        allow(board).to receive(:data).and_return(data)
        allow(wpc).to receive(:find_possible_moves).and_return([[0, 3]])
        result = bkg.send(:queen_side_castling?, board)
        expect(result).to be false
      end
    end

    context 'when pass through square is occupied' do
      subject(:bkg) { described_class.new(board, { color: :black, location: [0, 4] }) }
      let(:brk) { instance_double(Rook, color: :black, symbol: " \u265C ", moved: false, location: [0, 0]) }
      let(:bpc) { instance_double(Piece, color: :black, moved: false, location: [0, 3]) }
      let(:data) do
        [
          [brk, nil, nil, bpc, bkg, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'returns false' do
        allow(board).to receive(:data).and_return(data)
        result = bkg.send(:queen_side_castling?, board)
        expect(result).to be false
      end
    end

    context 'when first square is occupied' do
      subject(:bkg) { described_class.new(board, { color: :black, location: [0, 4] }) }
      let(:brk) { instance_double(Rook, color: :black, symbol: " \u265C ", moved: false, location: [0, 0]) }
      let(:bpc) { instance_double(Piece, color: :black, moved: false, location: [0, 1]) }
      let(:data) do
        [
          [brk, bpc, nil, nil, bkg, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'returns false' do
        allow(board).to receive(:data).and_return(data)
        result = bkg.send(:queen_side_castling?, board)
        expect(result).to be false
      end
    end

    context 'when second square is occupied' do
      subject(:bkg) { described_class.new(board, { color: :black, location: [0, 4] }) }
      let(:brk) { instance_double(Rook, color: :black, symbol: " \u265C ", moved: false, location: [0, 1]) }
      let(:bpc) { instance_double(Piece, color: :black, moved: false, location: [0, 2]) }
      let(:data) do
        [
          [brk, nil, bpc, nil, bkg, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'returns false' do
        allow(board).to receive(:data).and_return(data)
        result = bkg.send(:queen_side_castling?, board)
        expect(result).to be false
      end
    end
  end
end
