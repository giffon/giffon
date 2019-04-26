/* This file is generated, do not edit! */
package python;
@:pythonImport("dotenv") extern class Dotenv {
	static public var __all__ : Dynamic;
	static public var __builtins__ : Dynamic;
	static public var __cached__ : Dynamic;
	static public var __doc__ : Dynamic;
	static public var __file__ : Dynamic;
	static public var __loader__ : Dynamic;
	static public var __name__ : Dynamic;
	static public var __package__ : Dynamic;
	static public var __path__ : Dynamic;
	static public var __spec__ : Dynamic;
	static public function dotenv_values(?dotenv_path:Dynamic, ?stream:Dynamic, ?verbose:Dynamic):Dynamic;
	/**
		Search in increasingly higher folders for the given file
		
		Returns path to the file if found, or an empty string otherwise
	**/
	static public function find_dotenv(?filename:Dynamic, ?raise_error_if_not_found:Dynamic, ?usecwd:Dynamic):Dynamic;
	/**
		Returns a string suitable for running as a shell script.
		
		Useful for converting a arguments passed to a fabric task
		to be passed to a `local` or `run` command.
	**/
	static public function get_cli_string(?path:Dynamic, ?action:Dynamic, ?key:Dynamic, ?value:Dynamic, ?quote:Dynamic):Dynamic;
	/**
		Gets the value of a given key from the given .env
		
		If the .env path given doesn't exist, fails
	**/
	static public function get_key(dotenv_path:Dynamic, key_to_get:Dynamic):Dynamic;
	static public function load_dotenv(?dotenv_path:Dynamic, ?stream:Dynamic, ?verbose:Dynamic, ?_override:Dynamic):Dynamic;
	static public function load_ipython_extension(ipython:Dynamic):Dynamic;
	/**
		Adds or Updates a key/value to the given .env
		
		If the .env path given doesn't exist, fails instead of risking creating
		an orphan .env somewhere in the filesystem
	**/
	static public function set_key(dotenv_path:Dynamic, key_to_set:Dynamic, value_to_set:Dynamic, ?quote_mode:Dynamic):Dynamic;
	/**
		Removes a given key from the given .env
		
		If the .env path given doesn't exist, fails
		If the given key doesn't exist in the .env, fails
	**/
	static public function unset_key(dotenv_path:Dynamic, key_to_unset:Dynamic, ?quote_mode:Dynamic):Dynamic;
}