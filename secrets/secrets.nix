let
  pubkey = "age1720sdyua4gsvg9rfvpu6lp6e9tm3952cjdmv6zs6q2uk7zarvv5sv9m0hx";
in {
  "cloudflare-token" = { file = ./cloudflare-token.age; };
  "rustic-htpasswd" = {
    file = ./rustic-htpasswd.age;
    owner = "rustic";
    group = "rustic";
    mode = "0400";
  };
  "rustic-env-var" = { file = ./rustic-env-var.age; };
}
