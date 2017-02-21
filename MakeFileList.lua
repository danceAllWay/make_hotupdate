require "Config"
FormatJson = require "FormatJson"
--先生成version.manifest
local formatJson = FormatJson:initWithTable ( baseValue )
formatJson:writeToFile ( versionFileName )

local allFileTable = {}--根节点

--开始读文件
local srcPath = rootPath .. "src"
local resPath = rootPath .. "res"

baseValue.assets = allFileTable

-- findInDir ( resPath, allFileTable )
-- findInDir ( srcPath, allFileTable )
findInDir ( rootPath, allFileTable )

local formatJson = FormatJson:initWithTable ( baseValue )
formatJson:writeToFile ( projectFileName )