# frozen_string_literal: true

require_relative '../lib/move_validator'
require_relative '../lib/board'
require_relative '../lib/pieces/piece'
require_relative '../lib/pieces/king'
require_relative '../lib/pieces/queen'
require_relative '../lib/pieces/bishop'
require_relative '../lib/pieces/knight'
require_relative '../lib/pieces/rook'
require_relative '../lib/pieces/pawn'

RSpec.describe MoveValidator do
  describe '#verify_possible_moves' do
    context 'when king is in check and has valid moves' do
      # [-----, -----, -----, wrook, bking, bpawn, -----, -----],
      # [-----, -----, -----, -----, bpawn, bpawn, -----, -----],
      # [-----, -----, -----, -----, -----, -----, -----, -----],
      # [-----, -----, -----, -----, -----, -----, -----, -----],
      # [-----, -----, -----, -----, -----, -----, -----, -----],
      # [-----, -----, -----, -----, -----, -----, -----, -----],
      # [-----, -----, -----, -----, -----, -----, -----, -----],
      # [-----, -----, -----, -----, -----, -----, -----, -----]

      board = Board.new
      board.data[0][3] = Rook.new(board, { color: :white, location: [0, 3] })
      board.data[0][4] = King.new(board, { color: :black, location: [0, 4] })
      board.data[0][5] = Pawn.new(board, { color: :black, location: [0, 5] })
      board.data[1][4] = Pawn.new(board, { color: :black, location: [1, 4] })
      board.data[1][5] = Pawn.new(board, { color: :black, location: [1, 5] })
      board.data[6][0] = Pawn.new(board, { color: :white, location: [6, 0] })
      subject(:validator) { described_class.new([0, 4], board, [[0, 3], [1, 3]]) }

      it 'returns move for king to capture rook' do
        board.instance_variable_set(:@black_king, board.data[0][4])
        validator.instance_variable_set(:@current_piece, board.data[0][4])
        results = validator.verify_possible_moves
        expect(results).to contain_exactly([0, 3])
      end
    end

    context 'when moving queen can put king in check' do
      # [-----, -----, -----, -----, bking, -----, -----, -----],
      # [-----, -----, -----, bpawn, -----, bpawn, -----, -----],
      # [-----, -----, bpawn, -----, bquen, -----, bpawn, -----],
      # [-----, -----, -----, bpawn, -----, bpawn, -----, -----],
      # [-----, -----, -----, -----, -----, -----, -----, -----],
      # [-----, -----, -----, -----, -----, -----, -----, -----],
      # [-----, -----, -----, -----, wquen, -----, -----, -----],
      # [-----, -----, -----, -----, -----, -----, -----, -----]

      board = Board.new
      board.data[2][4] = Queen.new(board, { color: :black, location: [2, 4] })
      board.data[0][4] = King.new(board, { color: :black, location: [0, 4] })
      board.data[6][4] = Queen.new(board, { color: :white, location: [6, 4] })
      board.data[1][3] = Pawn.new(board, { color: :black, location: [1, 3] })
      board.data[1][5] = Pawn.new(board, { color: :black, location: [1, 5] })
      board.data[2][2] = Pawn.new(board, { color: :black, location: [2, 2] })
      board.data[2][6] = Pawn.new(board, { color: :black, location: [2, 6] })
      board.data[3][3] = Pawn.new(board, { color: :black, location: [3, 3] })
      board.data[3][5] = Pawn.new(board, { color: :black, location: [3, 5] })
      subject(:validator) { described_class.new([2, 4], board, [[1, 4], [3, 4], [4, 4], [5, 4], [2, 3], [2, 5]]) }

      it 'return moves that will not put King in check' do
        board.instance_variable_set(:@black_king, board.data[0][4])
        validator.instance_variable_set(:@current_piece, board.data[2][4])
        results = validator.verify_possible_moves
        expect(results).to contain_exactly([1, 4], [3, 4], [4, 4], [5, 4])
      end
    end

    context 'when king is in check at start of turn and 5 of 6 piece have valid moves' do
      # [-----, -----, -----, -----, -----, -----, -----, -----],
      # [-----, -----, -----, -----, -----, -----, -----, -----],
      # [-----, -----, -----, -----, -----, -----, -----, wquen],
      # [-----, -----, -----, -----, wnite, -----, bquen, -----],
      # [-----, -----, -----, -----, -----, wrook, -----, -----],
      # [-----, -----, -----, -----, -----, -----, -----, wbshp],
      # [-----, -----, -----, -----, wpawn, -----, -----, -----],
      # [-----, -----, -----, -----, -----, -----, wking, -----]
      board = Board.new
      board.data[2][7] = Queen.new(board, { color: :white, location: [2, 7] })
      board.data[3][4] = Knight.new(board, { color: :white, location: [3, 4] })
      board.data[3][6] = Queen.new(board, { color: :black, location: [3, 6] })
      board.data[4][5] = Rook.new(board, { color: :white, location: [4, 5] })
      board.data[5][7] = Bishop.new(board, { color: :white, location: [5, 7] })
      board.data[7][6] = King.new(board, { color: :white, location: [7, 6] })
      board.data[6][4] = Pawn.new(board, { color: :white, location: [6, 4] })

      before do
        board.instance_variable_set(:@white_king, board.data[7][6])
      end

      context 'when white pawn can not block the black queen' do
        subject(:pawn_validator) { described_class.new([6, 4], board, [[5, 4], [4, 4]]) }

        it 'has no moves' do
          board.instance_variable_set(:@white_king, board.data[7][6])
          pawn_validator.instance_variable_set(:@current_piece, board.data[6][4])
          results = pawn_validator.verify_possible_moves
          expect(results).to be_empty
        end
      end

      context 'when white queen can kill black queen' do
        subject(:validator) { described_class.new([2, 7], board, [[1, 7], [1, 6], [2, 6], [3, 6], [3, 7]]) }

        it 'returns move to kill the queen' do
          validator.instance_variable_set(:@current_piece, board.data[2][7])
          results = validator.verify_possible_moves
          expect(results).to contain_exactly([3, 6])
        end
      end

      context 'when white knight can block the black queen' do
        subject(:validator) { described_class.new([3, 4], board, [[4, 6], [2, 6], [1, 5], [5, 5]]) }

        it 'returns move to block the queen' do
          validator.instance_variable_set(:@current_piece, board.data[3][4])
          results = validator.verify_possible_moves
          expect(results).to contain_exactly([4, 6])
        end
      end

      context 'when white rook can block the black queen' do
        subject(:validator) { described_class.new([4, 5], board, [[4, 0], [4, 1], [4, 3], [4, 4], [4, 6], [4, 7]]) }

        it 'returns move to block the queen' do
          validator.instance_variable_set(:@current_piece, board.data[4][5])
          results = validator.verify_possible_moves
          expect(results).to contain_exactly([4, 6])
        end
      end

      context 'when white bishop can block the black queen' do
        subject(:validator) { described_class.new([5, 7], board, [[4, 6], [6, 6], [7, 5]]) }

        it 'returns two moves to block the queen' do
          validator.instance_variable_set(:@current_piece, board.data[5][7])
          results = validator.verify_possible_moves
          expect(results).to contain_exactly([4, 6], [6, 6])
        end
      end

      context 'when white king can move out of check' do
        subject(:validator) { described_class.new([7, 6], board, [[7, 5], [7, 7], [6, 5], [6, 6], [6, 7]]) }

        it 'returns four legal moves' do
          validator.instance_variable_set(:@current_piece, board.data[7][6])
          results = validator.verify_possible_moves
          expect(results).to contain_exactly([7, 5], [7, 7], [6, 5], [6, 7])
        end
      end
    end
  end
end
