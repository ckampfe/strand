defmodule Strand.Digraph do
  @moduledoc  """
  A convenience module/struct for precomputing
  the adjacencies, inbound relationships, and nodeset
  for a graph.
  """

  require MapSet, as: Set
  require Strand.Protocols.Graph, as: Graph
  require Strand.Protocols.Digraph, as: Digraph

  defstruct [:nodeset, :in, :adj]

  def new(g) do
    %Strand.Digraph{
      nodeset: Graph.nodes(g),
      adj: g |> Enum.filter(fn({_,vs}) -> !Enum.empty?(vs) end)
             |> Enum.map(fn({k,vs}) -> {k, Set.new(vs)} end)
             |> Enum.into(%{}),
      in: g |> Digraph.transpose
    }
  end

  defimpl Digraph, for: Strand.Digraph do
    def predecessors(g, n) do
      g.in |> Map.fetch!(n)
    end

    def in_degree(g, n) do
      predecessors(g, n) |> Enum.count
    end

    def in_edges(g, n) do
      Set.new(for n2 <- predecessors(g, n), do: {n2, n})
    end

    def transpose(g) do
      %Strand.Digraph{nodeset: g.nodeset,
                      adj: g.in,
                      in:  g.adj}
    end
  end
end
