# Usage

    brew install luarocks
    luarocks install penlight
    luarocks install busted

Then put the following in your zsh configs

<code><pre>
export LUA_USER=/path/to/util/lua
local lua_cache=$HOME/.lua.zsh

if [ ! -f $lua_cache ]; then
  if (( $+commands[lua] )); then
    if (($+LUA_USER)); then
      local saved_path=$(lua -e 'print(package.path)')
      local str="export LUA_PATH=\"$saved_path;$LUA_USER/?.lua\";"
      echo $str > $lua_cache
    fi
  fi
fi

if [ ! -f $lua_cache ]; then
  touch $lua_cache
fi

source $lua_cache
</pre></code>

This will also take over management of your `LUA_PATH` but I can't figure
out a better way to accomplish this. Once you have done that you can simply
do `require('broom.set')` from your lua scripts or whatever other code you want.

You can run tests with `busted broom/tests/set.lua` or other tests in there.
