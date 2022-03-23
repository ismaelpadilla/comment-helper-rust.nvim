Add (at the moment, very basic) support for documenting Rust using [comment-helper](https://github.com/ismaelpadilla/comment-helper.nvim/).

<p align="center">
  <img alt="Preview" src="https://i.imgur.com/7k7ofRb.gif">
</p>

### Features

- Supports snippets if you have [LuaSnip](https://github.com/L3MON4D3/LuaSnip) enabled.
- Supports the following Rust node types:
  - function_item

### Installation

```viml
Plug 'ismaelpadilla/comment-helper.nvim' " base plugin
Plug 'ismaelpadilla/comment-helper-rust.nvim'
```

### Configuration

```lua
local ch = require("comment_helper")
local ch_rust = require("comment_helper_rust")

ch.set_ignored_types("rust", {"source_file"})
ch.add("rust", "function_item", ch_rust.function_item)
```
