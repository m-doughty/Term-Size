class Build {
	method build($dist-path) {
		self!check-dependencies;

		say "🏗️  Building libtermsize library via make";
		say "Staging to $dist-path.";

		my $status = shell "cd ext && make";
		die "❌ Failed to build tokenizers-ffi via make" if $status != 0;

		my $os = $*KERNEL.name.lc;

		my $lib-ext = $os ~~ /darwin/ ?? 'dylib'
			!! 'so';

		"$dist-path/resources".IO.mkdir;

		copy "ext/libtermsize.$lib-ext",
			 "$dist-path/resources/libtermsize.$lib-ext";

		for <libtermsize.dylib libtermsize.so> -> $name {
			my $path = "$dist-path/resources/$name";
			$path.IO.spurt("") unless $path.IO.f;
		}

		True;
	}

	method !check-dependencies {
		for <make cc> -> $bin {
			shell "$bin --version > /dev/null 2>&1"
				or die "❌ Required tool '$bin' not found in PATH. Please install it.";
		}
	}
}


