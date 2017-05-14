defmodule Strand.Map do
  @moduledoc """
  Implementations of Graph and Digraph protocols for 
  Elixir's `Map`: https://hexdocs.pm/elixir/Map.html.

  This lets us model graphs as maps:

  ```
  %{a: Set.new([]),
    b: Set.new([:a]),
    c: Set.new([:b]),
    d: Set.new([:b, :e]),
    e: Set.new([:a]),
    f: Set.new([:d, :e])}
  ```
  """

  require MapSet, as: Set
  require Strand.Protocols.Graph, as: Graph
  require Strand.Protocols.Digraph, as: Digraph

  defimpl Graph, for: Map do
    def nodes(g) do
      g
      |> Map.keys
      |> Set.new()
    end

    def edges(g) do
      (for k <- Map.keys(g),
           v <- Map.fetch!(g, k),
      do: {k, v})
      |> Set.new()
    end

    def has_node?(g, n) do
      Set.member?(nodes(g), n)
    end

    def has_edge?(g, e) do
      edges(g) |> Set.member?(e)
    end

    def successors(g, n) do
      Map.fetch!(g, n)
    end

    def out_edges(g, n) do
      Set.new(for n2 <- successors(g, n), do: {n, n2})
    end

    def out_degree(g, n) do
      Set.size(out_edges(g,n))
    end
  end

  defimpl Digraph, for: Map do
    def predecessors(g, n) do
      transpose(g) |> Map.fetch!(n)
    end

    def in_degree(g, n) do
      predecessors(g, n) |> Enum.count
    end

    def in_edges(g, n) do
      Set.new(for n2 <- predecessors(g, n), do: {n2, n})
    end

    def transpose(g) do
      edges = Graph.edges(g)

      # TODO:
      # investigate better autovivification for values
      initialized_map =
        edges
        |> Enum.map(fn({_,v}) -> v end)
        |> Map.new(fn(v) -> {v, Set.new()} end)

      edges
      |> Enum.reduce(initialized_map, fn({k,v}, acc) ->
        Map.update(acc, v, Set.new(), fn(old) ->
          Set.put(old, k)
        end)
      end)
    end
  end
end
