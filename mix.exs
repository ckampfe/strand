defmodule Strand.Mixfile do
  use Mix.Project

  def project do
    [
      app: :strand,
      version: "0.6.0",
      elixir: "~> 1.9",
      package: package(),
      description: "graphs, like Loom",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev}]
  end

  defp package do
    [
      maintainers: ["Clark Kampfe"],
      licenses: ["EPL-1.0"],
      links: %{"Github" => "https://github.com/ckampfe/strand"}
    ]
  end
end
