return {
    "folke/zen-mode.nvim",
    commit = "78557d972b4bfbb7488e17b5703d25164ae64e6a",
    config = function()
        vim.keymap.set("n", "<leader>zz", function()
            require("zen-mode").setup({
                window = {
                    width = 90,
                    options = {},
                },
            })
            require("zen-mode").toggle()
            vim.wo.wrap = false
            vim.wo.number = true
            vim.wo.rnu = true
            ColorMyPencils()
        end)

        vim.keymap.set("n", "<leader>zZ", function()
            require("zen-mode").setup({
                window = {
                    width = 80,
                    options = {},
                },
            })
            require("zen-mode").toggle()
            vim.wo.wrap = false
            vim.wo.number = false
            vim.wo.rnu = false
            vim.opt.colorcolumn = "0"
            ColorMyPencils()
        end)
    end,
}
