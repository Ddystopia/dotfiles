function claude-grep --description 'grep assistant answers in Claude Code transcripts'
    argparse -N 1 t/thinking 'color=' -- $argv; or return
    set -l re $argv[1]

    set -l flags i
    string match -qr '[[:upper:]]' -- $re; and set flags ''

    set -l kinds '["text"]'
    set -q _flag_thinking; and set kinds '["text","thinking"]'

    set -l color false
    switch "$_flag_color"
        case always
            set color true
        case never
        case '*'
            isatty stdout; and set color true
    end

    rg -n -S --with-filename --no-heading --color never --sort modified --glob '*.jsonl' \
        -e $re -e '"type":"ai-title"' ~/.claude/projects |
    jq -n -R -r --arg re $re --arg flags $flags --argjson kinds $kinds --argjson color $color '
        def c($code): if $color then "\u001b[\($code)m" + . + "\u001b[0m" else . end;
        def main_file: sub("/subagents/[^/]*$"; ".jsonl");
        [inputs
         | capture("^(?<f>[^:]*):(?<n>[0-9]+):(?<j>.*)$")
         | .n |= tonumber
         | .m = (.j | fromjson? // null)
         | select(.m)] as $rows
        | ([$rows[] | select(.m.type == "ai-title") | {key: .f, value: .m.aiTitle}] | from_entries) as $titles
        | $rows
        | map(
            . as $r
            | select(.m.type == "assistant")
            | .m.message.content[]?
            | select(.type as $t | $kinds | index($t))
            | (.type == "thinking") as $think
            | (.text // .thinking) / "\n"
            | .[]
            | select(test($re; $flags))
            | {f: $r.f, n: $r.n, m: $r.m, think: $think,
               line: (if $color then gsub("(?<x>\($re))"; "\(.x | c("1;31"))"; $flags) else . end)})
        | reduce .[] as $h ({order: [], by: {}};
            if .by[$h.f] then . else .order += [$h.f] end | .by[$h.f] += [$h])
        | .by as $by
        | .order[]
        | $by[.] as $hits
        | $hits[0].m as $m
        | ($hits[0].f | c("35")),
          ([($titles[$hits[0].f | main_file] // empty | c("1")),
            ($m.agentId // empty | "(subagent \(.))")] | join(" ")),
          ("cd \($m.cwd) && claude --resume \($m.sessionId)" | c("2")),
          ($hits | group_by(.n)[]
           | (.[] | "\(.n | tostring | c("32")):\(.m.timestamp[:16] | sub("T"; " ") | c("36")): "
                    + (if .think then "(thinking) " | c("2") else "" end) + .line),
             ("  sed -n \(.[0].n)p \(.[0].f) | jq -r \u0027.message.content[] | .text // .thinking // empty\u0027 | less" | c("2"))),
          ""
    '
end
