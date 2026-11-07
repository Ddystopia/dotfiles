function source_env_file
    set -l env_file $argv[1]

    if test -f "$env_file"
        set -l content (cat "$env_file")

        for pair in (string split ';' -- $content)
          export $pair
        end
    else
        echo "Error: File '$env_file' not found."
        return 1
    end
end
