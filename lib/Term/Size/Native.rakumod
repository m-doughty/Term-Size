unit module Term::Size::Native;

use NativeCall;

constant $os = $*KERNEL.name.lc;
constant $libname = $os ~~ /darwin/ 
	?? 'libtermsize.dylib' 
	!! 'libtermsize.so';

sub _libpath {
	%?RESOURCES{$libname}.IO.Str;
}

class TermSize is repr('CStruct') is export {
	has uint16 $.ws_row;
	has uint16 $.ws_col;
	has uint16 $.ws_xpixel;
	has uint16 $.ws_ypixel;

	method cell_width {
		return 0 if ($!ws_col == 0);
		return ($!ws_xpixel / $!ws_col).ceil.Int;
	}

	method cell_height {
		return 0 if ($!ws_row == 0);
		return ($!ws_ypixel / $!ws_row).ceil.Int;
	}
}

class CellSize is repr('CStruct') is export {
	has uint32 $.ws_cheight is rw;
	has uint32 $.ws_cwidth  is rw;
}

sub get_termsize(TermSize $sz)
	returns int32 is native(&_libpath) is export { * }

sub get_kitty_termsize(TermSize $sz, CellSize $cz) 
	returns int32 is native(&_libpath) is export { * }

