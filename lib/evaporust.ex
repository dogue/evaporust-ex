defmodule Evaporust do
  def scan_projects(input) do
    start = input.options.start
    exclude = input.options.exclude

    walk([start], [])
    |> Enum.filter(fn d -> not String.contains?(d, exclude) end)
    |> Enum.each(&clean_project(&1))
  end

  defp walk([], projects), do: projects

  defp walk([current | rest], projects) do
    case read_dir(current) do
      {dirs, false} -> walk(rest ++ dirs, projects)
      {dirs, true} -> walk(rest ++ dirs, [current | projects])
    end
  end

  defp read_dir(dir) do
    files = File.ls!(dir)

    has_manifest = Enum.any?(files, &(&1 == "Cargo.toml"))
    has_artifacts = Enum.any?(files, &(&1 == "target"))

    cargo? = has_manifest and has_artifacts

    dirs =
      files
      |> Enum.map(&Path.join(dir, &1))
      |> Enum.filter(&File.dir?(&1))

    {dirs, cargo?}
  end

  defp clean_project(dir) do
    File.cd!(dir)
    System.cmd("cargo", ["clean"])
  end
end
