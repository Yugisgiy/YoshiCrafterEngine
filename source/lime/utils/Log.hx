package lime.utils;

import haxe.PosInfos;
import sys.FileSystem;
import sys.io.File;
import lime.app.Application;
using StringTools;

#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Log
{
	public static var level:LogLevel;
	public static var throwErrors:Bool = true;

	public static function debug(message:Dynamic, ?info:PosInfos):Void
	{
		if (level >= LogLevel.DEBUG)
		{
			#if js
			untyped __js__("console").debug("[" + info.className + "] " + message);
			#else
			println("[" + info.className + "] " + Std.string(message));
			#end

		}
	}

	public static function error(message:Dynamic, ?info:PosInfos):Void
	{
		if (level >= LogLevel.ERROR)
		{
			var message = "[" + info.className + "] ERROR: " + message;

			if (throwErrors)
			{
                                #if desktop
                                LogsOverlay.error(message);
                                #else
                                lime.app.Application.current.window.alert(message, "ERROR");
                                #end
				    var lmao:String = Paths.gameFilesPath();
					if (!FileSystem.exists(lmao + 'logs')) {
						FileSystem.createDirectory(lmao + 'logs');
					}
				    File.saveContent(lmao
					+ 'logs/'
					+ Application.current.meta.get('file')
					+ '-'
					+ Date.now().toString().replace(' ', '-').replace(':', "'")
					+ '.log',
					message
					+ '\n');
				throw message;
			}
			else
			{
				#if js
				untyped __js__("console").error(message);
				#else
				println(message);
				#end
                                #if desktop
                                LogsOverlay.error(message);
                                #else
                                lime.app.Application.current.window.alert(message, "ERROR");
                                #end
                                var lmao:String = Paths.gameFilesPath();
					if (!FileSystem.exists(lmao + 'logs')) {
						FileSystem.createDirectory(lmao + 'logs');
					}
				    File.saveContent(lmao
					+ 'logs/'
					+ Application.current.meta.get('file')
					+ '-'
					+ Date.now().toString().replace(' ', '-').replace(':', "'")
					+ '.log',
					message
					+ '\n');
			}
		}
	}

	public static function info(message:Dynamic, ?info:PosInfos):Void
	{
		if (level >= LogLevel.INFO)
		{
			#if js
			untyped __js__("console").info("[" + info.className + "] " + message);
			#else
			println("[" + info.className + "] " + Std.string(message));
			#end
		}
	}

	public static inline function print(message:Dynamic):Void
	{
		#if sys
		Sys.print(Std.string(message));
		#elseif flash
		untyped __global__["trace"](Std.string(message));
		#elseif js
		untyped __js__("console").log(message);
		#else
		trace(message);
		#end
	}

	public static inline function println(message:Dynamic):Void
	{
		#if sys
		Sys.println(Std.string(message));
		#elseif flash
		untyped __global__["trace"](Std.string(message));
		#elseif js
		untyped __js__("console").log(message);
		#else
		trace(Std.string(message));
		#end
	}

	public static function verbose(message:Dynamic, ?info:PosInfos):Void
	{
		if (level >= LogLevel.VERBOSE)
		{
			println("[" + info.className + "] " + message);
		}
	}

	public static function warn(message:Dynamic, ?info:PosInfos):Void
	{
		if (level >= LogLevel.WARN)
		{
			#if js
			untyped __js__("console").warn("[" + info.className + "] WARNING: " + message);
			#else
			println("[" + info.className + "] WARNING: " + Std.string(message));
			#end
		}
	}

	private static function __init__():Void
	{
		#if no_traces
		level = NONE;
		#elseif verbose
		level = VERBOSE;
		#else
		#if sys
		var args = Sys.args();
		if (args.indexOf("-v") > -1 || args.indexOf("-verbose") > -1)
		{
			level = VERBOSE;
		}
		else
		#end
		{
			#if debug
			level = DEBUG;
			#else
			level = INFO;
			#end
		}
		#end

		#if js
		if (untyped __js__("typeof console") == "undefined")
		{
			untyped __js__("console = {}");
		}
		if (untyped __js__("console").log == null)
		{
			untyped __js__("console").log = function() {};
		}
		#end
	}
}
