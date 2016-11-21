-- Invoke with: pandoc -t sample.lua

-- Blocksep is used to separate block elements.
function Blocksep()
  return "\n\n"
end

-- This function is called once for the whole document. Parameters:
-- body, title, date are strings; authors is an array of strings;
-- variables is a table.  One could use some kind of templating
-- system here; this just gives you a simple standalone HTML file.
function Doc(body, title, authors, date, variables)
  return body .. '\n'
end

-- The functions that follow render corresponding pandoc elements.
-- s is always a string, attr is always a table of attributes, and
-- items is always an array of strings (the items in a list).
-- Comments indicate the types of other variables.

function Str(s)
  return s
end

function Space()
  return " "
end

function LineBreak()
  return "\n"
end

function Emph(s)
  return "[em]" .. s .. "[/em]"
end

function Strong(s)
  return "[b]" .. s .. "[/b]"
end

function Subscript(s)
  error("Subscript isn't supported")
end

function Superscript(s)
  return s
end

function SmallCaps(s)
  error("SmallCaps isn't supported")
end

function Strikeout(s)
  return '[del]' .. s .. '[/del]'
end

function Link(s, src, tit)
  local ret = '[url'
  if s then
    ret = ret .. '=' .. src
  else
    s = src
  end
  ret = ret .. "]" .. s .. "[/url]"
  return ret
end

function Image(s, src, tit)
  return "[img=" .. tit .. "]" .. src .. "[/img]"
end

function Code(s, attr)
  return "[u]" .. s .. "[/u]"
end

function InlineMath(s)
  error("InlineMath isn't supported")
end

function DisplayMath(s)
  error("DisplayMath isn't supported")
end

function Note(s)
  error("Note isn't supported")
end

function Plain(s)
  return s
end

function Para(s)
  return s
end

-- lev is an integer, the header level.
function Header(lev, s, attr)
  return "[h]" .. s .. "[/h]"
end

function BlockQuote(s)
  return "[quote]\n" .. s .. "\n[/quote]"
end

function HorizontalRule()
  return "--------------------------------------------------------------------------------"
end

function CodeBlock(s, attr)
  return "[code]\n" .. s .. '\n[/code]'
end

function BulletList(items)
  local buffer = {}
  for _, item in ipairs(items) do
    table.insert(buffer, "[*]" .. item)
  end
  return "[list]\n" .. table.concat(buffer, "\n") .. "\n[/list]"
end

function OrderedList(items)
  local buffer = {}
  for _, item in ipairs(items) do
    table.insert(buffer, "[*]" .. item)
  end
  return "[list=1]\n" .. table.concat(buffer, "\n") .. "\n[/list]"
end

-- Revisit association list STackValue instance.
function DefinitionList(items)
  local buffer = {}
  for _, item in pairs(items) do
    for k, v in pairs(item) do
      table.insert(buffer, "[b]" .. k .. "[/b]:\n" ..
                        table.concat(v, "\n"))
    end
  end
  return table.concat(buffer, "\n")
end

-- Convert pandoc alignment to something HTML can use.
-- align is AlignLeft, AlignRight, AlignCenter, or AlignDefault.
function html_align(align)
  if align == 'AlignLeft' then
    return 'left'
  elseif align == 'AlignRight' then
    return 'right'
  elseif align == 'AlignCenter' then
    return 'center'
  else
    return 'left'
  end
end

-- Caption is a string, aligns is an array of strings,
-- widths is an array of floats, headers is an array of
-- strings, rows is an array of arrays of strings.
function Table(caption, aligns, widths, headers, rows)
  error("Table isn't supported")
end

function RawBlock(format, str)
  return '[code]\n' .. str .. '\n[/code]\n'
end

function Span(s, attr)
  return s
end

function Div(s, attr)
  return s .. '\n'
end

-- The following code will produce runtime warnings when you haven't defined
-- all of the functions you need for the custom writer, so it's useful
-- to include when you're working on a writer.
local meta = {}
meta.__index =
  function(_, key)
    io.stderr:write(string.format("WARNING: Undefined function '%s'\n",key))
    return function() return "" end
  end
setmetatable(_G, meta)
