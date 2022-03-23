local ts_utils = require "nvim-treesitter.ts_utils"

local M = {}

local rustFunctionDescriptionComment = function(node)
  local comment = { "/// function description" }
  local children = ts_utils.get_named_children(node)
  local parameters = nil
  for _, v in ipairs(children) do
    if v:type() == "parameters" then
      parameters = ts_utils.get_named_children(v)
    end
  end

  if not next(parameters) then
    return { result = comment, type = "text", position = "above" }
  end

  table.insert(comment, "///")
  table.insert(comment, "/// # Arguments")
  table.insert(comment, "///")

  for _, v in ipairs(parameters) do
    for _, v2 in ipairs(ts_utils.get_named_children(v)) do
      if v2:type() == "identifier" then
        local c = "/// * `" .. ts_utils.get_node_text(v2)[1] .. "` - "
        table.insert(comment, c)
      end
    end
  end

  return { result = comment, type = "text", position = "above" }
end

local rustFunctionDescriptionSnippet = function(node)
  local ls = require "luasnip"
  local s = ls.s
  local fmt = require("luasnip.extras.fmt").fmt
  local i = ls.insert_node

  local snippet_text = { "/// {}" }
  local snippet_params = {}
  table.insert(snippet_params, i(1, "function description"))
  local param_count = 1

  local children = ts_utils.get_named_children(node)
  local parameters = nil
  for _, v in ipairs(children) do
    if v:type() == "parameters" then
      parameters = ts_utils.get_named_children(v)
    end
  end

  if not next(parameters) then
    snippet_text = table.concat(snippet_text, "\n")
    local snippet = s("", fmt(snippet_text, snippet_params))
    return { result = snippet, type = "luasnip", position = "above" }
  end

  table.insert(snippet_text, "///")
  table.insert(snippet_text, "/// # Arguments")
  table.insert(snippet_text, "///")

  for _, v in ipairs(parameters) do
    for _, v2 in ipairs(ts_utils.get_named_children(v)) do
      if v2:type() == "identifier" then
        local c = "/// * `" .. ts_utils.get_node_text(v2)[1] .. "` - {}"
        table.insert(snippet_text, c)
        param_count = param_count + 1
        table.insert(snippet_params, i(param_count))
      end
    end
  end

  snippet_text = table.concat(snippet_text, "\n")

  local snippet = s("", fmt(snippet_text, snippet_params))

  return { result = snippet, type = "luasnip", position = "above" }
end

M.function_item = function(node, options)
  if options.luasnip_enabled then
    return rustFunctionDescriptionSnippet(node)
  else
    return rustFunctionDescriptionComment(node)
  end
end

return M
