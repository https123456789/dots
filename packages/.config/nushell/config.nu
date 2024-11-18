$env.config = {
    show_banner: false,
    edit_mode: vi,
    keybindings: [
        {
            name: history_up,
            modifier: alt,
            keycode: char_k,
            mode: [vi_insert, vi_normal],
            event: {
                send: Up
            }
        },
        {
            name: history_down,
            modifier: alt,
            keycode: char_j,
            mode: [vi_insert, vi_normal],
            event: {
                send: Down
            }
        },
        {
            name: clear_line,
            modifier: control,
            keycode: char_u,
            mode: [vi_insert, vi_normal],
            event: {
                edit: clear
            }
        },
    ]
}

alias l = ls -am
alias nv = nvim
alias lg = lazygit

source ~/.zoxide.nu
