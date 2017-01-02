require_relative 'board'
require_relative 'cursor'
require 'colorize'
require 'byebug'

class Display
  attr_reader :board, :cursor

  def initialize(board)
    @cursor = Cursor.new([0,0], board)
    @board = board
  end

  def render
    system("clear")
    formatted_board.each do |row|
      puts row.join('')
      # puts '-------------------------------'
    end
  end

  def cursor_pos
    @cursor.cursor_pos
  end

  def formatted_board
    display = Array.new(8) { Array.new(8) { [] } }

    (0..7).each do |row_i|
      (0..7).each do |col_i|
        pos = [row_i, col_i]
        if pos == cursor_pos
          display[row_i][col_i] << board[pos].to_s.colorize(:background => :blue)
        elsif (row_i + col_i).even?
          display[row_i][col_i] << board[pos].to_s.colorize(:background => :white)
        else
          display[row_i][col_i] << board[pos].to_s
        end
      end
    end

    display
  end

  def test_render
    while true
      render
      @cursor.get_input
    end
  end
end

board = Board.new
Display.new(board).test_render



# "dsfsf".colorize(:blue)
# "sdgds".blue
