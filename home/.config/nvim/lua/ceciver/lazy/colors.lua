function ColorMyPencils(color)
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
    {
        "folke/tokyonight.nvim",
        commit = "610179f7f12db3d08540b6cc61434db2eaecbcff",
        config = function()
            require("tokyonight").setup({
                style = "storm",
                transparent = true,
                terminal_colors = true,
                styles = {
                    comments = { italic = false },
                    keywords = { italic = false },
                    sidebars = "dark",
                    floats = "dark",
                },
            })
        end,
    },

    {
        "rose-pine/neovim",
        name = "rose-pine",
        commit = "9d7474f80afe2f0cfcb4fabfc5451f509d844b85",
        priority = 1000,
        config = function()
            require("rose-pine").setup({
                disable_background = true,
            })

            ColorMyPencils()
        end,
    },
}
