defmodule Strand.Impl.Map do
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
  alias Strand.Protocol.{Graph, Digraph, Viewable}

  defimpl Graph, for: Map do
    @doc """
    ## Examples

        iex> alias Strand.Protocol.Graph
        iex> g = %{a: [], b: [:a], c: [:d, :a], d: [:a, :b]}
        iex> Graph.nodes(g)
        #MapSet<[:a, :b, :c, :d]>
    """
    def nodes(g) do
      g
      |> Map.keys
      |> Set.new()
    end

    @doc """
    ## Examples

        iex> alias Strand.Protocol.Graph
        iex> g = %{a: [], b: [:a], c: [:d, :a], d: [:a, :b]}
        iex> Graph.edges(g)
        #MapSet<[b: :a, c: :a, c: :d, d: :a, d: :b]>
    """
    def edges(g) do
      (for k <- Map.keys(g),
           v <- Map.fetch!(g, k),
      do: {k, v})
      |> Set.new()
    end

    @doc """
    ## Examples

        iex> alias Strand.Protocol.Graph
        iex> g = %{a: [], b: [:a], c: [:d, :a], d: [:a, :b]}
        iex> Graph.has_node?(g, :d)
        true

        iex> g = %{a: [], b: [:a], c: [:d, :a], d: [:a, :b]}
        iex> Graph.has_node?(g, :z)
        false
    """
    def has_node?(g, n) do
      Set.member?(nodes(g), n)
    end

    @doc """
    ## Examples

        iex> alias Strand.Protocol.Graph
        iex> g = %{a: [], b: [:a], c: [:d, :a], d: [:a, :b]}
        iex> Graph.has_edge?(g, {:b, :a})
        true

        iex> g = %{a: [], b: [:a], c: [:d, :a], d: [:a, :b]}
        iex> Graph.has_edge?(g, {:b, :z})
        false
    """
    def has_edge?(g, e) do
      edges(g) |> Set.member?(e)
    end

    @doc """
    ## Examples

        iex> alias Strand.Protocol.Graph
        iex> g = %{a: [], b: [:a], c: [:d, :a], d: [:a, :b]}
        iex> Graph.successors(g, :c)
        [:d, :a]
    """
    def successors(g, n) do
      Map.fetch!(g, n)
    end

    @doc """
    ## Examples

        iex> alias Strand.Protocol.Graph
        iex> g = %{a: [], b: [:a], c: [:d, :a], d: [:a, :b]}
        iex> Graph.out_edges(g, :c)
        #MapSet<[c: :a, c: :d]>
    """
    def out_edges(g, n) do
      Set.new(for n2 <- successors(g, n), do: {n, n2})
    end

    @doc """
    ## Examples

        iex> alias Strand.Protocol.Graph
        iex> g = %{a: [], b: [:a], c: [:d, :a], d: [:a, :b]}
        iex> Graph.out_degree(g, :c)
        2
    """
    def out_degree(g, n) do
      Set.size(out_edges(g,n))
    end
  end

  defimpl Digraph, for: Map do
    @doc """
    ## Examples

        iex> alias Strand.Protocol.Digraph
        iex> g = %{a: [], b: [:a], c: [:d, :a], d: [:a, :b]}
        iex> Digraph.predecessors(g, :a)
        #MapSet<[:b, :c, :d]>
    """
    def predecessors(g, n) do
      transpose(g) |> Map.fetch!(n)
    end

    @doc """
    ## Examples

        iex> alias Strand.Protocol.Digraph
        iex> g = %{a: [], b: [:a], c: [:d, :a], d: [:a, :b]}
        iex> Digraph.in_degree(g, :a)
        3
    """
    def in_degree(g, n) do
      predecessors(g, n) |> Enum.count
    end

    @doc """
    ## Examples

        iex> alias Strand.Protocol.Digraph
        iex> g = %{a: [], b: [:a], c: [:d, :a], d: [:a, :b]}
        iex> Digraph.in_edges(g, :a)
        #MapSet<[b: :a, c: :a, d: :a]>
    """
    def in_edges(g, n) do
      Set.new(for n2 <- predecessors(g, n), do: {n2, n})
    end

    @doc """
    ## Examples

        iex> alias Strand.Protocol.Digraph
        iex> g = %{a: [], b: [:a], c: [:d, :a], d: [:a, :b]}
        iex> Digraph.transpose(g)
        %{a: Enum.into([:b, :c, :d], MapSet.new), b: Enum.into([:d], MapSet.new), d: Enum.into([:c], MapSet.new)}
    """
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

  defimpl Viewable, for: Map do
    def format_for_mix_utils_dot(g) do
      Enum.map(
        g,
        fn({k,vs}) -> {
          k,
          Enum.map(
          vs, fn(v) ->
            {v, []}
          end)}
        end
      )
    end
  end
end
