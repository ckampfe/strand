defmodule DigraphTest do
  use ExUnit.Case, async: true
  require MapSet, as: Set
  require Strand.Protocol.Digraph, as: Digraph
  doctest Strand.Protocol.Digraph.Map

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

    dg1 = Strand.Impl.Digraph.new(g1)
    dg2 = Strand.Impl.Digraph.new(g2)
    dg3 = Strand.Impl.Digraph.new(g3)

    %{g1: g1,
      g2: g2,
      g3: g3,
      dg1: dg1,
      dg2: dg2,
      dg3: dg3}
  end

  test "it determines predecessors for maps", context do
    assert Digraph.predecessors(context[:g1], :b) == Set.new([:c])
    assert Digraph.predecessors(context[:g2], :e) == Set.new([:d, :f])
    assert Digraph.predecessors(context[:g3], :f) == Set.new([:c, :g])
  end

  test "it determines in_edges for maps", context do
    assert Digraph.in_edges(context[:g1], :b) == Set.new([{:c, :b}])
    assert Digraph.in_edges(context[:g2], :b) == Set.new([{:c, :b}, {:d, :b}])
    assert Digraph.in_edges(context[:g3], :f) == Set.new([{:c, :f}, {:g, :f}])
  end

  test "it determines in_degree for maps", context do
    assert Digraph.in_degree(context[:g1], :b) == 1
    assert Digraph.in_degree(context[:g2], :b) == 2
    assert Digraph.in_degree(context[:g3], :f) == 2
  end

  test "it transposes (reverses) maps", context do
    assert Digraph.transpose(context[:g1]) == %{a: Set.new([:b]),
                                                b: Set.new([:c])}
    assert Digraph.transpose(context[:g2]) == %{a: Set.new([:b, :e]),
                                                b: Set.new([:c, :d]),
                                                d: Set.new([:f]),
                                                e: Set.new([:d, :f])}
    assert Digraph.transpose(context[:g3]) == %{a: Set.new([:g]),
                                                b: Set.new([:a]),
                                                c: Set.new([:a, :b]),
                                                d: Set.new([:b, :e]),
                                                e: Set.new([:c, :f]),
                                                f: Set.new([:c, :g])}
  end

  test "it creates new Digraphs", context do
    assert Strand.Impl.Digraph.new(context[:g1]) == %Strand.Impl.Digraph{
      nodeset: Set.new([:a, :b, :c]),
      adj: %{b: Set.new([:a]), c: Set.new([:b])},
      in: %{a: Set.new([:b]), b: Set.new([:c])},
    }

    assert Strand.Impl.Digraph.new(context[:g2]) == %Strand.Impl.Digraph{
      nodeset: Set.new([:a, :b, :c, :d, :e, :f]),
      adj: %{b: Set.new([:a]),
             c: Set.new([:b]),
             d: Set.new([:b, :e]),
             e: Set.new([:a]),
             f: Set.new([:d, :e])},
      in: %{a: Set.new([:b, :e]),
            b: Set.new([:c, :d]),
            d: Set.new([:f]),
            e: Set.new([:d, :f])}
    }

    assert Strand.Impl.Digraph.new(context[:g3]) == %Strand.Impl.Digraph{
      nodeset: Set.new([:a, :b, :c, :d, :e, :f, :g]),
      adj: %{a: Set.new([:b, :c]),
             b: Set.new([:c, :d]),
             c: Set.new([:e, :f]),
             e: Set.new([:d]),
             f: Set.new([:e]),
             g: Set.new([:a, :f])},
      in: %{a: Set.new([:g]),
            b: Set.new([:a]),
            c: Set.new([:a, :b]),
            d: Set.new([:b, :e]),
            e: Set.new([:c, :f]),
            f: Set.new([:c, :g])}
    }
  end

  test "it determines predecessors for Digraphs", context do
    assert Digraph.predecessors(context[:dg1], :b) == Set.new([:c])
    assert Digraph.predecessors(context[:dg2], :e) == Set.new([:d, :f])
    assert Digraph.predecessors(context[:dg3], :f) == Set.new([:c, :g])
  end

  test "it determines in_edges for Digraphs", context do
    assert Digraph.in_edges(context[:dg1], :b) == Set.new([{:c, :b}])
    assert Digraph.in_edges(context[:dg2], :b) == Set.new([{:c, :b}, {:d, :b}])
    assert Digraph.in_edges(context[:dg3], :f) == Set.new([{:c, :f}, {:g, :f}])
  end

  test "it determines in_degree for Digraphs", context do
    assert Digraph.in_degree(context[:dg1], :b) == 1
    assert Digraph.in_degree(context[:dg2], :b) == 2
    assert Digraph.in_degree(context[:dg3], :f) == 2
  end

  test "it transposes (reverses) Digraphs", context do
    dg1_reversed = Digraph.transpose(context[:dg1])
    dg2_reversed = Digraph.transpose(context[:dg2])
    dg3_reversed = Digraph.transpose(context[:dg3])

    assert dg1_reversed.nodeset == context[:dg1].nodeset
    assert dg1_reversed.in == context[:dg1].adj
    assert dg1_reversed.adj == context[:dg1].in

    assert dg2_reversed.nodeset == context[:dg2].nodeset
    assert dg2_reversed.in == context[:dg2].adj
    assert dg2_reversed.adj == context[:dg2].in

    assert dg3_reversed.nodeset == context[:dg3].nodeset
    assert dg3_reversed.in == context[:dg3].adj
    assert dg3_reversed.adj == context[:dg3].in
  end

  test "it gets a map out of a Digraph", context do
    assert Strand.Impl.Digraph.to_map(context[:dg1]) == context[:g1]
    assert Strand.Impl.Digraph.to_map(context[:dg2]) == context[:g2]
    assert Strand.Impl.Digraph.to_map(context[:dg3]) == context[:g3]
  end
end
