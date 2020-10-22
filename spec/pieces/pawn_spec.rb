# frozen_string_literal: true

require_relative '../../lib/pieces/pawn'
require_relative '../../lib/pieces/piece'
require_relative '../../lib/board'

RSpec.describe Pawn do
  let(:board) { instance_double(Board) }

  before do
    allow(board).to receive(:add_observer)
  end

  describe '#find_possible_moves' do
    let(:piece) { instance_double(Piece) }

    context 'when pawn is black' do
      context 'when pawn has not moved' do
        subject(:black_pawn) { described_class.new(board, { color: :black, location: [1, 0] }) }

        context 'when bonus square is empty' do
          let(:data) { [[nil, nil], [black_pawn, nil], [nil, nil], [nil, nil]] }

          it 'has two moves' do
            allow(board).to receive(:data).and_return(data)
            results = black_pawn.find_possible_moves(board)
            expect(results).to contain_exactly([2, 0], [3, 0])
          end
        end

        context 'when first square is occupied' do
          let(:data) { [[nil, nil], [black_pawn, nil], [piece, nil], [nil, nil]] }

          it 'has no moves' do
            allow(board).to receive(:data).and_return(data)
            results = black_pawn.find_possible_moves(board)
            expect(results).to be_empty
          end
        end

        context 'when bonus square is occupied' do
          let(:data) { [[nil, nil], [black_pawn, nil], [nil, nil], [piece, nil]] }

          it 'has one move' do
            allow(board).to receive(:data).and_return(data)
            results = black_pawn.find_possible_moves(board)
            expect(results).to contain_exactly([2, 0])
          end
        end
      end
    end

    context 'when pawn is white' do
      context 'when pawn has moved' do
        subject(:white_pawn) { described_class.new(board, { color: :white, location: [2, 0] }) }

        before do
          white_pawn.update_location(1, 0)
        end

        context 'when next square is empty' do
          let(:data) { [[nil, nil], [nil, nil], [white_pawn, nil], [nil, nil]] }

          it 'has one move' do
            allow(board).to receive(:data).and_return(data)
            results = white_pawn.find_possible_moves(board)
            expect(results).to contain_exactly([0, 0])
          end
        end

        context 'when next square is occupied' do
          let(:data) { [[piece, nil], [nil, nil], [white_pawn, nil], [nil, nil]] }

          it 'has no moves' do
            allow(board).to receive(:data).and_return(data)
            results = white_pawn.find_possible_moves(board)
            expect(results).to be_empty
          end
        end
      end
    end
  end

  describe '#find_possible_captures' do
    let(:black_piece) { instance_double(Piece, color: :black, symbol: nil) }
    let(:white_piece) { instance_double(Piece, color: :white, symbol: nil) }

    context 'when pawn is black' do
      context 'when pawn is in first file' do
        subject(:black_pawn) { described_class.new(board, { color: :black, location: [1, 0] }) }

        context 'when there is nothing to capture' do
          let(:data) do
            [
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [black_pawn, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil]
            ]
          end

          it 'has no captures' do
            allow(board).to receive(:data).and_return(data)
            allow(board).to receive(:previous_piece)
            result = black_pawn.find_possible_captures(board)
            expect(result).to be_empty
          end
        end

        context 'when a same color piece in capture square' do
          let(:data) do
            [
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [black_pawn, nil, nil, nil, nil, nil, nil, nil],
              [nil, black_piece, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil]
            ]
          end

          it 'has no captures' do
            allow(board).to receive(:data).and_return(data)
            allow(board).to receive(:previous_piece)
            result = black_pawn.find_possible_captures(board)
            expect(result).to be_empty
          end
        end
      end

      context 'when pawn is in second file' do
        context 'when an opposing piece in capture square' do
          subject(:black_pawn) { described_class.new(board, { color: :black, location: [1, 1] }) }
          let(:data) do
            [
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, black_pawn, black_piece, nil, nil, nil, nil, nil],
              [white_piece, nil, nil, nil, nil, nil, nil, nil],
              [black_piece, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil]
            ]
          end

          it 'has one capture' do
            allow(board).to receive(:data).and_return(data)
            allow(board).to receive(:previous_piece)
            result = black_pawn.find_possible_captures(board)
            expect(result).to contain_exactly([2, 0])
          end
        end
      end

      context 'when neighboring pawn has en_passant' do
        subject(:black_pawn) { described_class.new(board, { color: :black, location: [4, 1] }) }
        let(:white_pawn) { instance_double(Pawn, en_passant: true, location: [4, 2], symbol: " \u265F ") }
        let(:data) do
          [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, black_pawn, white_pawn, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil]
          ]
        end

        it 'has one capture' do
          allow(board).to receive(:data).and_return(data)
          allow(board).to receive(:previous_piece).and_return(white_pawn)
          result = black_pawn.find_possible_captures(board)
          expect(result).to contain_exactly([4, 2])
        end
      end

      context 'when non-neighboring pawn has en_passant' do
        subject(:black_pawn) { described_class.new(board, { color: :black, location: [4, 1] }) }
        let(:white_pawn) { instance_double(Pawn, en_passant: true, location: [4, 5], symbol: " \u265F ") }
        let(:data) do
          [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, black_pawn, nil, nil, nil, white_pawn, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil]
          ]
        end

        it 'has no capture' do
          allow(board).to receive(:data).and_return(data)
          allow(board).to receive(:previous_piece).and_return(white_pawn)
          result = black_pawn.find_possible_captures(board)
          expect(result).to be_empty
        end
      end

      context 'when pawn has a capture and is next to a pawn without en_passant' do
        subject(:black_pawn) { described_class.new(board, { color: :black, location: [4, 1] }) }
        let(:white_pawn) { instance_double(Pawn, en_passant: false, location: [4, 2], symbol: " \u265F ") }
        let(:data) do
          [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, black_pawn, white_pawn, nil, nil, nil, nil, nil],
            [white_piece, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil]
          ]
        end

        it 'has one capture' do
          allow(board).to receive(:data).and_return(data)
          allow(board).to receive(:previous_piece).and_return(white_pawn)
          result = black_pawn.find_possible_captures(board)
          expect(result).to contain_exactly([5, 0])
        end
      end
    end

    context 'when pawn is white' do
      context 'when pawn is in last file' do
        context 'when an opposite color piece in capture square' do
          subject(:white_pawn) { described_class.new(board, { color: :white, location: [6, 7] }) }
          let(:data) do
            [
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, black_piece, nil],
              [nil, nil, nil, nil, nil, nil, nil, white_pawn],
              [nil, nil, nil, nil, nil, nil, nil, nil]
            ]
          end

          it 'has one capture' do
            allow(board).to receive(:data).and_return(data)
            allow(board).to receive(:previous_piece)
            result = white_pawn.find_possible_captures(board)
            expect(result).to contain_exactly([5, 6])
          end
        end
      end

      context 'when pawn is in middle file' do
        context 'when two opposite color pieces are in capture squares' do
          subject(:white_pawn) { described_class.new(board, { color: :white, location: [6, 4] }) }
          let(:data) do
            [
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, black_piece, nil, black_piece, nil, nil],
              [nil, nil, nil, nil, white_pawn, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil]
            ]
          end

          it 'has two captures' do
            allow(board).to receive(:data).and_return(data)
            allow(board).to receive(:previous_piece)
            result = white_pawn.find_possible_captures(board)
            expect(result).to contain_exactly([5, 5], [5, 3])
          end
        end

        context 'when pawn has a basic and en_passant capture' do
          subject(:white_pawn) { described_class.new(board, { color: :white, location: [3, 3] }) }
          let(:black_pawn) { instance_double(Pawn, en_passant: true, location: [3, 4], symbol: " \u265F ") }
          let(:data) do
            [
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, black_piece, nil, nil, nil, nil, nil],
              [nil, nil, nil, white_pawn, black_pawn, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil]
            ]
          end

          it 'has two captures' do
            allow(board).to receive(:data).and_return(data)
            allow(board).to receive(:previous_piece).and_return(black_pawn)
            result = white_pawn.find_possible_captures(board)
            expect(result).to contain_exactly([3, 4], [2, 2])
          end
        end

        context 'when pawn has en_passant but is not previous_piece' do
          subject(:white_pawn) { described_class.new(board, { color: :white, location: [3, 3] }) }
          let(:black_pawn) { instance_double(Pawn, en_passant: true, location: [3, 4], symbol: " \u265F ") }
          let(:data) do
            [
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, black_piece, nil, nil, nil, nil, nil],
              [nil, nil, nil, white_pawn, black_pawn, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil],
              [nil, nil, nil, nil, nil, nil, nil, nil]
            ]
          end

          it 'has one capture' do
            allow(board).to receive(:data).and_return(data)
            allow(board).to receive(:previous_piece).and_return(black_piece)
            allow(black_piece).to receive(:location).and_return([2, 2])
            result = white_pawn.find_possible_captures(board)
            expect(result).to contain_exactly([2, 2])
          end
        end
      end
    end
  end

  describe '#update_location' do
    context 'when pawn moves one square' do
      subject(:black_pawn) { described_class.new(board, { color: :black, location: [1, 1] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, black_pawn, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'is not en passant' do
        black_pawn.update_location(2, 1)
        expect(black_pawn.en_passant).to be false
      end
    end

    context 'when pawn moves two squares' do
      subject(:black_pawn) { described_class.new(board, { color: :black, location: [1, 1] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, black_pawn, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'is en passant' do
        black_pawn.update_location(3, 1)
        expect(black_pawn.en_passant).to be true
      end
    end
  end

  describe '#en_passant_rank?' do
    context 'when pawn is in correct rank for en passant' do
      context 'when pawn is white' do
        subject(:white_pawn) { described_class.new(board, { color: :white, location: [3, 4] }) }

        it 'returns true' do
          result = white_pawn.en_passant_rank?
          expect(result).to be true
        end
      end

      context 'when pawn is black' do
        subject(:black_pawn) { described_class.new(board, { color: :black, location: [4, 4] }) }

        it 'returns true' do
          result = black_pawn.en_passant_rank?
          expect(result).to be true
        end
      end
    end

    context 'when pawn is not in correct rank for en passant' do
      context 'when pawn is white' do
        subject(:white_pawn) { described_class.new(board, { color: :white, location: [6, 4] }) }

        it 'returns false' do
          result = white_pawn.en_passant_rank?
          expect(result).to be false
        end
      end

      context 'when pawn is black' do
        subject(:black_pawn) { described_class.new(board, { color: :black, location: [2, 4] }) }

        it 'returns false' do
          result = black_pawn.en_passant_rank?
          expect(result).to be false
        end
      end
    end
  end

  describe '#rank_direction' do
    context 'when pawn is white' do
      subject(:white_pawn) { described_class.new(board, { color: :white, location: [3, 4] }) }

      it 'returns -1' do
        result = white_pawn.rank_direction
        expect(result).to eq(-1)
      end
    end

    context 'when pawn is black' do
      subject(:black_pawn) { described_class.new(board, { color: :black, location: [4, 4] }) }

      it 'returns 1' do
        result = black_pawn.rank_direction
        expect(result).to eq(1)
      end
    end
  end
end
