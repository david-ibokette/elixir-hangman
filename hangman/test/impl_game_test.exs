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
      # assert tally.letters == []
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
    {game, _tally} = Game.make_move(game, "a")
    assert game.game_state == :already_used
    {game, _tally} = Game.make_move(game, "z")
    assert game.game_state == :bad_guess
    {game, _tally} = Game.make_move(game, "t")
    assert game.game_state == :won
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
    assert game.game_state == :bad_guess
    {game, _tally} = Game.make_move(game, "l")
    assert game.game_state == :bad_guess
    {game, _tally} = Game.make_move(game, "m")
    assert game.game_state == :bad_guess
    {game, _tally} = Game.make_move(game, "l")
    assert game.game_state == :already_used
    {game, _tally} = Game.make_move(game, "n")
    assert game.game_state == :bad_guess
    {game, _tally} = Game.make_move(game, "o")
    assert game.game_state == :bad_guess
    {game, _tally} = Game.make_move(game, "p")
    assert game.game_state == :lost
    {game, _tally} = Game.make_move(game, "p")
    assert game.game_state == :lost
  end

  test "whole won imperfect game, repeat letters" do
    game = Game.new_game("hello")
    { game, _tally } = Game.make_move(game, "h")
    assert game.game_state == :good_guess
    {game, _tally} = Game.make_move(game, "o")
    assert game.game_state == :good_guess
    {game, _tally} = Game.make_move(game, "h")
    assert game.game_state == :already_used
    {game, _tally} = Game.make_move(game, "z")
    assert game.game_state == :bad_guess
    {game, _tally} = Game.make_move(game, "l")
    assert game.game_state == :good_guess
    {game, _tally} = Game.make_move(game, "l")
    # Enum.each(game.used, fn x -> IO.puts(x) end)
    assert game.game_state == :already_used
    {game, _tally} = Game.make_move(game, "e")
    assert game.game_state == :won
    {game, _tally} = Game.make_move(game, "e")
    assert game.game_state == :won

    assert MapSet.equal?(game.used, MapSet.new(["h", "e", "l", "o", "z"]))
  end

  test "sequence of moves hello" do
    [
      ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["a", :already_used, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["e", :good_guess, 6, ["_", "e", "_", "_", "_"], ["a", "e"]],
      ["x", :bad_guess, 5, ["_", "e", "_", "_", "_"], ["a", "e", "x"]],
    ]
    |> test_moves("hello")
  end

  test "sequence of moves cat" do
    [
      ["c", :good_guess, 7, ["c", "_", "_"], ["c"]],
      ["e", :bad_guess, 6, ["c", "_", "_"], ["c", "e"]],
      ["a", :good_guess, 6, ["c", "a", "_"], ["c", "e", "a"]],
      ["x", :bad_guess, 5, ["c", "a", "_"], ["c", "e", "a", "x"]],
      ["a", :already_used, 5, ["c", "a", "_"], ["c", "e", "a", "x"]],
      ["t", :won, 5, ["c", "a", "t"], ["c", "e", "a", "x", "t"]],
      ["t", :won, 5, ["c", "a", "t"], ["c", "e", "a", "x", "t"]],
    ]
    |> test_moves("cat")
  end

  test "sequence of moves cat loser" do
    [
      ["c", :good_guess, 7, ["c", "_", "_"], ["c"]],
      ["z", :bad_guess, 6, ["c", "_", "_"], ["c", "z"]],
      ["a", :good_guess, 6, ["c", "a", "_"], ["c", "z", "a"]],
      ["x", :bad_guess, 5, ["c", "a", "_"], ["c", "z", "a", "x"]],
      ["a", :already_used, 5, ["c", "a", "_"], ["c", "z", "a", "x"]],
      ["e", :bad_guess, 4, ["c", "a", "_"], ["c", "z", "a", "x", "e"]],
      ["f", :bad_guess, 3, ["c", "a", "_"], ["c", "z", "a", "x", "e", "f"]],
      ["g", :bad_guess, 2, ["c", "a", "_"], ["c", "z", "a", "x", "e", "f", "g"]],
      ["h", :bad_guess, 1, ["c", "a", "_"], ["c", "z", "a", "x", "e", "f", "g", "h"]],
      ["i", :lost, 0, ["c", "a", "_"], ["c", "z", "a", "x", "e", "f", "g", "h", "i"]],
    ]
    |> test_moves("cat")
  end

  def test_moves(script, word) do
    game = Game.new_game(word)
    Enum.reduce(script, game, &check_one_move/2)
  end

  def check_one_move([guess, state, turns_left, letters, used], game) do
    {game, tally} = Game.make_move(game, guess)
    assert tally.game_state == state
    assert tally.turns_left == turns_left
    assert tally.letters == letters
    assert MapSet.equal?(MapSet.new(tally.used), MapSet.new(used))
    game
  end
end
