# frozen_string_literal: true

require_relative '../../lib/pieces/pawn'
require_relative '../../lib/pieces/piece'
require_relative '../../lib/pieces/king'
require_relative '../../lib/pieces/queen'
require_relative '../../lib/board'

RSpec.describe Pawn do
  let(:board) { instance_double(Board) }

  before do
    allow(board).to receive(:add_observer)
  end

  describe '#find_possible_moves' do
    let(:pic) { instance_double(Piece) }

    context 'when pawn is black and has not moved' do
      subject(:bpn) { described_class.new(board, { color: :black, location: [1, 0] }) }

      context 'when first & second bonus square is empty' do
        let(:data) do
          [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [bpn, nil, nil, nil, nil, nil, nil, nil],
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
          results = bpn.find_possible_moves(board)
          expect(results).to contain_exactly([2, 0], [3, 0])
        end
      end

      context 'when first square is occupied' do
        let(:data) do
          [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [bpn, nil, nil, nil, nil, nil, nil, nil],
            [pic, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil]
          ]
        end

        it 'has no moves' do
          allow(board).to receive(:data).and_return(data)
          results = bpn.find_possible_moves(board)
          expect(results).to be_empty
        end
      end

      context 'when second bonus square is occupied' do
        let(:data) do
          [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [bpn, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [pic, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil]
          ]
        end

        it 'has one move' do
          allow(board).to receive(:data).and_return(data)
          results = bpn.find_possible_moves(board)
          expect(results).to contain_exactly([2, 0])
        end
      end
    end

    context 'when pawn is white and has moved' do
      subject(:wpn) { described_class.new(board, { color: :white, location: [6, 0] }) }

      before do
        wpn.update_location(5, 0)
      end

      context 'when next square is empty' do
        let(:data) do
          [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [wpn, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil]
          ]
        end

        it 'has one move' do
          allow(board).to receive(:data).and_return(data)
          results = wpn.find_possible_moves(board)
          expect(results).to contain_exactly([4, 0])
        end
      end

      context 'when next square is occupied' do
        let(:data) do
          [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [pic, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [wpn, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil]
          ]
        end

        it 'has no moves' do
          allow(board).to receive(:data).and_return(data)
          results = wpn.find_possible_moves(board)
          expect(results).to be_empty
        end
      end
    end
  end

  describe '#find_possible_captures' do
    let(:bpc) { instance_double(Piece, color: :black, symbol: nil) }
    let(:wpc) { instance_double(Piece, color: :white, symbol: nil) }

    context 'when pawn is black' do
      context 'when there is nothing to capture' do
        subject(:bpn) { described_class.new(board, { color: :black, location: [1, 0] }) }
        let(:data) do
          [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [bpn, nil, nil, nil, nil, nil, nil, nil],
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
          result = bpn.find_possible_captures(board)
          expect(result).to be_empty
        end
      end

      context 'when a same color piece in capture square' do
        subject(:bpn) { described_class.new(board, { color: :black, location: [1, 0] }) }
        let(:data) do
          [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [bpn, nil, nil, nil, nil, nil, nil, nil],
            [nil, bpc, nil, nil, nil, nil, nil, nil],
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
          result = bpn.find_possible_captures(board)
          expect(result).to be_empty
        end
      end

      context 'when an opposing piece in capture square' do
        subject(:bpn) { described_class.new(board, { color: :black, location: [1, 1] }) }
        let(:data) do
          [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, bpn, nil, nil, nil, nil, nil, nil],
            [wpc, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil]
          ]
        end

        it 'has one capture' do
          allow(board).to receive(:data).and_return(data)
          allow(board).to receive(:previous_piece)
          result = bpn.find_possible_captures(board)
          expect(result).to contain_exactly([2, 0])
        end
      end

      context 'when neighboring pawn has en_passant' do
        subject(:bpn) { described_class.new(board, { color: :black, location: [4, 1] }) }
        let(:wpn) { instance_double(Pawn, en_passant: true, location: [4, 2], symbol: " \u265F ") }
        let(:data) do
          [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, bpn, wpn, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil]
          ]
        end

        it 'has one capture' do
          allow(board).to receive(:data).and_return(data)
          allow(board).to receive(:previous_piece).and_return(wpn)
          allow(bpn).to receive(:legal_en_passant_move?).and_return(true)
          result = bpn.find_possible_captures(board)
          expect(result).to contain_exactly([4, 2])
        end
      end

      context 'when non-neighboring pawn has en_passant' do
        subject(:bpn) { described_class.new(board, { color: :black, location: [4, 1] }) }
        let(:wpn) { instance_double(Pawn, en_passant: true, location: [4, 5], symbol: " \u265F ") }
        let(:data) do
          [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, bpn, nil, nil, nil, wpn, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil]
          ]
        end

        it 'has no capture' do
          allow(board).to receive(:data).and_return(data)
          allow(board).to receive(:previous_piece).and_return(wpn)
          result = bpn.find_possible_captures(board)
          expect(result).to be_empty
        end
      end

      context 'when pawn has a capture and is next to a pawn without en_passant' do
        subject(:bpn) { described_class.new(board, { color: :black, location: [4, 1] }) }
        let(:wpn) { instance_double(Pawn, color: :white, en_passant: false, location: [4, 2], symbol: " \u265F ") }
        let(:data) do
          [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, bpn, wpn, nil, nil, nil, nil, nil],
            [wpn, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil]
          ]
        end

        it 'has one capture' do
          allow(board).to receive(:data).and_return(data)
          allow(board).to receive(:previous_piece).and_return(wpn)
          result = bpn.find_possible_captures(board)
          expect(result).to contain_exactly([5, 0])
        end
      end
    end

    context 'when pawn is white' do
      context 'when an opposite color piece in capture square' do
        subject(:wpn) { described_class.new(board, { color: :white, location: [6, 7] }) }
        let(:data) do
          [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, bpc, nil],
            [nil, nil, nil, nil, nil, nil, nil, wpn],
            [nil, nil, nil, nil, nil, nil, nil, nil]
          ]
        end

        it 'has one capture' do
          allow(board).to receive(:data).and_return(data)
          allow(board).to receive(:previous_piece)
          result = wpn.find_possible_captures(board)
          expect(result).to contain_exactly([5, 6])
        end
      end

      context 'when two opposite color pieces are in capture squares' do
        subject(:wpn) { described_class.new(board, { color: :white, location: [6, 4] }) }
        let(:data) do
          [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, bpc, nil, bpc, nil, nil],
            [nil, nil, nil, nil, wpn, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil]
          ]
        end

        it 'has two captures' do
          allow(board).to receive(:data).and_return(data)
          allow(board).to receive(:previous_piece)
          result = wpn.find_possible_captures(board)
          expect(result).to contain_exactly([5, 5], [5, 3])
        end
      end

      context 'when pawn has a basic and en_passant capture' do
        subject(:wpn) { described_class.new(board, { color: :white, location: [3, 3] }) }
        let(:bpn) { instance_double(Pawn, en_passant: true, location: [3, 4], symbol: " \u265F ") }
        let(:data) do
          [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, bpc, nil, nil, nil, nil, nil],
            [nil, nil, nil, wpn, bpn, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil]
          ]
        end

        it 'has two captures' do
          allow(board).to receive(:data).and_return(data)
          allow(board).to receive(:previous_piece).and_return(bpn)
          allow(wpn).to receive(:legal_en_passant_move?).and_return(true)
          result = wpn.find_possible_captures(board)
          expect(result).to contain_exactly([3, 4], [2, 2])
        end
      end

      context 'when pawn has an en_passant capture but puts King in check' do
        subject(:wpn) { described_class.new(board, { color: :white, location: [3, 3] }) }
        let(:bpn) { instance_double(Pawn, en_passant: true, location: [3, 4], symbol: " \u265F ") }
        let(:wkg) { instance_double(King, location: [3, 0]) }
        let(:bqn) { instance_double(Queen, location: [3, 7]) }
        let(:data) do
          [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, bpc, nil, nil, nil, nil, nil],
            [wkg, nil, nil, wpn, bpn, nil, nil, bqn],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil]
          ]
        end

        it 'does not return en_passant capture' do
          allow(board).to receive(:data).and_return(data)
          allow(board).to receive(:previous_piece).and_return(bpn)
          allow(board).to receive(:white_king).and_return(wkg)
          allow(wpn).to receive(:legal_en_passant_move?).and_return(false)
          result = wpn.find_possible_captures(board)
          expect(result).not_to include([3, 4])
        end
      end

      context 'when pawn has en_passant but is not previous_piece' do
        subject(:wpn) { described_class.new(board, { color: :white, location: [3, 3] }) }
        let(:bpn) { instance_double(Pawn, en_passant: true, location: [3, 4], symbol: " \u265F ") }
        let(:data) do
          [
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, bpc, nil, nil, nil, nil, nil],
            [nil, nil, nil, wpn, bpn, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil],
            [nil, nil, nil, nil, nil, nil, nil, nil]
          ]
        end

        it 'has one capture' do
          allow(board).to receive(:data).and_return(data)
          allow(board).to receive(:previous_piece).and_return(bpc)
          allow(bpc).to receive(:location).and_return([2, 2])
          result = wpn.find_possible_captures(board)
          expect(result).to contain_exactly([2, 2])
        end
      end
    end
  end

  describe '#update_location' do
    context 'when pawn moves one square' do
      subject(:bpn) { described_class.new(board, { color: :black, location: [1, 1] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, bpn, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'is not en passant' do
        bpn.update_location(2, 1)
        expect(bpn.en_passant).to be false
      end
    end

    context 'when pawn moves two squares' do
      subject(:bpn) { described_class.new(board, { color: :black, location: [1, 1] }) }
      let(:data) do
        [
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, bpn, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil],
          [nil, nil, nil, nil, nil, nil, nil, nil]
        ]
      end

      it 'is en passant' do
        bpn.update_location(3, 1)
        expect(bpn.en_passant).to be true
      end
    end
  end

  describe '#en_passant_rank?' do
    context 'when pawn is in correct rank for en passant' do
      context 'when pawn is white' do
        subject(:wpn) { described_class.new(board, { color: :white, location: [3, 4] }) }

        it 'returns true' do
          result = wpn.en_passant_rank?
          expect(result).to be true
        end
      end

      context 'when pawn is black' do
        subject(:bpn) { described_class.new(board, { color: :black, location: [4, 4] }) }

        it 'returns true' do
          result = bpn.en_passant_rank?
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
