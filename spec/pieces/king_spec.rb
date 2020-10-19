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
        allow(board).to receive(:data).and_return(data)
        result = black_king.find_possible_moves(board)
        expect(result).to be_empty
      end
    end

    context 'when the king has 3 open squares' do
      subject(:black_king) { described_class.new(board, { color: :black, location: [1, 4] }) }
      let(:data) do
        [
          [nil, nil, nil, piece, nil, piece, nil, nil],
          [nil, nil, nil, nil, black_king, piece, nil, nil],
          [nil, nil, nil, piece, piece, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'has three moves' do
        allow(board).to receive(:data).and_return(data)
        allow(piece).to receive(:color).and_return(:black)
        result = black_king.find_possible_moves(board)
        expect(result).to contain_exactly([0, 4], [1, 3], [2, 5])
      end
    end

    context 'when the king is on the edge of an empty board' do
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
        allow(board).to receive(:data).and_return(data)
        result = black_king.find_possible_moves(board)
        expect(result).to contain_exactly([2, 7], [2, 6], [3, 6], [4, 6], [4, 7])
      end
    end

    context 'when king can castle king-side' do
      subject(:white_king) { described_class.new(board, { color: :white, location: [7, 4] }) }
      let(:white_rook) { instance_double(Rook, color: :white, symbol: " \u265C ", moved: false, location: [7, 7]) }
      let(:piece) { instance_double(Piece, color: :white, moved: false, location: [0, 4], captures: [[1, 4]]) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, piece, piece, piece, nil, nil],
          [nil, nil, nil, piece, white_king, nil, nil, white_rook]
        ]
      end

      it 'has two moves' do
        allow(board).to receive(:data).and_return(data)
        result = white_king.find_possible_moves(board)
        expect(result).to contain_exactly([7, 5], [7, 6])
      end
    end
  end

  describe '#find_possible_captures' do
    let(:white_piece) { instance_double(Piece, color: :white) }
    let(:black_piece) { instance_double(Piece, color: :black) }

    context 'when there are no opposing piece to capture' do
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
        allow(board).to receive(:data).and_return(data)
        result = white_king.find_possible_captures(board)
        expect(result).to be_empty
      end
    end

    context 'when the king is adjacent to 1 opposing piece' do
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
        allow(board).to receive(:data).and_return(data)
        result = white_king.find_possible_captures(board)
        expect(result).to contain_exactly([6, 3])
      end
    end

    context 'when the king is adjacent to 2 opposing pieces' do
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
        allow(board).to receive(:data).and_return(data)
        result = white_king.find_possible_captures(board)
        expect(result).to contain_exactly([4, 3], [5, 1])
      end
    end
  end

  describe '#king_side_castling?' do
    context 'when king can castle king-side' do
      subject(:white_king) { described_class.new(board, { color: :white, location: [7, 4] }) }
      let(:white_rook) { instance_double(Rook, color: :white, symbol: " \u265C ", moved: false, location: [7, 7]) }
      let(:black_piece) { instance_double(Piece, color: :black, symbol: " \u265C ", moved: false, location: [0, 4]) }
      let(:data) do
        [
          [nil, nil, nil, nil, black_piece, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, white_king, nil, nil, white_rook]
        ]
      end

      it 'returns true' do
        allow(board).to receive(:data).and_return(data)
        allow(black_piece).to receive(:find_possible_moves).and_return([[1, 4]])
        result = white_king.send(:king_side_castling?, board)
        expect(result).to be true
      end
    end

    context 'when king has moved' do
      subject(:white_king) { described_class.new(board, { color: :white, location: [7, 4] }) }
      let(:white_rook) { instance_double(Rook, color: :white, symbol: " \u265C ", moved: false, location: [7, 7]) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, white_king, nil, nil, white_rook]
        ]
      end

      it 'returns false' do
        white_king.update_location(7, 5)
        allow(board).to receive(:data).and_return(data)
        result = white_king.send(:king_side_castling?, board)
        expect(result).to be false
      end
    end

    context 'when king can not safely pass through square' do
      subject(:white_king) { described_class.new(board, { color: :white, location: [7, 4] }) }
      let(:white_rook) { instance_double(Rook, color: :white, symbol: " \u265C ", moved: false, location: [7, 7]) }
      let(:black_piece) { instance_double(Piece, color: :black, symbol: " \u265C ", moved: false, location: [0, 4]) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, black_piece, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, white_king, nil, nil, white_rook]
        ]
      end

      it 'returns false' do
        allow(board).to receive(:data).and_return(data)
        allow(black_piece).to receive(:find_possible_moves).and_return([[7, 5]])
        result = white_king.send(:king_side_castling?, board)
        expect(result).to be false
      end
    end

    context 'when pass through square is occupied' do
      subject(:white_king) { described_class.new(board, { color: :white, location: [7, 4] }) }
      let(:white_rook) { instance_double(Rook, color: :white, symbol: " \u265C ", moved: false, location: [7, 7]) }
      let(:piece) { instance_double(Piece, color: :white, moved: false, location: [7, 5]) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, white_king, piece, nil, white_rook]
        ]
      end

      it 'returns false' do
        allow(board).to receive(:data).and_return(data)
        result = white_king.send(:king_side_castling?, board)
        expect(result).to be false
      end
    end

    context 'when other square is occupied' do
      subject(:white_king) { described_class.new(board, { color: :white, location: [7, 4] }) }
      let(:white_rook) { instance_double(Rook, color: :white, symbol: " \u265C ", moved: false, location: [7, 7]) }
      let(:piece) { instance_double(Piece, color: :white, moved: false, location: [7, 6]) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, white_king, nil, piece, white_rook]
        ]
      end

      it 'returns false' do
        allow(board).to receive(:data).and_return(data)
        result = white_king.send(:king_side_castling?, board)
        expect(result).to be false
      end
    end
  end

  describe '#queen_side_castling?' do
    context 'when king can castle king-side' do
      subject(:black_king) { described_class.new(board, { color: :black, location: [0, 4] }) }
      let(:black_rook) { instance_double(Rook, color: :black, symbol: " \u265C ", moved: false, location: [0, 0]) }
      let(:white_piece) { instance_double(Piece, color: :white, symbol: " \u265C ", moved: false, location: [7, 4]) }
      let(:data) do
        [
          [black_rook, nil, nil, nil, black_king, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, white_piece, nil, nil, nil]
        ]
      end

      it 'returns true' do
        allow(board).to receive(:data).and_return(data)
        allow(white_piece).to receive(:find_possible_moves).and_return([[6, 4]])
        result = black_king.send(:queen_side_castling?, board)
        expect(result).to be true
      end
    end

    context 'when king has moved' do
      subject(:black_king) { described_class.new(board, { color: :black, location: [0, 4] }) }
      let(:black_rook) { instance_double(Rook, color: :black, symbol: " \u265C ", moved: false, location: [0, 0]) }
      let(:white_piece) { instance_double(Piece, color: :white, symbol: " \u265C ", moved: false, location: [7, 4], moves: [[6, 4]]) }
      let(:data) do
        [
          [black_rook, nil, nil, nil, black_king, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, white_piece, nil, nil, nil]
        ]
      end

      it 'returns false' do
        black_king.update_location(7, 5)
        allow(board).to receive(:data).and_return(data)
        allow(white_piece).to receive(:find_possible_moves).and_return([])
        result = black_king.send(:queen_side_castling?, board)
        expect(result).to be false
      end
    end

    context 'when king can not safely pass through square' do
      subject(:black_king) { described_class.new(board, { color: :black, location: [0, 4] }) }
      let(:black_rook) { instance_double(Rook, color: :black, symbol: " \u265C ", moved: false, location: [0, 0]) }
      let(:white_piece) { instance_double(Piece, color: :white, symbol: " \u265C ", moved: false, location: [7, 4]) }
      let(:data) do
        [
          [black_rook, nil, nil, nil, black_king, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, white_piece, nil, nil, nil, nil]
        ]
      end

      it 'returns false' do
        allow(board).to receive(:data).and_return(data)
        allow(white_piece).to receive(:find_possible_moves).and_return([[0, 3]])
        result = black_king.send(:queen_side_castling?, board)
        expect(result).to be false
      end
    end

    context 'when pass through square is occupied' do
      subject(:black_king) { described_class.new(board, { color: :black, location: [0, 4] }) }
      let(:black_rook) { instance_double(Rook, color: :black, symbol: " \u265C ", moved: false, location: [0, 0]) }
      let(:piece) { instance_double(Piece, color: :black, moved: false, location: [0, 3]) }
      let(:data) do
        [
          [black_rook, nil, nil, piece, black_king, nil, nil, nil],
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
        result = black_king.send(:queen_side_castling?, board)
        expect(result).to be false
      end
    end

    context 'when first square is occupied' do
      subject(:black_king) { described_class.new(board, { color: :black, location: [0, 4] }) }
      let(:black_rook) { instance_double(Rook, color: :black, symbol: " \u265C ", moved: false, location: [0, 0]) }
      let(:piece) { instance_double(Piece, color: :black, moved: false, location: [0, 1]) }
      let(:data) do
        [
          [black_rook, piece, nil, nil, black_king, nil, nil, nil],
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
        result = black_king.send(:queen_side_castling?, board)
        expect(result).to be false
      end
    end

    context 'when second square is occupied' do
      subject(:black_king) { described_class.new(board, { color: :black, location: [0, 4] }) }
      let(:black_rook) { instance_double(Rook, color: :black, symbol: " \u265C ", moved: false, location: [0, 1]) }
      let(:piece) { instance_double(Piece, color: :black, moved: false, location: [0, 2]) }
      let(:data) do
        [
          [black_rook, nil, piece, nil, black_king, nil, nil, nil],
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
        result = black_king.send(:queen_side_castling?, board)
        expect(result).to be false
      end
    end
  end
end
