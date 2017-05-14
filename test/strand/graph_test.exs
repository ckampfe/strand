defmodule GraphTest do
  use ExUnit.Case, async: true
  require MapSet, as: Set
  require Strand.Protocols.Graph, as: G

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

    dg1 = Strand.Digraph.new(g1)
    dg2 = Strand.Digraph.new(g2)
    dg3 = Strand.Digraph.new(g3)

    %{g1: g1,
      g2: g2,
      g3: g3,
      dg1: dg1,
      dg2: dg2,
      dg3: dg3}
  end

  test "it has nodes for maps", context do
    assert G.nodes(context[:g1]) == Set.new([:a, :b, :c])
    assert G.nodes(context[:g2]) == Set.new([:a, :b, :c, :d, :e, :f])
    assert G.nodes(context[:g3]) == Set.new([:a, :b, :c, :d, :e, :f, :g])
  end

  test "it has edges for maps", context do
    assert G.edges(context[:g1]) ==
      Set.new([{:b, :a}, {:c, :b}])

    assert G.edges(context[:g2]) ==
      Set.new([{:b, :a},
               {:c, :b},
               {:d, :b},
               {:d, :e},
               {:e, :a},
               {:f, :d},
               {:f, :e}])

    assert G.edges(context[:g3]) ==
      Set.new([{:a, :b},
               {:a, :c},
               {:b, :c},
               {:b, :d},
               {:c, :e},
               {:c, :f},
               {:e, :d},
               {:f, :e},
               {:g, :a},
               {:g, :f}])
  end

  test "it finds determines node membership for maps", context do
    assert G.has_node?(context[:g1], :a) == true
    assert G.has_node?(context[:g2], :z) == false
    assert G.has_node?(context[:g3], :d) == true
  end

  test "it determines edge membership for maps", context do
    assert G.has_edge?(context[:g1], {:b, :a}) == true
    assert G.has_edge?(context[:g2], {:x, :z}) == false
    assert G.has_edge?(context[:g3], {:g, :f}) == true
  end

  test "it determines out_edges for maps", context do
    assert G.out_edges(context[:g1], :b) == Set.new([{:b, :a}])
    assert G.out_edges(context[:g2], :e) == Set.new([{:e, :a}])
    assert G.out_edges(context[:g3], :f) == Set.new([{:f, :e}])
  end

  test "it determines out_degree for maps", context do
    assert G.out_degree(context[:g1], :b) == 1
    assert G.out_degree(context[:g2], :e) == 1
    assert G.out_degree(context[:g3], :g) == 2
  end
end
