decl -docstring "git branch holding the current buffer" str git_branch
decl -docstring "modeline string with git branch" -hidden str git_branch_str

def refresh-git-branch %{ eval %sh{
  branch=$(cd "$(dirname "${kak_buffile}")" && git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -n "${branch}" ]; then
      printf "set window git_branch %%{${branch}}\nset window git_branch_str %%{${branch} }"
  fi
} }
