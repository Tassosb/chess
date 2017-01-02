require_relative 'piece'

class Board
  attr_reader :board

  def initialize
    @board = Array.new(8) { Array.new(8) }
    setup_pieces
  end

  def [](pos)
    row, col = pos
    @board[row][col]
  end

  def []=(pos, mark)
    row, col = pos
    @board[row][col] = mark
  end

  def setup_pieces
    color = :black
    (0..7).each do |row_idx|
      color = :white if row_idx > 5
      case row_idx
      when 0, 7
        self[[row_idx, 0]] = Rook.new(color)
        self[[row_idx, 1]] = Knight.new(color)
        self[[row_idx, 2]] = Bishop.new(color)
        self[[row_idx, 3]] = King.new(color)
        self[[row_idx, 4]] = Queen.new(color)
        self[[row_idx, 5]] = Bishop.new(color)
        self[[row_idx, 6]] = Knight.new(color)
        self[[row_idx, 7]] = Rook.new(color)
      when 1, 6
        7.times do |i|
          self[[row_idx, i]] = Pawn.new(color)
        end
      else
        7.times do |i|
          self[[row_idx, i]] = NullPiece.new
        end
      end
    end
  end

  def move_piece(start_pos, end_pos)
    if self[start_pos].is_a?(NullPiece)
      raise "There is no piece to move"
    end

    unless self[end_pos].is_a?(NullPiece)
      raise "Space is already occupied"
    end

    self[end_pos] = self[start_pos]
    self[start_pos] = NullPiece.new
  end
end

board = Board.new
