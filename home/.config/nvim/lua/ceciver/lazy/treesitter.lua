return {
    "nvim-treesitter/nvim-treesitter",
    commit = "364b86ec8ea88e4a77ba676b93fb10829d6a9cb3",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "bash",
                "c",
                "css",
                "html",
                "javascript",
                "json",
                "lua",
                "markdown",
                "python",
                "rust",
                "typescript",
                "vim",
                "vimdoc",
            },
            sync_install = false,
            auto_install = true,
            indent = {
                enable = true,
            },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = { "markdown" },
            },
        })
    end,
}
