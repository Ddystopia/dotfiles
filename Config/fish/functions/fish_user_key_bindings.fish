function fish_user_key_bindings
  bind ctrl-space -M insert accept-autosuggestion
  for mode in insert default visual
    bind -M $mode ctrl-g edit_command_buffer
  end
  fish_vi_key_bindings
end
