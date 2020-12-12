# thank fuck https://stackoverflow.com/a/11679106/2873157

NR == FNR {
  rep[$1] = $2;
  # printf "%s\t%s\n", $1, $2;
  next;
}

{
  for (key in rep) {
    res = gsub(key, rep[key]);
    # printf "++ %d --", res;
  }

  print;
}