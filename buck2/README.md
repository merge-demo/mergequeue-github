# Buck2 Project

This directory contains a [Buck2](https://buck2.build) project used to demonstrate parallel queues.

## Structure

- **Word packages**: `alpha/`, `bravo/`, `charlie/`, `delta/`, `echo/`, `foxtrot/`, `golf/`,
  `hotel/`, `indigo/`, `juliet/`, `kilo/`
  - Each package contains a `.txt` file with words and a `BUCK` file declaring a `filegroup`
- **Toolchains**: `toolchains/` registers the prelude's demo toolchains
- The prelude is the copy bundled with the `buck2` binary (`[external_cells] prelude = bundled`)
- **`bin/buck2`**: a [DotSlash](https://dotslash-cli.com) file that pins the buck2 version

## Setup

Install `dotslash` (e.g. `cargo install dotslash` or `brew install dotslash`), then run the pinned
buck2. The first run downloads and caches the binary for your platform:

```bash
cd buck2
./bin/buck2 targets //...
./bin/buck2 build //...
```

## Upgrading Buck2

Each [buck2 release](https://github.com/facebook/buck2/releases) publishes a DotSlash file named
`buck2`. Replace `bin/buck2` with the one from the new release:

```bash
curl -fsSL -o buck2/bin/buck2 https://github.com/facebook/buck2/releases/download/<tag>/buck2
```

Because the prelude is bundled with the binary, this upgrades the build rules too.

## Impacted Targets

Set `build = "buck2"` and `change_code_path = "buck2"` in `.config/mq.toml` to have the PR Factory
edit files here and upload impacted targets computed from the Buck2 graph:

```bash
python3 tools/detect_impacted_buck2_targets.py --base=main
```
