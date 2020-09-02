# frozen_string_literal: true

require_relative '../../lib/pieces/pawn'

RSpec.describe Pawn do
  describe '#update_moves' do
    context 'when pawn is black' do
      subject(:black_pawn) { described_class.new({ color: :black, location: [1, 0] }) }

      context 'when pawn has not moved' do
        it 'has two moves' do
          black_pawn.update_moves
          expect(black_pawn.moves).to contain_exactly([2, 0], [3, 0])
        end
      end

      context 'when pawn has moved' do
        it 'has one move' do
          black_pawn.update_location(2, 0)
          black_pawn.update_moves
          expect(black_pawn.moves).to contain_exactly([3, 0])
        end
      end
    end

    context 'when pawn is white' do
      subject(:white_pawn) { described_class.new({ color: :white, location: [6, 0] }) }

      context 'when pawn has not moved' do
        it 'has two moves' do
          white_pawn.update_moves
          expect(white_pawn.moves).to contain_exactly([5, 0], [4, 0])
        end
      end

      context 'when pawn has moved' do
        it 'has one move' do
          white_pawn.update_location(5, 0)
          white_pawn.update_moves
          expect(white_pawn.moves).to contain_exactly([4, 0])
        end
      end
    end
  end

  describe '#update_captures' do
    context 'when pawn is black' do
      context 'when pawn is in the middle of the board' do
        subject(:black_pawn) { described_class.new({ color: :black, location: [1, 4] }) }

        it 'has two captures' do
          black_pawn.update_captures
          expect(black_pawn.captures).to contain_exactly([2, 3], [2, 5])
        end
      end

      context 'when pawn is on the edge of the board' do
        subject(:black_pawn) { described_class.new({ color: :black, location: [1, 0] }) }

        it 'has one capture' do
          black_pawn.update_captures
          expect(black_pawn.captures).to contain_exactly([2, 1])
        end
      end

      context 'when pawn is in the middle of the board' do
        subject(:black_pawn) { described_class.new({ color: :black, location: [1, 7] }) }

        it 'has one capture' do
          black_pawn.update_captures
          expect(black_pawn.captures).to contain_exactly([2, 6])
        end
      end
    end

    context 'when pawn is white' do
      context 'when pawn is in the middle of the board' do
        subject(:white_pawn) { described_class.new({ color: :white, location: [6, 3] }) }

        it 'has two captures' do
          white_pawn.update_captures
          expect(white_pawn.captures).to contain_exactly([5, 2], [5, 4])
        end
      end

      context 'when pawn is on the edge of the board' do
        subject(:white_pawn) { described_class.new({ color: :white, location: [6, 0] }) }

        it 'has one capture' do
          white_pawn.update_captures
          expect(white_pawn.captures).to contain_exactly([5, 1])
        end
      end

      context 'when pawn is in the middle of the board' do
        subject(:white_pawn) { described_class.new({ color: :white, location: [6, 7] }) }

        it 'has one capture' do
          white_pawn.update_captures
          expect(white_pawn.captures).to contain_exactly([5, 6])
        end
      end
    end
  end
end
