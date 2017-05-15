defmodule Strand.IO do
  require Strand.Protocols.Viewable, as: Viewable

  @doc """
  view the graph in graphviz.
  takes a graph for which there is an implementation
  of `Strand.Protocols.Viewable`.
  Graphviz must be on your PATH.
  """
  def view!(g) do
    Mix.Utils.write_dot_graph!(
      Path.join(File.cwd!, "input.dot"),
      "graph",
      Viewable.format_for_mix_utils_dot(g),
      fn({node, children}) -> {{node, nil}, children} end
    )

    {dot_image, 0} = System.cmd("dot", ["-Tpng", "input.dot"])
    File.write("output.png", dot_image)
    System.cmd("open", ["output.png"])
    :ok
  end
end
