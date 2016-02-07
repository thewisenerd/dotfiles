function lastcommit
	git log $1 --pretty=oneline | head -1 | cut -f 1 -d " "
end
