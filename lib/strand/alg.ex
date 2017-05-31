defmodule Strand.Alg do
  @moduledoc """
  Graph algorithms.
  """

  require MapSet, as: Set
  require Strand.Impl.Digraph, as: Digraph

  @doc """
  Return the topological order of a graph according
  to Kahn's algorithm: https://en.wikipedia.org/wiki/Topological_sorting#Kahn.27s_algorithm
  """
  def sort_topo(%Digraph{} = digraph) do
    digraph |> Digraph.to_map |> sort_topo
  end
  def sort_topo(graph) do
    kahn(graph)
  end

  defp kahn(g) do
    s = Enum.filter(g, fn({_,v}) ->
      Enum.empty?(v)
    end)

    do_kahn(g, s, [])
  end

  defp do_kahn(_, [], l) do
    l
    |> Enum.map(fn({k,_}) -> k end)
    |> Enum.reverse
  end

  defp do_kahn(g, [{nk,_} = n|sxs], l) do
    nodes_with_edges_from_n_to_m =
      Enum.filter(g, fn
        {_, %Set{} = mv} -> Set.member?(mv,nk)
        {_, mv} -> Enum.member?(mv, nk)
      end)

    with_prior_removed =
      nodes_with_edges_from_n_to_m
      |> Enum.map(fn
        {mk, %Set{} = mv} -> {mk, Set.delete(mv, nk)}
        {mk, mv} -> {mk, Enum.reject(mv, &(&1 == nk))}
      end)

    news =
      with_prior_removed
      |> Enum.filter(fn({_,mv}) ->
        Enum.empty?(mv)
      end)
      |> Enum.concat(sxs)

    new_g =
      with_prior_removed
      |> Enum.reduce(g, fn({mk, mv}, acc) ->
        Map.put(acc, mk, mv)
      end)

    do_kahn(new_g, news, [n|l])
  end
end
