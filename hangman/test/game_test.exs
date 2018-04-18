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
      assert { ^game, _ } = Game.make_move(game, "x")
    end 
  end

  test "first occurance of letter is not already used" do
    game = Game.new_game()
    { game,  _ } = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "second occurance of letter is already used" do
    game = Game.new_game()
    { game,  _ } = Game.make_move(game,"x")
    assert game.game_state != :already_used
    { game,  _ } = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("wibble")
    { game,  _ } = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "guessed word wins the game" do
    new_game = Game.new_game("wibble")
    [
      {"w", :good_guess}, 
      {"i", :good_guess}, 
      {"b", :good_guess}, 
      {"l", :good_guess}, 
      {"e", :won}
    ]
    |> Enum.reduce(new_game, fn({guess,state}, game) ->
      { game,  _ } = Game.make_move(game, guess)
      assert game.game_state == state
      assert game.turns_left == 7
      game
    end)
  end

  test "bad guess is recognized" do
    game = Game.new_game("wibble")
    { game,  _ } = Game.make_move(game, "x")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "lost game is recognized" do
    new_game = Game.new_game("wibble")
    [
      {"a", :bad_guess, 6},
      {"c", :bad_guess, 5},
      {"d", :bad_guess, 4},
      {"f", :bad_guess, 3},
      {"g", :bad_guess, 2},
      {"h", :bad_guess, 1},
      {"k", :lost, 1}
    ]
    |> Enum.reduce(new_game, fn({guess, state, turns_left}, game) ->
      { game,  _ } = Game.make_move(game,guess)
      assert game.game_state == state
      assert game.turns_left == turns_left
      game
    end)
  end
  
end