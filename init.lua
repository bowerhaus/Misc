-- Loaded before all other Lua files

-- We extend the path to search in a Library folder
package.path="./Libraries/?.lua;".. package.path

-- Request that we be warned of non-existent globals
require "strict"