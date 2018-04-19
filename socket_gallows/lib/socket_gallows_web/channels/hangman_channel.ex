defmodule SocketGallowsWeb.HangmanChannel do
  use Phoenix.Channel

  require Logger

  def join("hangman:game", _, socket) do
    game = Hangman.new_game()    
    { :ok, assign(socket, :game, game) }
  end

  def handle_in("tally", _, socket) do
    game = socket.assigns.game
    tally = Hangman.tally(game)
    push(socket,"tally", tally)
    {:noreply, socket}
  end

  def handle_in(req,_,socket) do
    Logger.error("Unknow request from client #{req}")
    {:noreply, socket}
  end
end