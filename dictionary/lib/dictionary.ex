defmodule Dictionary do
  def hello do
    IO.puts "Hello world!!!"
  end

  def word_list() do
    "assets/words.txt"
    |> File.read!()
    |> String.split(~r/\n/)    
  end

  def random_word() do
    word_list()
    |> Enum.random()
  end
end
