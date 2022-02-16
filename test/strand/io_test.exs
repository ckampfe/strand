defmodule IOTest do
  use ExUnit.Case, async: true
  require MapSet, as: Set
  alias Strand.Protocol.Viewable

  setup do
    g1 = %{a: Set.new([]), b: Set.new([:a]), c: Set.new([:b])}

    g2 = %{
      a: Set.new([]),
      b: Set.new([:a]),
      c: Set.new([:b]),
      d: Set.new([:b, :e]),
      e: Set.new([:a]),
      f: Set.new([:d, :e])
    }

    g3 = %{
      a: Set.new([:b, :c]),
      b: Set.new([:c, :d]),
      c: Set.new([:e, :f]),
      d: Set.new([]),
      e: Set.new([:d]),
      f: Set.new([:e]),
      g: Set.new([:a, :f])
    }

    dg1 = Strand.Impl.Digraph.new(g1)
    dg2 = Strand.Impl.Digraph.new(g2)
    dg3 = Strand.Impl.Digraph.new(g3)

    %{g1: g1, g2: g2, g3: g3, dg1: dg1, dg2: dg2, dg3: dg3}
  end

  test "it formats for Mix.Util.write_dot_graph! for maps", context do
    assert Viewable.format_for_mix_utils_dot(context[:g1]) == [
             a: [],
             b: [a: []],
             c: [b: []]
           ]

    assert Viewable.format_for_mix_utils_dot(context[:g2]) == [
             a: [],
             b: [a: []],
             c: [b: []],
             d: [b: [], e: []],
             e: [a: []],
             f: [d: [], e: []]
           ]

    assert Viewable.format_for_mix_utils_dot(context[:g3]) == [
             a: [b: [], c: []],
             b: [c: [], d: []],
             c: [e: [], f: []],
             d: [],
             e: [d: []],
             f: [e: []],
             g: [a: [], f: []]
           ]
  end

  test "it formats for Mix.Util.write_dot_graph! for Digraphs", context do
    assert Viewable.format_for_mix_utils_dot(context[:dg1]) == [
             a: [],
             b: [a: []],
             c: [b: []]
           ]

    assert Viewable.format_for_mix_utils_dot(context[:dg2]) == [
             a: [],
             b: [a: []],
             c: [b: []],
             d: [b: [], e: []],
             e: [a: []],
             f: [d: [], e: []]
           ]

    assert Viewable.format_for_mix_utils_dot(context[:dg3]) == [
             a: [b: [], c: []],
             b: [c: [], d: []],
             c: [e: [], f: []],
             d: [],
             e: [d: []],
             f: [e: []],
             g: [a: [], f: []]
           ]
  end
end
