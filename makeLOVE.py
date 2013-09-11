#!/usr/bin/env python
#-*-coding: utf-8-*-
"""
MakeLÖVE is a helper script for quickly packaging LUA:LÖVE source files.

To invoke this script either execute by way of your window manager, or
by command line.

Examples:
    ./makeLOVE.py    // run with defaults
    ./makeLOVE.py -h // print the help menu
    ./makeLOVE.py -v // run with defaults but print with verbose on
    ./makeLOVE.py -n MyFile -e .love // create a zipped file called MyFile.love

Future development is slated to include:
    /bin/ integration: so users can invoke from any directory
    configuration file: so users can specify defaults rather than discrete
        CL arguments.
    general purpose: this is currently using standard zip protocols and
        renaming files with the extension .love.  But it could be configured to
        do ANY compression protocol.
"""
from __future__ import print_function
import zipfile
import os
import sys
import getopt
import uuid

class ZipFiles(object):
    """
    Self-executing script to package LUA:LOVE source files into a single
    {file}.love package.

    Uses zipfile (ZIP standards) std-module to package everything to LUA:LOVE
    standards.

    Attributes:
        _compressedName: the name that will be used as the system file name.
        _extension: the extension appended to _compressedName (ignores periods)
        _verbose: boolean value indicating the user wants verbose turned on/off.
        cwd: the current working directory of the script.
        _ignoreList: the ignore list? duh!  These files don't get added to the
            zip.
        zipObj: the zipfile.ZipFile() object.
        success: boolean indicating that the zip process was successful.


    Methods:
        __init__:  sets up the initial states and parses any sys.args()
        zipAll: responsible for zipping all files given the states in __init__.
        printFiles: if verbose is True, this method will print all the files it
            zips.
        printHelp:  if the user passes -h, --help, or botches the script, this
            will print the help message.
        safeForZipping:  helper method for determining if a file is not in the
            _ignoreList

    TODO (jrc.csus@gmail.com): add a config file option that a user can set tha
        includes: ignore files/folders; _compressedName; _extension; any defaul
        settings.

    """
    def __init__(self, *argv, **kwargs):
        """Sets up the instance of ZipFiles().

        Args:
            list() of "system arguments" from the command line
        Kwargs:
            None
        """
        try:
            ## Initializing state
            self._uuid = uuid.uuid4().get_hex()
            self._compressed_name = "BuildLOVE_{0}".format(self._uuid[:5])
            self._extension = "love"
            self._verbose = False
            self.cwd = os.getcwd()
            self._os = os.name
            if self._os == 'nt':
                self._cwd_list = self.cwd.split("\\")
            else:
                self._cwd_list = self.cwd.split("/")
            self._ignore_list = ['.git', '.love', '.md', '.py', '.zip']

            ## Accepting command line arguments
            # pylint: disable=W0612
            opts, args = getopt.getopt(argv[0], "n:e:hv", ["name=", "extension=",
                                                        "help", "verbose"])
            for opt, arg in opts:
                if opt in ("-h", "--help"):
                    self.print_help()
                    sys.exit()
                elif opt in ("-v", "--verbose"):
                    self._verbose = True
                elif opt in ("-n", "--name"):
                    self._compressed_name = arg
                elif opt in ("-e", "--extension"):
                    ## Explicit strip of period in case user sends .EXT
                    self._extension = str(arg).strip(".")

            self.compressed_name = "{0}.{1}".format(self._compressed_name,
                                                    self._extension)
            # pylint: disable=C0301
            self.zip_obj = zipfile.ZipFile("{0}.{1}".format(self._compressed_name,
                                                            self._extension), 'w')

        except getopt.GetoptError:
            ## Prints the help message when the script has been
            ## misused.
            self.print_help()
            sys.exit(2)
        except:
            ## Pokemon error catching - gotta catch 'em all!
            self.success = False
            raise

    def zip_all(self):
        """Zip the contents of the current folder"""
        for file_path, _dirs, file_obj in os.walk(self.cwd):
            for ignore in self._ignore_list:
                if ignore in file_path:
                    break

            mod_file_path = self._split_path(self._os, file_path)
            _relative_path = self.remove_root(self._cwd_list, mod_file_path)

            for files in file_obj:
                if self.safe_for_zipping(mod_file_path, files):
                    if self._verbose:
                        self.print_files(files)
                    _path = self.reconstruct_path(_relative_path)
                    self.zip_obj.write(os.path.join(_path, files))
            self.success = True

    @staticmethod
    def _split_path(os, path):
        """Splits the path based on the OS"""
        if os == 'nt':
            split_path = path.split('\\')
        else:
            split_path = path.split('/')
        return split_path

    def reconstruct_path(self, path):
        """Return a path as a string that has the cwd removed from it."""
        if self._os == 'nt':
            _path = "\\".join(path)
        else:
            _path = "/".join(path)
        return _path

    def remove_root(self, cwd, relative_dir):
        """Remove the common working directory from each relative path"""
        for directory in cwd:
            relative_dir.remove(directory)
        return relative_dir

    def print_files(self, zipfiles):
        """Print to stdout every file that is being added to the zip"""
        files = []
        files.append(zipfiles)
        for file_obj in files:
            print("Adding {0} ...".format(file_obj))

    @staticmethod
    def print_help():
        """Return instructions on how to use this script"""

        _help = """
        "BuildLÖVE" is a Python-based helper script for quickly zipping
        all source files into a single *.love wrapper.

        If you are seeing this it's because you either typed -h or --help at
        the command line, or you invoked this script incorrectly!

        -h, --help \t Show this help message.
        -v, --verbose \t Toggle verbose mode (default is is quite).

        -n, --name \t Provide the name of the final build.  Default is a name
                   \t built on UUID-4.
        -e, --extension  If you require a file-extension other than .love you
                         can provide one here.
        """
        return print(_help)

    def safe_for_zipping(self, path, files):
        """
        Return throwFile::{boolean}, where:

        True = File is destined to be zipped (not in the ignore list)
        False = File is not meant to be zipped (in the ignore list)
        """
        for ignore_this in self._ignore_list:
            safe_file = True
            if ignore_this in path:
                safe_file = False
                break
            elif ignore_this not in path:
                if ignore_this in files:
                    safe_file = False
                    break
        return safe_file

    def status_of_run(self):
        """Update user/stdout of current status of the zipped files."""
        if self.success:
            print("Successfully made the zip file")
            print("\nResulting file: \t {0}".format(self.compressed_name))
        elif not self.success:
            print("Error in creating zip file... returned False")
        return self.success


if __name__ == '__main__':
    zipEmAll = ZipFiles(sys.argv[1:])
    zipEmAll.zip_all()
    zipEmAll.status_of_run()
