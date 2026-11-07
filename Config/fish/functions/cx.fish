function cx --wraps claude --description 'Claude Code with DeepSeek models through cc-router'
    set -l settings ~/.config/cc-router/claude-settings.json
    if curl -sf --max-time 3 http://127.0.0.1:8787/cc-router/settings -o $settings.tmp
        mv $settings.tmp $settings
    else
        rm -f $settings.tmp
        echo 'cx: cc-router unreachable or DeepSeek /models failed, using cached model list' >&2
    end
    claude --settings $settings $argv
end
