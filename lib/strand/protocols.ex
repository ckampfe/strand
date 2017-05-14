defmodule Strand.Protocols do
  @moduledoc """
  Graph-related protocols.
  """

  defprotocol Graph do
    @doc "calculates the nodes of a graph"
    def nodes(g)

    @doc "calculates the edges of a graph"
    def edges(g)

    @doc "determines if a graph has a node"
    def has_node?(g, n)

    @doc "determines if a graph has an edge"
    def has_edge?(g, e)

    @doc "calculates a node's successors"
    def successors(g, n)

    @doc "calculates the outbound edges of a node"
    def out_edges(g, n)

    @doc "counts the outbound edges of a node"
    def out_degree(g, n)
  end

  defprotocol Digraph do
    @doc "calculates the nodes that precede a node"
    def predecessors(g, n)

    @doc "counts the inbound edges of a node"
    def in_degree(g, n)

    @doc "calculates the inbound edges of a node"
    def in_edges(g, n)

    @doc "reverses a directed graph"
    def transpose(g)
  end
end
