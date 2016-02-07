function haste --description 'upload to hastebin'
	set a ( cat )
	curl -X POST -s -d "$a" http://hastebin.com/documents
end
