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
    formatted_board.each_with_index do |row, idx|
      puts "#{8 - idx} #{row.join('')}"
    end
    puts "   #{('a'..'h').to_a.join('  ')}"
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
        elsif (row_i + col_i).odd?
          display[row_i][col_i] << board[pos].to_s.colorize(:background => :white)
        else
          display[row_i][col_i] << board[pos].to_s.colorize(:background => :grey)
        end
      end
    end

    display
  end
end
