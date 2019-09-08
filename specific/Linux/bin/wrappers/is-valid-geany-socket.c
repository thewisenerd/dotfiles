#include <sys/types.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <stdio.h>

#include <stdlib.h>
#include <unistd.h>

#include <sys/stat.h>
#include <linux/limits.h>

#define BUFFER_LENGTH _SC_PAGESIZE
#define ERROR_INVALID_ARG "file [%s] neither symlink nor socket!\n"
#define ERROR_NOT_SOCKET_OWNER "you do not own the symlink [%s]\n"
#define ERROR_BAD_FILE "file [%s] est bad\n"

int main(const int argc, const char **argv)
{
	char buf[BUFFER_LENGTH];
	char real_path[PATH_MAX];
	register int s;
	register ssize_t len;
	struct sockaddr_un saun;
	struct stat socket_stat;

	if (argc != 2) {
		fprintf(stderr, "\
usage: %s FILE\n\
\n\
\tFILE : symlink pointing to a geany socket\n\
\n"
		, argv[0]);
		exit(1);
	}


	if (lstat(argv[1], &socket_stat) != 0) {
		fprintf(stderr, ERROR_BAD_FILE, argv[1]);
		exit(1);
	}

	/*
	* check if a symlink -or- socket was passed
	*/
	if (! (
		S_ISLNK(socket_stat.st_mode) ||
		S_ISSOCK(socket_stat.st_mode)
	)) {
		fprintf(stderr, ERROR_INVALID_ARG, argv[1]);
		exit(1);
	}

	/*
	* get real socket file from link
	*/
	if (S_ISLNK(socket_stat.st_mode)) {
		if (socket_stat.st_uid != getuid()) {
			fprintf(stderr, ERROR_NOT_SOCKET_OWNER, argv[1]);
			exit(1);
		}

		len = readlink(argv[1], real_path, sizeof(real_path) - 1);
		if ((int) len > 0) {
			real_path[len] = '\0';
		} else {
			fprintf(stderr, ERROR_BAD_FILE, argv[1]);
			exit(1);
		}
	} else {
		strncpy(real_path, argv[1], sizeof(real_path));
	}

	/*
	* now we have real_path, check ownership
	*/
	if (stat(real_path, &socket_stat) != 0) {
		fprintf(stderr, ERROR_BAD_FILE, argv[1]);
		exit(1);
	}

	if (socket_stat.st_uid != getuid()) {
		fprintf(stderr, ERROR_NOT_SOCKET_OWNER, argv[1]);
		exit(1);
	}

	/*
	* talk with geany socket, and get at least a [\3]
	* geany is up and running then.
	*/

	/*
	* Get a socket to work with.  This socket will
	* be in the UNIX domain, and will be a
	* stream socket.
	*/
	if ((s = socket(AF_UNIX, SOCK_STREAM, 0)) < 0) {
		perror("client: socket");
		exit(1);
	}

	/*
	* Create the address we will be connecting to.
	*/
	saun.sun_family = AF_UNIX;
	strcpy(saun.sun_path, argv[1]);

	/*
	* Try to connect to the address.  For this to
	* succeed, the server must already have bound
	* this address, and must have issued a listen()
	* request.
	*
	* The third argument indicates the "length" of
	* the structure, not just the length of the
	* socket name.
	*/
	len = sizeof(saun.sun_family) + strlen(saun.sun_path);

	if (connect(s, (struct sockaddr *)&saun, len) < 0) {
		perror("client: connect");
		exit(1);
	}

	/*
	* First we read some strings from the server
	* and print them out.
	*/
	write(s, "doclist\n", 8);
	len = read(s, buf, BUFFER_LENGTH);
	if (len > 0) {
		if (len == 1) {
			if (buf[0] != (char)3) {
				perror("invalid response from geany!");
				exit(1);
			}
		}
	} else {
		perror("socket not responding!");
		exit(1);
	}

	/*
	* We can simply use close() to terminate the
	* connection, since we're done with both sides.
	*/
	close(s);

	return 0;
}
