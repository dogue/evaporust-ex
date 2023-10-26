# Evaporust

This is a port of a [utility I wrote](https://github.com/dogue/evaporust) in Rust a while back. I'm using it to learn Elixir. I probably wouldn't recommend using this, but if you really want to, build it with `mix escript.build` and run it with the `--help` flag for an overview.

It runs `cargo clean` on every Rust project it finds (that has a `target` folder inside) during a recursive subdirectory walk.
