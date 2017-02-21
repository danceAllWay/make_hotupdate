json = require "json"
require "lfs"
md5 = require "md5"
require "FileUtil"

--资源根目录
rootPath = "F:\\mempacman\\manifest\\"

--服务器地址
packageUrl = "http://updater-10064935.cos.myqcloud.com/tcg/"

--版本地址
remoteVersionUrl = "http://updater-10064935.cos.myqcloud.com/tcg/version.manifest"

--MD5列表地址
remoteManifestUrl = "http://updater-10064935.cos.myqcloud.com/tcg/project.manifest"

--版本号
version = "1.160601.1"

--引擎版本（非必须）
engineVersion = "Quick Cocos2d-x v3.6.2"

--版本文件名字
versionFileName = "version.manifest"
--MD5列表文件名字
projectFileName = "project.manifest"

--基本属性
baseValue = {
	packageUrl = packageUrl,
	remoteVersionUrl = remoteVersionUrl,
	remoteManifestUrl = remoteManifestUrl,
	version = version,
	engineVersion = engineVersion
}
