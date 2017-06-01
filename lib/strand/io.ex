defmodule Strand.IO do
  alias Strand.Protocol.Viewable

  @doc """
  view the graph in graphviz.
  takes a graph for which there is an implementation
  of `Strand.Protocol.Viewable`.
  Graphviz must be on your PATH.
  """
  def view!(g) do
    :ok = write!(g)
    System.cmd("open", ["output.png"])
    :ok
  end

  def write!(g, filename \\ "output.png") do
    dot_image = generate!(g)
    File.write(filename, dot_image)
    :ok
  end

  def generate!(g) do
    Mix.Utils.write_dot_graph!(
      Path.join(File.cwd!, "input.dot"),
      "graph",
      Viewable.format_for_mix_utils_dot(g),
      fn
        {{node, label}, children} -> {{node, label}, children}
        {node, children} -> {{node, nil}, children}
      end
    )

    {dot_image, 0} = System.cmd("dot", ["-Tpng", "input.dot"])
    dot_image
  end
end
