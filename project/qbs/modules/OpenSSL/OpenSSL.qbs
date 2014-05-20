import qbs.Probes

// A Product Module (to allow Probes)
Product {
	id: OpenSSL

	Depends { name: "cpp" }

	Probes.PkgConfigProbe {
		id: opensslConfig
		name: "openssl"
	}

	// Parse flags returned by pkg-config not having -l in front of them
	cpp.linkerFlags: {
		var flags = [];

		for (i in opensslConfig.libs) {
			splitflag = opensslConfig.libs[i].split('-l');
			if (splitflag.length != 2) {
				flags.push(flag);
			}
		}

		return flags;
	}

	// Parse flags returned by pkg-config that have -l in front of them
	cpp.dynamicLibraries: {
		var flags = [];

		for (i in opensslConfig.libs) {
			splitflag = opensslConfig.libs[i].split('-l');
			if (splitflag.length == 2 && splitflag[0] == "") {
				flags.push(splitflag[1]);
			}
		}

		return flags;
	}

	cpp.cxxFlags: opensslConfig.cflags
}
