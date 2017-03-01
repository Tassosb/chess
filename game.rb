require_relative 'display'
require_relative 'board'
require_relative 'player'
require_relative 'errors'
require 'byebug'

class Game
  attr_reader :board, :display, :player1, :player2, :current_player

  def initialize(name1, name2)
    @board = Board.new
    @display = Display.new(board)
    @player1 = HumanPlayer.new(name1, :white, display)
    @player2 = HumanPlayer.new(name2, :black, display)
    @current_player = player1
  end

  def play
    until board.checkmate?(current_player.color)
      take_turn
      switch_players!
    end

    display.render
    puts "#{opposing_player.name} wins!"
  end

  def take_turn
    begin
      start_input, end_input = current_player.play_turn

      if board[start_input].move_into_check?(end_input)
        raise InvalidMoveError, "You are in check."
      end

      board.move_piece(start_input, end_input)
    rescue InvalidMoveError => e
      puts e.message
      sleep(1)
      retry
    end
  end

  def opposing_player
    current_player == player1 ? player2 : player1
  end

  def switch_players!
    @current_player = opposing_player
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Enter Player 1 name"
  player1_name = gets.chomp

  puts "Enter Player 2 name"
  player2_name = gets.chomp

  game = Game.new(player1_name, player2_name)
  game.play
end
