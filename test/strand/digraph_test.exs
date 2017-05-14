defmodule DigraphTest do
  use ExUnit.Case, async: true
  require MapSet, as: Set
  require Strand.Protocols.Digraph, as: DG

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

  test "it determines predecessors for maps", context do
    assert DG.predecessors(context[:g1], :b) == Set.new([:c])
    assert DG.predecessors(context[:g2], :e) == Set.new([:d, :f])
    assert DG.predecessors(context[:g3], :f) == Set.new([:c, :g])
  end

  test "it determines in_edges for maps", context do
    assert DG.in_edges(context[:g1], :b) == Set.new([{:c, :b}])
    assert DG.in_edges(context[:g2], :b) == Set.new([{:c, :b}, {:d, :b}])
    assert DG.in_edges(context[:g3], :f) == Set.new([{:c, :f}, {:g, :f}])
  end

  test "it determines in_degree for maps", context do
    assert DG.in_degree(context[:g1], :b) == 1
    assert DG.in_degree(context[:g2], :b) == 2
    assert DG.in_degree(context[:g3], :f) == 2
  end

  test "it transposes (reverses) maps", context do
    assert DG.transpose(context[:g1]) == %{a: Set.new([:b]),
                                           b: Set.new([:c])}
    assert DG.transpose(context[:g2]) == %{a: Set.new([:b, :e]),
                                           b: Set.new([:c, :d]),
                                           d: Set.new([:f]),
                                           e: Set.new([:d, :f])}
    assert DG.transpose(context[:g3]) == %{a: Set.new([:g]),
                                           b: Set.new([:a]),
                                           c: Set.new([:a, :b]),
                                           d: Set.new([:b, :e]),
                                           e: Set.new([:c, :f]),
                                           f: Set.new([:c, :g])}
  end

  test "it creates new Digraphs", context do
    assert Strand.Digraph.new(context[:g1]) == %Strand.Digraph{
      nodeset: Set.new([:a, :b, :c]),
      adj: %{b: Set.new([:a]), c: Set.new([:b])},
      in: %{a: Set.new([:b]), b: Set.new([:c])},
    }

    assert Strand.Digraph.new(context[:g2]) == %Strand.Digraph{
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

    assert Strand.Digraph.new(context[:g3]) == %Strand.Digraph{
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
    assert DG.predecessors(context[:dg1], :b) == Set.new([:c])
    assert DG.predecessors(context[:dg2], :e) == Set.new([:d, :f])
    assert DG.predecessors(context[:dg3], :f) == Set.new([:c, :g])
  end

  test "it determines in_edges for Digraphs", context do
    assert DG.in_edges(context[:dg1], :b) == Set.new([{:c, :b}])
    assert DG.in_edges(context[:dg2], :b) == Set.new([{:c, :b}, {:d, :b}])
    assert DG.in_edges(context[:dg3], :f) == Set.new([{:c, :f}, {:g, :f}])
  end

  test "it determines in_degree for Digraphs", context do
    assert DG.in_degree(context[:dg1], :b) == 1
    assert DG.in_degree(context[:dg2], :b) == 2
    assert DG.in_degree(context[:dg3], :f) == 2
  end

  test "it transposes (reverses) Digraphs", context do
    dg1_reversed = DG.transpose(context[:dg1])
    dg2_reversed = DG.transpose(context[:dg2])
    dg3_reversed = DG.transpose(context[:dg3])

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
end
