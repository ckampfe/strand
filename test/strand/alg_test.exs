defmodule AlgTest do
  use ExUnit.Case, async: true
  require MapSet, as: Set
  require Strand.Alg, as: Alg
  doctest Strand.Alg

  setup do
    g1 =
      %{a: Set.new([]),
        b: Set.new([:a]),
        c: Set.new([:b])}

    g2 =
      %{a: Set.new([]),
        b: Set.new([:a]),
        c: Set.new([:b]),
        d: Set.new([:b, :e]),
        e: Set.new([:a]),
        f: Set.new([:d, :e])}

    g3 =
      %{a: Set.new([:b, :c]),
        b: Set.new([:c, :d]),
        c: Set.new([:e, :f]),
        d: Set.new([]),
        e: Set.new([:d]),
        f: Set.new([:e]),
        g: Set.new([:a, :f])}

    gl1 =
      %{a: [],
        b: [:a],
        c: [:b]}

    gl2 =
      %{a: [],
        b: [:a],
        c: [:b],
        d: [:b, :e],
        e: [:a],
        f: [:d, :e]}

    gl3 =
      %{a: [:b, :c],
        b: [:c, :d],
        c: [:e, :f],
        d: [],
        e: [:d],
        f: [:e],
        g: [:a, :f]}

    dg1 = Strand.Impl.Digraph.new(g1)
    dg2 = Strand.Impl.Digraph.new(g2)
    dg3 = Strand.Impl.Digraph.new(g3)

    %{g1: g1,
      g2: g2,
      g3: g3,
      gl1: gl1,
      gl2: gl2,
      gl3: gl3,
      dg1: dg1,
      dg2: dg2,
      dg3: dg3
    }
  end

  test "it sorts maps", context do
    assert Alg.sort_topo(context[:g1]) == [:a, :b, :c]
    assert Alg.sort_topo(context[:g2]) == [:a, :b, :c, :e, :d, :f]
    assert Alg.sort_topo(context[:g3]) == [:d, :e, :f, :c, :b, :a, :g]
    assert Alg.sort_topo(context[:gl1]) == [:a, :b, :c]
    assert Alg.sort_topo(context[:gl2]) == [:a, :b, :c, :e, :d, :f]
    assert Alg.sort_topo(context[:gl3]) == [:d, :e, :f, :c, :b, :a, :g]
  end

  test "it sorts Digraphs", context do
    assert Alg.sort_topo(context[:dg1]) == [:a, :b, :c]
    assert Alg.sort_topo(context[:dg2]) == [:a, :b, :c, :e, :d, :f]
    assert Alg.sort_topo(context[:dg3]) == [:d, :e, :f, :c, :b, :a, :g]
  end
end
