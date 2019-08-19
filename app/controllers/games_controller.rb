require 'json'
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = []
    alphabet_array = ("A".."Z").to_a
    10.times {
      @letters.push(alphabet_array.sample)
    }
  end

  def score
    @letters = params[:grid]
    @word = params[:word]
    # first test - "The word can't be built out of the original grid"
    @word.split("").each do |letter|
      if @letters.include?(letter.upcase)
        @result = "yes"
        # second test - Is a valid English word
        filepath = open("https://wagon-dictionary.herokuapp.com/#{@word}")

        word_hash = JSON.parse(filepath.read)
        # if word is valid word
        if word_hash["found"] == true
          return @result = "Congratulations! #{@word.upcase} is a valid English word!"
        # else sorry not a valid word
        else
          return @result = "Sorry but #{@word.upcase} does not seem to be a valid English word!"
        end

      else
        return @result = "Sorry but #{@word.upcase} can't be built out of #{@letters[0...-1].gsub(/([A-Z])/, '\1, ') + @letters[-1]}"
      end
    end
  end
end
