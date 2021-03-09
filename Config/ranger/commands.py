# https://github.com/ranger/ranger/wiki/Custom-Commands#fzf-integration

import os.path;
import subprocess;
from ranger.api.commands import Command;

class fzf(Command):
    def execute(self):
        stdout, stderr = self.fm.execute_command(
            'find -L . -print 2>&- | sed "s/^\.$//" | cut -b 3- | fzf',
            universal_newlines=True, stdout=subprocess.PIPE
        ).communicate();

        if not stdout: return;
        path = os.path.abspath(stdout.rstrip('\n'));

        if os.path.isdir(path):
            self.fm.cd(path);
        else:
            self.fm.select_file(path);
