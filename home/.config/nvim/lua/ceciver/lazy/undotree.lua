return {
    "mbbill/undotree",
    commit = "a1758ba9990b7189f601a3a5acdfc8ca3907a700",
    config = function()
        vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end,
}
