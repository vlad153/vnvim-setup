return {
    "catppuccin/nvim", 
    name = "catppuccin",
    config = function()

        require("catppuccin").setup({
			flavour = "macchiato",
			background= {
				light = "latte",
		        dark="frappe",
			},
			transparent_background = false,
			styles = {
				functions = {"italic"},
				keywords = {"bold"},
			},
			--[[
			integrations = {
				harpoon = true,
				telescope = true,
			},
			]]--
		})
		vim.cmd.colorscheme "catppuccin"

    end
}

