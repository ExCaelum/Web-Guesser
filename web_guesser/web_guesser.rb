require 'sinatra'
require 'sinatra/reloader'

class GuessingGame
  attr_accessor :number, :guesses

  def initialize
    @number = rand(100)
    @guesses = 5
  end

  def check_guess(guess)
    if guesses > 0
      if guess.include? "heat"
        "The SECRET NUMBER is #{number}"
      elsif guess != number && guesses == 1
        "Sorry, but you have lost. The game has restarted..."
      elsif guess.to_i > number && guess.to_i <= number + 5
        "Guess is too high"
      elsif guess.to_i > number + 5
        "Way too high!"
      elsif guess.to_i < number && guess.to_i >= number - 5
        "Guess is too low"
      elsif guess.to_i < number - 5
        "Way too low!"
      elsif guess.to_i == number
        "Correct, you have guessed the SECRET NUMBER! The game has restarted..."
      end
    elsif
      "Sorry, but you have lost. The game has restarted..."
    end
  end

  def check_reset(message)
    if guesses == 0
      @number = rand(100)
      @guesses = 5
    elsif message.include? "The game has restarted..."
      @number = rand(100)
      @guesses = 5
    else
      nil
    end
  end

  def get_background(message)
    if message == "Way too high!" || message == "Way too low!"
      "#880D1E"
    elsif message.include? "Correct"
      "#7EBF6B"
    else
      "#FFABB6"
    end
  end
end

game = GuessingGame.new

get '/' do
  guess = params["guess"]
  message = game.check_guess(guess)
  color = game.get_background(message)
  game.guesses -= 1
  game.check_reset(message)
  erb :index, :locals => {:number => game.number, :message => message, :color => color, :guesses => game.guesses }
end
