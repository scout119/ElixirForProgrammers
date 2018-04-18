defmodule GameTest do
  use ExUnit.Case

  alias Hangman.Game

  test "new_game returns structure" do
    game = Game.new_game()
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters |> length > 0    
  end

  test "state isn't changed for :won or :lost game" do
    for state <- [:won, :lost] do
      game = Game.new_game() |> Map.put(:game_state, state)
      assert ^game = Game.make_move(game, "x")
    end 
  end

  test "first occurance of letter is not already used" do
    game = Game.new_game()
    game = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "second occurance of letter is already used" do
    game = Game.new_game()
    game = Game.make_move(game,"x")
    assert game.game_state != :already_used
    game = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("wibble")
    game = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "guessed word wins the game" do
    game = Game.new_game("wibble")
    [
      {"w", :good_guess}, 
      {"i", :good_guess}, 
      {"b", :good_guess}, 
      {"l", :good_guess}, 
      {"e", :won}
    ]
    |> Enum.reduce(game, fn({guess,state}, new_game) ->
      new_game = Game.make_move(new_game, guess)
      assert new_game.game_state == state
      assert new_game.turns_left == 7
      new_game
    end)
  end

  test "bad guess is recognized" do
    game = Game.new_game("wibble")
    game = Game.make_move(game, "x")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "lost game is recognized" do
    game = Game.new_game("wibble")
    [
      {"a", :bad_guess, 6},
      {"c", :bad_guess, 5},
      {"d", :bad_guess, 4},
      {"f", :bad_guess, 3},
      {"g", :bad_guess, 2},
      {"h", :bad_guess, 1},
      {"k", :lost, 1}
    ]
    |> Enum.reduce(game, fn({guess, state, turns_left}, new_game) ->
      new_game = Game.make_move(new_game,guess)
      assert new_game.game_state == state
      assert new_game.turns_left == turns_left
      new_game
    end)
  end
  
end