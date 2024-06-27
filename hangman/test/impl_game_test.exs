defmodule ImplGameTest do
  use ExUnit.Case
  alias Hangman.Impl.Game

  test "new game return structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0

  end

  test "new game returns correct word" do
    game = Game.new_game("doctor")

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
    assert game.letters == ["d","o", "c", "t", "o", "r"]

  end

  test "all letters lc" do
    game = Game.new_game()
    game.letters |> Enum.each(fn x -> assert x == String.downcase(x) end)
  end

  test "make move on won game returns same won game" do
    game = Game.new_game("doctor")
    game = Map.put(game, :game_state, :won)
    {new_game, _tally} = Game.make_move(game, "x")
    assert new_game == game
  end

  test "make move on lost game returns same won game" do
    game = Game.new_game("doctor")
    game = Map.put(game, :game_state, :lost)
    {new_game, _tally} = Game.make_move(game, "x")
    assert new_game == game
  end

  test "make move on lost game returns same won or lost game" do
    for state <- [:won, :lost] do
      game = Game.new_game("doctor")
      game = Map.put(game, :game_state, state)
      {new_game, tally} = Game.make_move(game, "x")

      assert new_game.turns_left == game.turns_left
      assert new_game.game_state == game.game_state
      assert new_game.letters == game.letters
      assert new_game.used == game.used
      assert tally.turns_left == game.turns_left
      assert tally.game_state == game.game_state
      assert tally.letters == []
      assert tally.used == game.used |> MapSet.to_list() |> Enum.sort
    end
  end

  @tag mustexec: true
  test "make move already used letter" do
    game = Game.new_game("doctor")
    { game, _tally } = Game.make_move(game, "d")
    assert game.game_state == :good_guess
    {game, _tally} = Game.make_move(game, "d")
    assert game.game_state == :already_used
    assert MapSet.equal?(game.used, MapSet.new(["d"]))
  end

  test "make move not used letter" do
    game = Game.new_game("doctor")
    { game, _tally } = Game.make_move(game, "d")
    assert game.game_state == :good_guess
    {game, _tally} = Game.make_move(game, "o")
    assert game.game_state == :good_guess

    assert MapSet.equal?(game.used, MapSet.new(["d", "o"]))
  end

  test "make move bad letter" do
    game = Game.new_game("doctor")
    { game, _tally } = Game.make_move(game, "d")
    assert game.game_state == :good_guess
    {game, _tally} = Game.make_move(game, "z")
    assert game.game_state == :bad_guess

    assert MapSet.equal?(game.used, MapSet.new(["d", "z"]))
  end

  test "whole won perfect game" do
    game = Game.new_game("cat")
    { game, _tally } = Game.make_move(game, "c")
    assert game.game_state == :good_guess
    {game, _tally} = Game.make_move(game, "a")
    assert game.game_state == :good_guess
    {game, _tally} = Game.make_move(game, "t")
    assert game.game_state == :won

    assert MapSet.equal?(game.used, MapSet.new(["c", "a", "t"]))
  end

  test "whole won imperfect game" do
    game = Game.new_game("cat")
    { game, _tally } = Game.make_move(game, "c")
    assert game.game_state == :good_guess
    {game, _tally} = Game.make_move(game, "a")
    assert game.game_state == :good_guess
    {game, _tally} = Game.make_move(game, "z")
    assert game.game_state == :bad_guess
    {game, _tally} = Game.make_move(game, "t")
    assert game.game_state == :won

    assert MapSet.equal?(game.used, MapSet.new(["c", "a", "z", "t"]))
  end

  test "whole lost game" do
    game = Game.new_game("cat")
    { game, _tally } = Game.make_move(game, "c")
    assert game.game_state == :good_guess
    {game, _tally} = Game.make_move(game, "a")
    assert game.game_state == :good_guess
    {game, _tally} = Game.make_move(game, "z")
    assert game.game_state == :bad_guess
    {game, _tally} = Game.make_move(game, "k")
    {game, _tally} = Game.make_move(game, "l")
    {game, _tally} = Game.make_move(game, "m")
    {game, _tally} = Game.make_move(game, "n")
    {game, _tally} = Game.make_move(game, "o")
    {game, _tally} = Game.make_move(game, "p")
    assert game.game_state == :lost
  end
end
