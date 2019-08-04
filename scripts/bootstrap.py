#!/usr/bin/env python3

import os
import sys

import argparse
import errno
import filecmp
import logging

from pathlib import Path

def get_arg_parser():
    parser = argparse.ArgumentParser()
    parser.add_argument("DOTFILES_PATH", help="path of dotfiles")
    parser.add_argument("-v", "--verbose", action="store_true", help="increase verbosity")
    return parser

def get_logger(verbose):
    logger = logging.getLogger('dotfiles_bootstrap')
    if verbose:
        logging.basicConfig(level=logging.INFO)
    return logger


def dir_exists(dirpath):
    return os.path.isdir(dirpath)

def get_files_for_setup(root, home, globspec):
    files_generator = Path(root).glob(globspec)

    for sfile in files_generator:
        delta = os.path.relpath(sfile, root)
        new_filename = os.path.splitext(delta)[0]
        new_filepath = os.path.join(home, new_filename)
        yield [delta, sfile, new_filepath]

def setup_symlinks(basename, root, home, logger):
    logger.info("setting up symlinks for base [{}]".format(basename))
    for [delta, dot_file, home_file] in get_files_for_setup(root, home, '**/*.symlink'):
        if os.path.exists(home_file):
            logger.error("{} already exists!".format(delta))
        else:
            os.remove(home_file)
            os.symlink(dot_file, home_file)
            logger.info("{} symlinked".format(delta))

    return 0

def setup_copies(basename, root, home, logger):
    logger.info("setting up copies for base [{}]".format(basename))
    for [delta, dot_file, home_file] in get_files_for_setup(root, home, '**/*.copy'):
        if os.path.exists(home_file):
            compare_res = filecmp.cmp(dot_file, home_file)
            if compare_res:
                logger.info("{} is identical, skipping".format(delta))
                continue
            else:
                log.error("{} already exists and is not identical")
        else:
            logger.error('copy: {}'.format(home_file))

    return 0

def setup(basename, root, home, logger):
    logger.info("setting up base [{}] from [{}]".format(basename, root))
    ret = setup_symlinks(basename, root, home, logger)
    if ret != 0:
        logger.error("error setting up base [{}]: {}".format(basename, ret))
        return ret

    ret = setup_copies(basename, root, home, logger)
    if ret != 0:
        logger.error("error setting up base [{}]: {}".format(basename, ret))
        return ret

def bootstrap(root, home, logger):
    if not dir_exists(root):
        logger.error("DOTFILES_PATH [{}] does not exist".format(root))
        return errno.EEXIST

    base_generic = os.path.join(root, 'generic')
    if not dir_exists(base_generic):
        logger.error("generic config [{}] does not exist".format(base_generic))
        return errno.EEXIST
    setup('generic', base_generic, home, logger)

    uname = os.uname()
    base_kernel = os.path.join(root, 'specific', uname.sysname)
    if dir_exists(base_kernel):
        setup('kernel', base_kernel, home, logger)

    base_hostname = os.path.join(root, 'hosts', uname.nodename)
    if dir_exists(base_hostname):
        setup('hostname', base_hostname, home, logger)

    return 0

def main():
    parser = get_arg_parser()
    args = parser.parse_args()
    root = args.DOTFILES_PATH
    home = os.path.expanduser('~')

    logger = get_logger(args.verbose)

    return bootstrap(root, home, logger)

if __name__ == '__main__':
    sys.exit(main())
