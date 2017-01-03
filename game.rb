require_relative 'display'
require_relative 'board'
require_relative 'player' 
require 'byebug'

class Game
  attr_reader :board, :display

  def initialize
    @board = Board.new
    @display = Display.new(board)
  end

  def play
    until board.checkmate?(:white)
      display.render
      start_input = display.cursor.get_input

      if start_input
        # debugger
        end_input = nil
        until end_input
          display.render
          end_input = display.cursor.get_input
        end

        begin
          board.move_piece(start_input, end_input)
        rescue InvalidMoveError => e
          puts e.message
          sleep(1)
        end
      end
    end
  end


end


game = Game.new
# p game.board[[4,4]].color
# game.board[[0,3]] = Bishop.new([2,2], :black, game.board)
# game.board[[2,3]] = Queen.new([2,3], :black, game.board)
# game.board[[3,3]] = King.new([3,3], :black, game.board)
# game.board[[4,4]] = Pawn.new([4,4], :white, game.board)
# game.display.render
# puts game.board.in_check?(:black)


# p duped_board

game.play
