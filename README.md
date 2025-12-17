# jdd: JSON diff diver

`jdd` is a CLI for navigating diff-over-time changes to a JSON object — a **JSON time machine**.

<p align="center"><img src="https://raw.githubusercontent.com/hcgatewood/jdd/main/assets/logo.png" alt="jdd logo" width="300"/></p>

## Features

<p align="center"><img src="https://raw.githubusercontent.com/hcgatewood/jdd/main/assets/demo.svg" alt="jdd demo" width="1000"/></p>

- History of JSON object states as a JSONL file (or via stdin)
- Navigate forward and backward in time
- View diffs between each point in time
- Inspect object content at any point in time
- Filter changes by object content
- Jump to line number / change index

## Installation

### Homebrew

```bash
brew install hcgatewood/tap/jdd
```

### Manual

```bash
# Place jdd into PATH and make executable, something like...
curl -fsSL https://raw.githubusercontent.com/hcgatewood/jdd/main/jdd -o /usr/local/bin/jdd
chmod +x /usr/local/bin/jdd
# ...and then install dependencies
```

## Examples

Subcommands: ***dive*** (alias: `hist`) is the JSON-over-time navigator, ***surf*** (alias: `insp`) is the single-JSON inspector.

### History: JSONL file

```bash
jdd changes.jsonl  # automatically dive
```

### History: with follow

```bash
# Via command
jdd -f changes.jsonl  # automatically dive

# Or via pipe
tail -n +1 -f changes.jsonl | jdd dive
```

### History: via watch

```bash
# Via command (polling)
jdd dive --watch "kubectl get pod YOUR_POD -o json" --interval 10 --pre

# Or via pipe (streaming)
kubectl get pod YOUR_POD --watch -o json | jdd dive --pre
```

### Inspect: JSON file

```bash
jdd data.json  # automatically surf
```

## Usage

```text
Navigate successive versions of a JSON object.

Usage: jdd [COMMAND] [FILE] [FLAGS]

Commands:
    (no command)        Guess command from FILE extension
    dive|hist           Navigate successive versions of a JSON object, via streaming or stored JSONL file.
    surf|insp           Explore a single JSON object via interactive query preview.
    help                Show this help message.

Options:
    --file              Show the file being processed.

Dive options:
    --watch COMMAND     Watch mode: run COMMAND periodically to get new JSON object versions.
    --interval N        Interval in seconds between watch COMMAND executions (default: 5).
    --pre               Preprocess each JSON entry into a single line before further processing (configure via JDD_PREPROCESSOR).
    --follow, -f        Follow mode: keep reading new entries as they are appended to FILE (default if no FILE is given).
    --no-follow         Disable follow mode.
    --all               Do not filter out consecutive duplicate JSON entries.
    --tag OBJECT_PATH   Specify JSON object path to use as tag for each entry.

Dive keybindings:
    Ctrl-/              Help (this message -- q to quit).
    Ctrl-N/Down         Down.
    Ctrl-P/Up           Up.
    Ctrl-J/Ctrl-D       Page down.
    Ctrl-K/Ctrl-U       Page up.
    Ctrl-L              Preview page down.
    Ctrl-H              Preview page up.
    Ctrl-F              Jump to first entry.
    Ctrl-G              Jump to last entry.
    Ctrl-V              Jump to previous match.
    Ctrl-B              Jump to next match.
    Ctrl-T              Jump to best match.
    Ctrl-R              Toggle raw view.
    Ctrl-W              Clear query.
    Ctrl-Y              Copy current JSON entry to clipboard.
    Ctrl-O              Output current JSON entry to stdout and exit.
    Tab                 Toggle 'goto' mode for jump to line number.
    Enter               Open in fx for further inspection.
```

## Configuration

Environment variables to customize behavior; generally they can be set to the name of an installed tool or a command string.

- `JDD_DIFFER` diff engine: [jsondiffpatch](https://github.com/benjamine/jsondiffpatch) (default), [jd](https://github.com/josephburnett/jd), [json-diff](https://github.com/andreyvit/json-diff), [jsondiff](https://github.com/xlwings/jsondiff), [gojsondiff](https://github.com/yudai/gojsondiff), [difftastic](https://github.com/Wilfred/difftastic)
- `JDD_INSPECTOR` single-object inspector: [fx](https://github.com/antonmedv/fx) (default), [jless](https://github.com/PaulJuliusMartinez/jless), [jdd surf](https://github.com/hcgatewood/jdd), [jnv](https://github.com/ynqa/jnv), [jid](https://github.com/simeji/jid)
- `JDD_PREVIEWER` preview engine: [jq](https://github.com/jqlang/jq) (default: `jq --color-output .`), [jaq](https://github.com/01mf02/jaq)
- `JDD_PREPROCESSOR` optional preprocessor for each item: [jq](https://github.com/jqlang/jq) (default: `jq --sort-keys --compact-output --unbuffered .`), [jaq](https://github.com/01mf02/jaq), [dasel](https://github.com/TomWright/dasel), [jj](https://github.com/tidwall/jj)
- `JDD_COPIER` clipboard copier: [pbcopy](https://ss64.com/mac/pbcopy.html) (default), [xclip](https://github.com/astrand/xclip), etc.
- `JDD_SHOW_FILE` show file name in fzf header (default: unset)
- `JDD_NO_HELP` don't show help keybinding in dive (default: unset)
- Related tools: [fzf](https://github.com/junegunn/fzf), [jq](https://github.com/jqlang/jq), [gron](https://github.com/tomnomnom/gron), [mlr](https://github.com/johnkerl/miller)

## See also

- [Kuba](https://github.com/hcgatewood/kuba): the magical kubectl companion
- [Appa](https://github.com/hcgatewood/appa): Markdown previews with live reload
- [Vis](https://github.com/hcgatewood/vis): visualize fuzzy tabular data
- [PDate](https://github.com/hcgatewood/pdate): human-readable dates and times
