set -x PATH $HOME/.local/bin $HOME/.nimble/bin $PATH
set -x GPG_TTY (tty)

set fish_prompt_pwd_dir_length 1
set -e fish_greeting

set fish_color_error       red
set fish_color_end         red
set fish_color_comment     yellow
set fish_color_quote       yellow
set fish_color_command     green
set fish_color_param       cyan
set fish_color_operator    cyan
set fish_color_redirection cyan


fish_vi_key_bindings


function ls
  command exa --group-directories-first -s Name $argv
end

function xr
  command sudo xbps-remove -R $argv
end


set default_sym △
set insert_sym ▲
set visual_sym ▸
set replace_sym ◇

function prompt_sym
  if not test $status = 0
    set_color red
  end
  if test "$fish_key_bindings" = "fish_vi_key_bindings"
    or test "$fish_key_bindings" = "fish_hybrid_key_bindings"
    switch $fish_bind_mode
      case default
        printf '%s' $default_sym
      case insert
        printf '%s' $insert_sym
      case replace_one
        printf '%s' $replace_sym
      case visual
        printf '%s' $visual_sym
    end
  end
  set_color normal
end

function fish_mode_prompt
end

function fish_prompt
  echo
  printf " %s %s%s  " (prompt_sym) (set_color cyan) (prompt_pwd)
end

function fish_right_prompt
  printf "%s" (__fish_git_prompt)
end

