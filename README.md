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

### Replay pre-recorded history

```bash
jdd history.jsonl  # automatically jdd dive
```

### Record some history

```bash
# Polling
jdd --pre --watch 'cat obj.json'

# Streaming
jdd --pre --record obj.json

# Save observed history to file
jdd --pre --record obj.json --save history.jsonl
```

### Watch a stream of changes

```bash
# Polling
jdd --pre --watch "kubectl get pod YOUR_POD -o json"

# Streaming
kubectl get pod YOUR_POD --watch -o json | jdd --pre

# Save observed history to file
kubectl get pod YOUR_POD --watch -o json | jdd --pre --save history.jsonl
```

### Tail an ongoing recording, or don't tail a stream

```bash
# Tail an ongoing recording
jdd -f history.jsonl

# Sponge a history/stream before diving
cat history.jsonl | jdd --no-follow
```

### Inspect a single JSON object

```bash
jdd obj.json  # automatically jdd surf
```

## Usage

```text
Navigate successive versions of a JSON object.

Usage: jdd [COMMAND] [FILE...] [OPTIONS]

Args:
    COMMAND             The jdd command to run (dive, surf). If omitted, guessed from FILE extension and options.
    FILE                Input file(s). If omitted, reads from stdin. If multiple files, treat as successive versions.

Commands:
    (no command)        Guess command from FILE extension
    dive|hist           Navigate successive versions of a JSON object, via streaming or stored JSONL file.
    surf|insp           Explore a single JSON object via interactive query preview.
    help                Show this help message.

Options:
    --info              Show more info, like the file being processed.

Dive options:
    --record COMMAND    FILE Record mode: monitor FILE for changes and append new JSON object versions to it. (Alias: --rec, -r)
    --watch COMMAND     Watch mode: run COMMAND periodically to get new JSON object versions. (Alias: -w)
    --interval N        Interval in seconds between watch COMMAND executions (default: 5). (Alias: --int, -i)
    --save SAVE_FILE    Specify SAVE_FILE to store observed/intermediate changes (default: temporary file; recommendation: .jsonl extension).
    --preprocess        Preprocess each JSON entry into a single line before further processing (configure via JDD_PREPROCESSOR). (Alias: --pre)
    --follow            Follow mode: keep reading new entries as they are appended to FILE (default if no FILE is given). (Alias: -f)
    --no-follow         Disable follow mode.
    --all               Do not filter out consecutive duplicate entries (if using FILE, also prevents creating an intermediate file).
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
- `JDD_DEBUG` enable debug logging (default: unset)
- Additional tools: [fzf](https://github.com/junegunn/fzf), [jq](https://github.com/jqlang/jq), [gron](https://github.com/tomnomnom/gron), [mlr](https://github.com/johnkerl/miller)

## How I use jdd

I mainly use `jdd` to track changes to Kubernetes objects.

### Live-streamed changes

```bash
kubectl get pod MY_POD --watch -o json | jdd dive --pre
```

### Offline changes from OpenSearch-stored audit logs

```bash
# kis opens jdd for downloaded K8s Insights data.
#
# Usage: kis insights.csv
function kis {
    cat "${1:-/dev/stdin}"  \
    | mlr --icsv --ojsonl + put '$* = json_parse($UpdatedObject)' \
    | jq -cS '
        select(.kind != "Event")
        | del(.metadata.resourceVersion)
        | del(.status.conditions?[]?.lastTransitionTime)
        | del(.status.conditions?[]?.lastUpdateTime)
        | del(.status.placementStatuses?[]?.conditions?[]?.lastTransitionTime)
        | del(.status.placementStatuses?[]?.conditions?[]?.lastUpdateTime)
    ' \
    | jdd dive --tag '.metadata.generation' --no-follow
}
```

## See also

- [Kuba](https://github.com/hcgatewood/kuba): the magical kubectl companion
- [Appa](https://github.com/hcgatewood/appa): Markdown previews with live reload
- [Vis](https://github.com/hcgatewood/vis): visualize fuzzy tabular data
- [PDate](https://github.com/hcgatewood/pdate): human-readable dates and times
