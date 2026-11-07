function envsource
    # read files passed as args, ignore comments and blank lines
    for line in (cat $argv | sed -e 's/#.*$//' | grep -v '^[[:space:]]*$')
        # split possible multiple assignments on a single line separated by ;
        for assign in (string split ';' -- $line)
            set assign (string trim -- $assign)
            if test -z "$assign"
                continue
            end

            # Split on '='; preserve '=' inside the value by joining rest back
            set parts (string split '=' -- $assign)
            set key $parts[1]
            if test (count $parts) -gt 1
                if test (count $parts) -gt 2
                    set val (string join -- '=' $parts[2..-1])
                else
                    set val $parts[2]
                end
            else
                set val ''
            end

            # strip surrounding quotes (single & double) and trim
            set val (string trim -- $val)
            set val (string replace -r '^"(.*)"$' '$1' -- $val)
            set val (string replace -r "^'(.*)'\$" '$1' -- $val)
            set val (string trim -- $val)

            # export
            set -gx $key $val
            echo "Exported key $key = $val"
        end
    end
end
