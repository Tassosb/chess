require_relative 'display'
require_relative 'board'
require_relative 'player'
require_relative 'errors'
require 'byebug'

class Game
  attr_reader :board, :display, :player1, :player2, :current_player

  def initialize(player1, player2)
    @board = Board.new
    @display = Display.new(board)
    @player1 = player1
    @player2 = player2
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
      start_input, end_input = current_player.play_turn(display)

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
  puts "Enter number of players. (1 or 2)"
  num_players = Integer(gets.chomp)

  puts "Enter Player 1 name"
  player1_name = gets.chomp
  player1 = HumanPlayer.new(player1_name, :white)

  if num_players == 2
    puts "Enter Player 2 name"
    player2_name = gets.chomp
    player2 = HumanPlayer.new(player2_name, :black)
  else
    player2 = ComputerPlayer.new("AI", :black)
  end

  game = Game.new(player1, player2)
  game.play
end
