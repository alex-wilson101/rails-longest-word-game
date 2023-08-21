require "json"
require "open-uri"

class PagesController < ApplicationController
  def new
    @grid = []
    9.times do
      @grid << ('A'..'Z').to_a.sample
    end
  end

  def score
    @input = params[:input]
    @grid = params[:grid].split(" ")
    result = {}
    if read(@input)["found"] == true && attempt_part_of_grid(@grid, @input).zero?
      result[:score] = @input.length
      result[:message] = "well done"
    else
      result[:score] = 0
      result[:message] = test_fail(read(@input), @input, @grid)
    end
    @score = result[:score]
    @message = result[:message]
  end

  private

  def test_fail(word, attempt, grid)
    if word["found"] != true
      return "not an english word"
    elsif attempt_part_of_grid(grid, attempt).positive?
      return "not in the grid"
    end
  end


  def read(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word_serialized = URI.open(url).read
    JSON.parse(word_serialized)
  end

  def attempt_part_of_grid(grid, attempt)
    count = 0
    attempt.upcase.chars.each do |letter|
      count += 1 unless grid.include?(letter) && grid.count(letter) >= attempt.upcase.chars.count(letter)
    end
    count
  end
end
