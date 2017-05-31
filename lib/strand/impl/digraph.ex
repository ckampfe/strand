defmodule Strand.Impl.Digraph do
  @moduledoc  """
  A convenience module/struct for precomputing
  the adjacencies, inbound relationships, and nodeset
  for a graph.
  """

  require MapSet, as: Set
  require Strand.Protocol.{Graph, Digraph, Viewable}

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

  def to_map(g) do
    adj_nodes = g.adj |> Map.keys |> Set.new()
    [start_key|_] = Set.difference(g.nodeset, adj_nodes) |> Set.to_list

    Map.put(g.adj, start_key, Set.new())
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

  defimpl Strand.Protocol.Viewable, for: Strand.Impl.Digraph do
    def format_for_mix_utils_dot(g) do
      g
      |> Strand.Impl.Digraph.to_map
      |> Strand.Protocol.Viewable.format_for_mix_utils_dot
    end
  end
end
