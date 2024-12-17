def create_left_prompt [] {
    let dir = match (do --ignore-shell-errors { $env.PWD | path relative-to $nu.home-path }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    let path_color = ansi green_bold
    let sep_color = ansi light_green_bold
    let path_segment = $"($path_color)($dir)(ansi reset)"

    $path_segment | str replace --all (char path_sep) $"($sep_color)(char path_sep)($path_color)"
}

def current_timep [] {
    let time_segment = ([
        (ansi reset)
        (ansi magenta)
        (date now | format date '%x %H:%M') # try to respect user's locale
    ] | str join)
        

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}

$env.PROMPT_COMMAND = { || create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| (
        ([$env.CMD_DURATION_MS, "ms"] | str join) |
        into duration
)}
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ": "
$env.PROMPT_INDICATOR_VI_NORMAL = "> "
$env.PROMPT_MULTILINE_INDICATOR = "::: "

$env.TRANSIENT_PROMPT_COMMAND = ""
$env.TRANSIENT_PROMPT_INDICATOR = "> "
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| ": " }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
# $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| current_timep }
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = ""

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
    ($nu.data-dir | path join 'completions') # default home for nushell completions
]

# Directories to search for plugin binaries when calling register
# The default for this is $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
# An alternate way to add entries to $env.PATH is to use the custom command `path add`
# which is built into the nushell stdlib:
use std "path add"
# $env.PATH = ($env.PATH | split row (char esep))
# path add /some/path
path add ($env.HOME | path join ".local" "bin")
# $env.PATH = ($env.PATH | uniq)

# Programs
$env.BROWSER = "firefox";
$env.EDITOR = "nvim";

# Rust/Cargo setup
$env.CARGO_HOME = ($env.HOME | path join ".cargo")
path add ($env.CARGO_HOME | path join "bin")

# Remove duplicates from PATH
$env.PATH = ($env.PATH | uniq)

# Wayland fixes
$env._JAVA_AWT_WM_NONREPARENTING = "1"
$env.ELECTRON_OZONE_PLATFORM_HINT = "auto";

# To load from a custom file you can use:
# source ($nu.default-config-dir | path join 'custom.nu')

zoxide init nushell | save -f ~/.zoxide.nu
