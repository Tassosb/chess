require_relative 'piece'
require 'byebug'

class Board
  attr_reader :grid

  def initialize(grid = nil)
    if grid == nil
      @grid = Array.new(8) { Array.new(8) }
      setup_pieces
    else
      @grid = grid
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

    grid.any? do |row|
      row.any? do |piece|

        next if piece.color != color || piece.is_a?(NullPiece)
        !piece.valid_moves.empty?
      end
    end
  end

  def dup
    duped_grid = Board.dup_arr(grid)

    duped_board = Board.new(duped_grid)

    duped_board.grid.each do |row|
      row.each do |piece|
        piece.update_board(duped_board)
      end
    end
    # debugger
    duped_board
  end

  def self.dup_arr(array)
    array.map do | el|
      if el.is_a?(Array)
        Board.dup_arr(el)
      else
        el.is_a?(NullPiece) ? el : el.dup
      end
    end
  end

end

class MissingKingError < StandardError
end

class InvalidMoveError < StandardError
end

board = Board.new
# duped_board = board.dup
# p duped_board.class
# duped_board.move_piece([1,0], [2,0])
# p duped_board[[0,0]].class
# p board[[1,0]].to_s
# p duped_board[[1,0]].to_s
