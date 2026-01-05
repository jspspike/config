{ lib, fetchCrate, rustPlatform, pkg-config, openssl, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "rustic_server";
  version = "0.4.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-53/XvOlA+krs0VwgTaQ/iCBJmUqrODUzmzgkaHwGL7Q=";
  };

  cargoHash = "sha256-otphM/D6O1HNhJwkETFtAGzDqwWOXhH7NDh0hPTQN9U=";

  nativeBuildInputs = [ pkg-config ];

  doCheck = false;
}
