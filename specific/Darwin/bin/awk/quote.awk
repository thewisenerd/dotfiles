#!/usr/local/bin/gawk -f

# bwahahaha
# lazy saturday evening scripts

@include "getopt.awk"

function usage()
{
    print("usage: quote [-l left] [-r right] [-a append] [-n no-wrap] [-d]") > "/dev/stderr"
    print("  -w: wrap lines")
    print("  -d: use double quotes (precede -l and -r, else overrides -l, -r)")
    exit 1
}

BEGIN {
    left="'";
    right="'";
    append=",";
    prepend="";

    wrap = 1;

    while ((c = getopt(ARGC, ARGV, "p:l:r:a:ndhw")) != -1) {
        if (c == "l") {
            if (trace) printf("overriding l with `%s`\n", Optarg) > "/dev/stderr";
            left=Optarg;
        } else if (c == "r") {
            if (trace) printf("overriding r with `%s`\n", Optarg) > "/dev/stderr";
            right = Optarg;
        } else if (c == "a") {
            append=Optarg;
            if (trace) printf("overriding a with `%s`\n", Optarg) > "/dev/stderr";
        } else if (c == "p") {
            prepend=Optarg;
            if (trace) printf("overriding p with `%s`\n", Optarg) > "/dev/stderr";
        } else if (c == "n") {
            if (trace) printf("not wrapping lines\n");
            wrap = 0;
        } else if (c == "d") {
            if (trace) printf("using double quotes\n") > "/dev/stderr";
            left = "\""
            right = "\""
        } else if (c == "h") {
            usage()
        } else if (c == "w") {
            # ignore this for the time being
        } else {
            usage()
        }
    }

    # Clear out options
    for (i = 1; i < Optind; i++) {
        ARGV[i] = ""
    }
}

{
    if (buf) {
        buf = sprintf("%s%s", buf, append);
        if (wrap == 0) {
            print buf;
        } else {
            printf buf;
        }
    }
    buf = sprintf("%s%s%s%s", prepend, left, $0, right);
}

END {
    if (buf) {
        if (wrap == 0) {
            print buf;
        } else {
            printf buf;
        }
    }
}
