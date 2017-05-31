# Strand

A library for graphs. This library is mostly an Elixir port of the amazing [Loom](https://github.com/aysylu/loom) library for Clojure.

[![Build Status](https://travis-ci.org/ckampfe/strand.svg?branch=master)](https://travis-ci.org/ckampfe/strand)

## Installation

This library is [available in Hex](https://hex.pm/packages/strand).
To install, add `strand` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:strand, "~> 0.4"}]
end
```

## Use

```elixir
iex(1)> require MapSet, as: Set
iex(2)> require Strand.Protocol.Graph, as: G
iex(3)> require Strand.Protocol.Digraph, as: DG
iex(4)> require Strand.Impl.Digraph, as: Digraph
iex(5)> require Strand.Alg, as: Alg
iex(6)> x = %{a: Set.new([]),
              b: Set.new([:a]),
              c: Set.new([:b]),
              d: Set.new([:b, :e]),
              e: Set.new([:a]),
              f: Set.new([:d, :e])}
iex(7)> G.nodes(x)
#MapSet<[:a, :b, :c, :d, :e, :f]>
iex(8)> G.edges(x)
#MapSet<[b: :a, c: :b, d: :b, d: :e, e: :a, f: :d, f: :e]>
iex(9)> G.out_degree(x, :d)
# 2
iex(10)> G.has_edge?(x, {:f, :e})
# true
iex(11)> G.out_edges(x, :f)
#MapSet<[f: :d, f: :e]>
iex(12)> G.successors(x, :f)
#MapSet<[:d, :e]>
iex(13)> G.has_node?(x, :e)
# true
iex(14)> Alg.sort_topo(x)
[:a, :b, :c, :e, :d, :f]
iex(15)> DG.predecessors(x, :b)
#MapSet<[:c, :d]>
iex(16)> DG.transpose(x)
# %{a: #MapSet<[:b, :e]>, b: #MapSet<[:c, :d]>, d: #MapSet<[:f]>,
#   e: #MapSet<[:d, :f]>}
iex(17)> DG.in_edges(x, :b)
#MapSet<[c: :b, d: :b]>
iex(18)> DG.in_degree(x, :b)
# 2
iex(19)> dg = Digraph.new(x)
# %Strand.Digraph{adj: %{b: #MapSet<[:a]>,
#                        c: #MapSet<[:b]>,
#                        d: #MapSet<[:b, :e]>,
#                        e: #MapSet<[:a]>,
#                        f: #MapSet<[:d, :e]>},
#                 in: %{a: #MapSet<[:b, :e]>,
#                       b: #MapSet<[:c, :d]>,
#                       d: #MapSet<[:f]>,
#                       e: #MapSet<[:d, :f]>},
#                 nodeset: #MapSet<[:a, :b, :c, :d, :e, :f]>}
iex(20)> dg |> DG.transpose
# %Strand.Digraph{adj: %{a: #MapSet<[:b, :e]>,
#                        b: #MapSet<[:c, :d]>,
#                        d: #MapSet<[:f]>,
#                        e: #MapSet<[:d, :f]>},
#                 in: %{b: #MapSet<[:a]>,
#                       c: #MapSet<[:b]>,
#                       d: #MapSet<[:b, :e]>,
#                       e: #MapSet<[:a]>,
#                       f: #MapSet<[:d, :e]>},
#                 nodeset: #MapSet<[:a, :b, :c, :d, :e, :f]>}
iex(21)> dg |> DG.in_degree(:b)
# 2
iex(22)> dg |> DG.in_edges(:b)
#MapSet<[c: :b, d: :b]>
iex(23)> dg |> DG.predecessors(:b)
#MapSet<[:c, :d]>
```

## License

Copyright (C) 2017 Clark Kampfe

Distributed under the Eclipse Public License.
