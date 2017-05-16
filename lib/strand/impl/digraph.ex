defmodule Strand.Impl.Digraph do
  @moduledoc  """
  A convenience module/struct for precomputing
  the adjacencies, inbound relationships, and nodeset
  for a graph.
  """

  require MapSet, as: Set
  require Strand.Protocol.{Graph, Digraph}

  defstruct [:nodeset, :in, :adj]

  def new(g) do
    %Strand.Impl.Digraph{
      nodeset: Strand.Protocol.Graph.nodes(g),
      adj: g |> Enum.filter(fn({_,vs}) -> !Enum.empty?(vs) end)
             |> Enum.map(fn({k,vs}) -> {k, Set.new(vs)} end)
             |> Enum.into(%{}),
      in: g |> Strand.Protocol.Digraph.transpose
    }
  end

  defimpl Strand.Protocol.Digraph, for: Strand.Impl.Digraph do
    def predecessors(dg, n) do
      dg.in |> Map.fetch!(n)
    end

    def in_degree(dg, n) do
      predecessors(dg, n) |> Enum.count
    end

    def in_edges(dg, n) do
      Set.new(for n2 <- predecessors(dg, n), do: {n2, n})
    end

    def transpose(dg) do
      %Strand.Impl.Digraph{nodeset: dg.nodeset,
                           adj: dg.in,
                           in: dg.adj}
    end
  end
end
