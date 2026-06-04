return {
    "folke/trouble.nvim",
    commit = "f1168feada93c0154ede4d1fe9183bf69bac54ea",
    config = function()
        require("trouble").setup({
            icons = false,
        })

        vim.keymap.set("n", "<leader>tt", function()
            require("trouble").toggle()
        end)
        vim.keymap.set("n", "[t", function()
            require("trouble").next({ skip_groups = true, jump = true })
        end)
        vim.keymap.set("n", "]t", function()
            require("trouble").previous({ skip_groups = true, jump = true })
        end)
    end,
}
