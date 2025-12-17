# jdd: JSON diff diver

`jdd` is a CLI for navigating diff-over-time changes to a JSON object.

<p align="center"><img src="https://raw.githubusercontent.com/hcgatewood/jdd/main/assets/logo.png" alt="jdd logo" width="300"/></p>

## Features

<p align="center"><img src="https://raw.githubusercontent.com/hcgatewood/jdd/main/assets/demo.svg" alt="jdd demo" width="1000"/></p>

- Store a sequence of JSON object states each as a line in a JSONL file
- Navigate forward and backward through those states
- View diffs between each state
- Filter changes by object content
- Inspect object content at any state
- Jump to line number / object index

## Installation

### Homebrew

```bash
brew install @hcgatewood/jdd
```

### Manual

```bash
# Place jdd into PATH and make executable, something like...
curl -fsSL https://raw.githubusercontent.com/hcgatewood/jdd/main/jdd -o /usr/local/bin/jdd
chmod +x /usr/local/bin/jdd
# ...and then install dependencies
```

## Examples

***Dive*** is the JSON-over-time navigator. ***Surf*** is the single-JSON inspector.

### Navigate a JSONL file

```bash
jdd changes.jsonl  # automatically dive
```

### Navigate with follow

```bash
# Via command
jdd -f changes.jsonl  # automatically dive

# Or via pipe
tail -n +1 -f changes.jsonl | jdd dive
```

### Navigate with watch

```bash
# Via command
jdd dive --watch "kubectl get pods -o json" --interval 10

# Or via pipe
kubectl get pods --watch -o json | jdd dive
```

### Inspect a JSON file

```bash
jdd data.json  # automatically surf
```

## Usage

```text
Navigate successive versions of a JSON object.

Usage: jdd [COMMAND] [FILE] [FLAGS]

Commands:
    (no command)      Guess command from FILE extension
    dive              Navigate successive versions of a JSON object, via streaming or stored JSONL file.
    surf              Explore a single JSON object via interactive query preview.
    help              Show this help message.

Dive flags:
    --watch COMMAND    Watch mode: run COMMAND periodically to get new JSON object versions.
    --interval N       Interval in seconds between watch COMMAND executions (default: 5).
    --follow, -f       Follow mode: keep reading new entries as they are appended to FILE (default if no FILE is given).
    --no-follow        Disable follow mode.
    --tag OBJECT_PATH  Specify JSON object path to use as tag for each entry.

Dive keybindings:
    Ctrl-N/Down       Down.
    Ctrl-P/Up         Up.
    Ctrl-J/Ctrl-D     Page down.
    Ctrl-K/Ctrl-U     Page up.
    Ctrl-L            Preview page down.
    Ctrl-H            Preview page up.
    Ctrl-F            Jump to first entry.
    Ctrl-G            Jump to last entry.
    Ctrl-V            Jump to previous match.
    Ctrl-B            Jump to next match.
    Ctrl-T            Jump to best match.
    Ctrl-R            Toggle raw view.
    Ctrl-W            Clear query.
    Ctrl-Y            Copy current JSON entry to clipboard.
    Ctrl-O            Output current JSON entry to stdout and exit.
    Tab               Toggle 'goto' mode for jump to line number.
    Enter             Open in fx for further inspection.
```

## Configuration

- `JDD_DIFFER` set diff tool/invocation; some options
    - [jsondiffpatch](https://github.com/benjamine/jsondiffpatch) (default)
    - [jd](https://github.com/josephburnett/jd), [json-diff](https://github.com/andreyvit/json-diff), [jsondiff](https://github.com/xlwings/jsondiff), [gojsondiff](https://github.com/yudai/gojsondiff)
- `JDD_INSPECTOR` set JSON inspector; some options
    - [fx](https://github.com/antonmedv/fx) (default)
    - [jless](https://github.com/PaulJuliusMartinez/jless), [jdd surf](https://github.com/hcgatewood/jdd), [jnv](https://github.com/ynqa/jnv), [jid](https://github.com/simeji/jid)
- `JDD_PREVIEWER` set preview renderer; some options
    - [jaq](https://github.com/01mf02/jaq)
    - [jq](https://github.com/jqlang/jq) (default: `jq --color-output .`)
- `JDD_COPIER` set clipboard copy tool; some options
    - [pbcopy](https://ss64.com/mac/pbcopy.html) (default)
    - [xclip](https://github.com/astrand/xclip)
- `JDD_PREPROCESSOR` set watch item preprocessor; some options
    - [jaq](https://github.com/01mf02/jaq) (default: `jaq --sort-keys --compact-output .`)
    - [jq](https://github.com/jqlang/jq), [dasel](https://github.com/TomWright/dasel), [jj](https://github.com/tidwall/jj)
- `JDD_SHOW_FILE` show file name in fzf header (default: unset)
- Related tools
    - [jq](https://github.com/jqlang/jq), [gron](https://github.com/tomnomnom/gron), [mlr](https://github.com/johnkerl/miller)

## See also

- [Kuba](https://github.com/hcgatewood/kuba): the magical kubectl companion
- [Appa](https://github.com/hcgatewood/appa): Markdown previews with live reload
- [Vis](https://github.com/hcgatewood/vis): visualize fuzzy tabular data
- [PDate](https://github.com/hcgatewood/pdate): human-readable dates and times
