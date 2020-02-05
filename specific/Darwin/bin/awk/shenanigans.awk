BEGIN {
	OFS="\t";
}
{
	$1=$1;

	sub("\n\r$", "");
	sub("\r\n$", "");
	sub("\r$", "");
	sub("\n$", "");

	print;
}