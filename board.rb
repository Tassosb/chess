require_relative 'pieces/piece_types'
require_relative 'errors'
require 'byebug'

class Board
  attr_reader :grid

  def initialize(should_setup = true)
    @grid = Array.new(8) { Array.new(8) }
    if should_setup
      setup_pieces
    end
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, mark)
    row, col = pos
    @grid[row][col] = mark
  end

  def setup_pieces
    color = :black
    (0..7).each do |row_idx|
      color = :white if row_idx > 5
      case row_idx
      when 0, 7
        self[[row_idx, 0]] = Rook.new([row_idx, 0], color, self)
        self[[row_idx, 1]] = Knight.new([row_idx, 1], color, self)
        self[[row_idx, 2]] = Bishop.new([row_idx, 2], color, self)
        self[[row_idx, 3]] = Queen.new([row_idx, 3], color, self)
        self[[row_idx, 4]] = King.new([row_idx, 4], color, self)
        self[[row_idx, 5]] = Bishop.new([row_idx, 5], color, self)
        self[[row_idx, 6]] = Knight.new([row_idx, 6], color, self)
        self[[row_idx, 7]] = Rook.new([row_idx, 7], color, self)
      when 1, 6
        8.times do |i|
          self[[row_idx, i]] = Pawn.new([row_idx, i], color, self)
        end
      else
        8.times do |i|
          self[[row_idx, i]] = NullPiece.instance
        end
      end
    end
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

    if start_piece.moves.include?(end_pos)
      self[end_pos] = self[start_pos]
      self[start_pos] = NullPiece.instance
      self[end_pos].update_pos(end_pos)
    else
      raise InvalidMoveError, "This piece cannot move that way"
    end
  end

  def in_bounds?(pos)
    pos.all? { |x| x.between?(0, 7) }
  end

  def in_check?(color)
    grid.any? do |row|
      row.any? do |piece|
        next if piece.color == color || piece.is_a?(NullPiece)
        piece.moves.include?(find_king_pos(color))
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

  def checkmate?(color)
    return false unless in_check?(color)

    grid.flatten.none? do |piece|
      piece.color == color && piece.valid_moves.count > 0
    end
  end

  def dup
    duped_board = Board.new(false)


    grid.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        new_pos = [i, j]
        new_piece = if piece.is_a?(NullPiece)
                      piece
                    else
                      piece.class.new(piece.pos, piece.color, duped_board)
                    end

        duped_board[new_pos] = new_piece
      end
    end

    duped_board
  end
end

# board = Board.new()
# duped_board = board.dup
# # duped_board[[0,0]] = "CHANGED"
# puts duped_board.object_id == board.object_id
# puts duped_board[[0,1]].object_id == board[[0,1]].object_id
