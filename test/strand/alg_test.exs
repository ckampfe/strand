defmodule AlgTest do
  use ExUnit.Case, async: true
  require MapSet, as: Set
  require Strand.Alg, as: Alg

  setup do
    g1 =
      %{a: Set.new([]),
        b: Set.new([:a]),
        c: Set.new([:b])
      }

    g2 =
      %{a: Set.new([]),
        b: Set.new([:a]),
        c: Set.new([:b]),
        d: Set.new([:b, :e]),
        e: Set.new([:a]),
        f: Set.new([:d, :e])
      }

    g3 =
      %{a: Set.new([:b, :c]),
        b: Set.new([:c, :d]),
        c: Set.new([:e, :f]),
        d: Set.new([]),
        e: Set.new([:d]),
        f: Set.new([:e]),
        g: Set.new([:a, :f])}

    # TODO: implement sort_topo for Digrpah
    # dg1 = Strand.Digraph.new(g1)
    # dg2 = Strand.Digraph.new(g2)
    # dg3 = Strand.Digraph.new(g3)

    %{g1: g1,
      g2: g2,
      g3: g3#,
      # dg1: dg1,
      # dg2: dg2,
      # dg3: dg3
    }
  end

  test "it sorts maps", context do
    assert Alg.sort_topo(context[:g1]) == [:a, :b, :c]
    assert Alg.sort_topo(context[:g2]) == [:a, :b, :c, :e, :d, :f]
    assert Alg.sort_topo(context[:g3]) == [:d, :e, :f, :c, :b, :a, :g]
  end

  # TODO: implement sort_topo for Digrpah
  # test "it sorts Digraphs", context do
  #   assert Alg.sort_topo(context[:dg1]) == [:a, :b, :c]
  #   assert Alg.sort_topo(context[:dg2]) == [:a, :b, :c, :e, :d, :f]
  #   assert Alg.sort_topo(context[:dg3]) == [:d, :e, :f, :c, :b, :a, :g]
  # end
end
