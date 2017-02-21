function getFileMd5 ( file )
	local tmpFile = io.open ( file, "rb" )
	if not tmpFile then
		return "nil"
	end
	local fileData = tmpFile:read ( "*a" )
	tmpFile:close ()
	return md5.sumhexa ( fileData )
end

function findInDir ( path, r_table )
	--print ( "into dir: " .. string.sub ( path, string.len ( rootPath ) + 1, -1) )
	 for file in lfs.dir( path ) do
	 	if file ~= "." and file ~= ".." then
			local f = path .. "/" .. file
			local attr = lfs.attributes ( f )
			assert ( type ( attr ) == "table" )
			if attr.mode == "directory" then
				findInDir ( f, r_table )
	        	else	
				local filePath = string.sub ( f, string.len ( rootPath ) + 1, -1 ) 
				local fileMd5 = getFileMd5 ( f )
				--print ( "get file: " .. filePath .. "-->" .. fileMd5 )
				local tmp = {}
				r_table [ filePath ] = { md5 = fileMd5 }
			end
		end
	end
end