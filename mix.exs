defmodule Strand.Mixfile do
  use Mix.Project

  def project do
    [app: :strand,
     version: "0.1.0",
     elixir: "~> 1.4",
     package: package(),
     description: "graphs, like Loom",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger],
     mod: {Strand.Application, []}]
  end

  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev}]
  end

  defp package do
    [maintainers: ["Clark Kampfe"],
     licenses: ["Eclipse Public License"],
     links: %{"Github" => "https://github.com/ckampfe/strand"}
    ]
  end
end
