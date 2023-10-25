defmodule Evaporust.CLI do
  def main(argv) do
    Optimus.new!(
      name: "evaporust",
      description: "evapoRust",
      version: "0.0.1",
      author: "Dogue",
      about: "Utility for cleaning up build artifacts in multiple rust projects",
      allow_unknown_args: false,
      parse_double_dash: true,
      args: [],
      options: [
        exclude: [
          value_name: "EXCLUDE",
          short: "-x",
          long: "--exclude",
          help: "Any path containing this word will be ignored; can be specified multiple times",
          parser: :string,
          required: false,
          multiple: true
        ],
        start: [
          value_name: "START",
          help: "Directory to start scanning from; defaults to current directory",
          required: false,
          short: "-s",
          long: "--start",
          default: fn ->
            case File.cwd() do
              {:ok, cwd} -> cwd
              {:error, _} -> "dingus"
            end
          end,
          parser: fn s ->
            cwd =
              case File.cwd() do
                {:ok, dir} -> dir
                {:error, _} -> ""
              end

            target = Path.expand(s)

            if File.exists?(target) do
              {:ok, target}
            else
              {:ok, cwd}
            end
          end
        ]
      ]
    )
    |> Optimus.parse!(argv)
    |> Evaporust.scan_projects()
  end
end
