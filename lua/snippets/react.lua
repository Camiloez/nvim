local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt

-- Dynamically insert filename as default for component name
local function filename_component_name(_, _)
  local name = vim.fn.expand("%:t:r") -- strip extension
  name = name:gsub("^%l", string.upper) -- capitalize first letter
  return ls.sn(nil, i(1, name))
end

local snippet = s("com", fmt([[
  export default function {}() {{
    return (
      <>
        {}
      </>
    );
  }}
]], {
  d(1, filename_component_name), -- ✅ dynamic, editable
  i(2),
}))

ls.add_snippets("javascript", { snippet })
ls.add_snippets("javascriptreact", { snippet })

