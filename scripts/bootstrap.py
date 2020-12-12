#!/usr/bin/env python3

import os
import sys

import argparse
import errno
import filecmp
import logging

from pathlib import Path

from shutil import copy2


def get_arg_parser():
    parser = argparse.ArgumentParser()
    parser.add_argument("DOTFILES_PATH", help="path of dotfiles")
    parser.add_argument("-v", "--verbose", action="store_true", help="increase verbosity")
    parser.add_argument("--dry-run", action="store_true", help="dry-run, do not make any changes")
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


def setup_one_symlink(dot_file, home_file):
    try:
        os.remove(home_file)
    except OSError as e:
        if e.errno != errno.ENOENT:
            raise e
    dirpath = os.path.dirname(home_file)
    if not os.path.exists(dirpath):
        Path(dirpath).mkdir(parents=True, exist_ok=True)
    os.symlink(dot_file, home_file)


def setup_symlinks(basename, root, home, dry_run, logger):
    logger.info("[{}] setting up symlinks".format(basename))
    for [delta, dot_file, home_file] in get_files_for_setup(root, home, '**/*.symlink'):
        if os.path.exists(home_file):
            resolved = Path(home_file).resolve()
            if resolved == dot_file:
                logger.info("[{}] file {} already pointing to dot_file".format(basename, delta))
                continue
            else:
                if resolved == home_file:
                    logger.error("[{}] {} already exists!".format(basename, delta))
                else:
                    logger.error("[{}] {} -> {} already exists".format(basename, delta, resolved))
        else:
            if not dry_run:
                setup_one_symlink(dot_file, home_file)
            logger.info("[{}] {} symlinked".format(basename, delta))

    return 0


def setup_copies(basename, root, home, dry_run, logger):
    logger.info("[{}] setting up copies".format(basename))
    for [delta, dot_file, home_file] in get_files_for_setup(root, home, '**/*.copy'):
        if os.path.exists(home_file):
            compare_res = filecmp.cmp(dot_file, home_file)
            if compare_res:
                logger.info("[{}] {} is identical, skipping".format(basename, delta))
                continue
            else:
                logger.error("[{}] {} already exists and is not identical".format(basename, delta))
        else:
            if os.path.isdir(dot_file):
                logger.error("[{}] {} is directory; not copying".format(basename, delta))
            else:
                if not dry_run:
                    copy2(dot_file, home_file)
                logger.info("[{}] {} copied".format(basename, delta))
    return 0


def setup(basename, root, home, dry_run, logger):
    logger.info("setting up base [{}] from [{}]".format(basename, root))
    ret = setup_symlinks(basename, root, home, dry_run, logger)
    if ret != 0:
        logger.error("error setting up base [{}]: {}".format(basename, ret))
        return ret

    ret = setup_copies(basename, root, home, dry_run, logger)
    if ret != 0:
        logger.error("error setting up base [{}]: {}".format(basename, ret))
        return ret


def bootstrap(root, home, dry_run, logger):
    if not dir_exists(root):
        logger.error("DOTFILES_PATH [{}] does not exist".format(root))
        return errno.EEXIST

    base_generic = os.path.join(root, 'generic')
    if not dir_exists(base_generic):
        logger.error("generic config [{}] does not exist".format(base_generic))
        return errno.EEXIST
    setup('generic', base_generic, home, dry_run, logger)

    uname = os.uname()
    base_kernel = os.path.join(root, 'specific', uname.sysname)
    if dir_exists(base_kernel):
        setup('kernel', base_kernel, home, dry_run, logger)

    base_hostname = os.path.join(root, 'hosts', uname.nodename)
    if dir_exists(base_hostname):
        setup('hostname', base_hostname, home, dry_run, logger)

    return 0


def main():
    parser = get_arg_parser()
    args = parser.parse_args()
    root = args.DOTFILES_PATH
    home = os.path.expanduser('~')

    logger = get_logger(args.verbose)
    dry_run = args.dry_run

    return bootstrap(root, home, dry_run, logger)


if __name__ == '__main__':
    sys.exit(main())
