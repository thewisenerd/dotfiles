function haste --description 'upload to hastebin'
	curl -X POST -s --data-binary @- https://hastebin.com/documents | awk -F '"' '{print "http://hastebin.com/"$4}';
end
