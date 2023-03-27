#!/usr/bin/env CLI_TOOL=cli bash-cli-part

CLI_IMPORT=(
    "cli import inline-c"
)

cli::import::inline_b1() {
    echo "function=inline-b1"
    declare -f cli::import::inline_c
    cli::import::inline_c
}
