unit class Term::Size;

use Term::Size::Native;

has TermSize $.term-size = TermSize.new;
has CellSize $.cell-size = CellSize.new;

method populate {
	my $kitty_res = get_kitty_termsize($!term-size, $!cell-size);

	if ($kitty_res != 0) {
		my $res = get_termsize($!term-size);
		fail "Failed to get term size" if $res != 0;
	}

	unless ($!cell-size.ws_cwidth.defined && $!cell-size.ws_cheight.defined) {
		$!cell-size.ws_cwidth  = $!term-size.cell_width;
		$!cell-size.ws_cheight = $!term-size.cell_height;
	}

	True;
}

method term-width-px     { return $!term-size.ws_xpixel; }
method term-height-px    { return $!term-size.ws_ypixel; }
method term-width-cells  { return $!term-size.ws_col; }
method term-height-cells { return $!term-size.ws_row; }
method cell-width-px     { return $!cell-size.ws_cwidth; }
method cell-height-px    { return $!cell-size.ws_cheight; }

method raku {
	my $r = "Terminal width (px):     {self.term-width-px ?? self.term-width-px !! "Not Detected"}\n";
	$r   ~= "Terminal height (px):    {self.term-height-px ?? self.term-height-px !! "Not Detected"}\n";
	$r   ~= "Terminal width (cells):  {self.term-width-cells ?? self.term-width-cells !! "Not Detected"}\n";
	$r   ~= "Terminal height (cells): {self.term-height-cells ?? self.term-height-cells !! "Not Detected"}\n";
	$r   ~= "Cell width (px):         {self.cell-width-px ?? self.cell-width-px !! "Not Detected"}\n";
	$r   ~= "Cell height (px):        {self.cell-height-px ?? self.cell-height-px !! "Not Detected"}";

	return $r;
}

