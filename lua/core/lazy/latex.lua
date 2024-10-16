return {
  "lervag/vimtex",
  lazy = false,     -- we don't want to lazy load VimTeX
  -- tag = "v2.15", -- uncomment to pin to a specific release
  init = function()
    -- VimTeX configuration goes here, e.g.
    --vim.g.vimtex_view_genral_view = "wslview"
    --vim.g.vimtex_view_method = "general"
    --vim.g.vimtex_view_method = "zathura"
    vim.g.vimtex_compiler_method = "generic"
    vim.g.vimtex_compiler_generic = {
        -- command="ls *.tex | pdflatex -output-directory=compiled",
        command="ls *.tex | pdflatex",
    }

--    vim.env.vimtex_output_directory = "./compiled"


--    vim.g.vimtex_compiler_tectonic = {
--        out_dir = './compiled'
--    }
  end
}
