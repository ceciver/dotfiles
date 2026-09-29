return {
    "lukas-reineke/indent-blankline.nvim",
    commit = "3d08501caef2329aba5121b753e903904088f7e6",
    main = "ibl",
    opts = function()
        local hooks = require("ibl.hooks")

        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
            vim.api.nvim_set_hl(0, "IblIndent", {
                fg = "#6e6a86",
                nocombine = true,
            })
        end)

        return {
            indent = {
                char = "│",
                highlight = "IblIndent",
            },
            scope = {
                enabled = false,
            },
        }
    end,
}
