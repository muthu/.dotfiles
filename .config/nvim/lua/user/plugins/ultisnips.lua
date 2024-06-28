return {
    "SirVer/ultisnips",
    lazy = false,
    config = function()
        vim.g.UltiSnipsSnippetDirectories = {"mysnippets"}
        vim.g.UltiSnipsExpandTrigger="<tab>"
        vim.g.UltiSnipsJumpForwardTrigger="<tab>"
        vim.g.UltiSnipsJumpBackwardTrigger="<s-tab>"
    end,
}
