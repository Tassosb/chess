require_relative 'pieces/piece_types'
require_relative 'errors'
require 'byebug'

class Board
  attr_reader :grid

  def initialize(should_setup = true)
    @grid = Array.new(8) { Array.new(8) }
    setup_pieces if should_setup
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, mark)
    row, col = pos
    @grid[row][col] = mark
  end

  def move_piece!(start_pos, end_pos)
    self[end_pos] = self[start_pos]
    self[start_pos] = NullPiece.instance
    self[end_pos].update_pos(end_pos)
  end

  def move_piece(start_pos, end_pos)
    start_piece = self[start_pos]

    if self[start_pos].is_a?(NullPiece)
      raise InvalidMoveError, "There is no piece to move"
    end

    if start_piece.has_move?(end_pos)
      move_piece!(start_pos, end_pos)
    else
      raise InvalidMoveError, "This piece cannot move that way"
    end
  end

  def in_bounds?(pos)
    pos.all? { |x| x.between?(0, 7) }
  end

  def in_check?(color)
    pieces.any? do |piece|
      next if piece.color == color || piece.is_a?(NullPiece)
      piece.has_move?(find_king_pos(color))
    end
  end

  def checkmate?(color)
    return false unless in_check?(color)

    player_pieces_with_moves(color).empty?
  end

  def dup
    duped_board = Board.new(false)

    grid.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        new_piece = piece.is_a?(NullPiece) ? piece :
          piece.class.new(piece.pos, piece.color, duped_board)

        new_pos = [i, j]
        duped_board[new_pos] = new_piece
      end
    end

    duped_board
  end

  def matches_color?(pos, color)
    self[pos].color == color
  end

  def pieces
    grid.flatten
  end

  def player_pieces_with_moves(color)
    pieces.select { |piece| piece.color == color && piece.can_move? }
  end

  private

  def setup_pieces
    (0..7).each do |row_idx|
      color = row_idx > 5 ? :white : :black
      case row_idx
      when 0, 7
        royal_pieces = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

        royal_pieces.each_with_index do |piece_type, i|
          pos = [row_idx, i]
          self[[row_idx, i]] = piece_type.new(pos, color, self)
        end
      when 1, 6
        8.times do |i|
          self[[row_idx, i]] = Pawn.new([row_idx, i], color, self)
        end
      else
        8.times { |i| self[[row_idx, i]] = NullPiece.instance }
      end
    end
  end

  def find_king_pos(color)
    grid.each_with_index do |row, row_idx|
      row.each_with_index do |piece, col_idx|
        if piece.is_a?(King) && piece.color == color
          return [row_idx, col_idx]
        end
      end
    end

    raise MissingKingError, "The King has disappeared!"
  end
end
