{ pkgs ? (import <nixpkgs> { }), ... }:
with pkgs;
let
  otp = beam.packages.erlang_27;
  elixir = otp.elixir_1_18;
in
pkgs.mkShell {
  buildInputs = [
    elixir
    otp.erlang
    ((if otp ? elixir-ls then otp.elixir-ls else otp.elixir_ls).override { inherit elixir; })
  ];

  shellHook = ''
    # keep your shell history in iex
    export ERL_AFLAGS="-kernel shell_history enabled"

    # Force UTF8 in CLI
    export LANG="C.UTF-8"

    # this isolates mix to work only in local directory
    mkdir -p .nix-mix .nix-hex
    export MIX_HOME=$PWD/.nix-mix
    export HEX_HOME=$PWD/.nix-hex

    # make hex from Nixpkgs available
    # `mix local.hex` will install hex into MIX_HOME and should take precedence
    export MIX_PATH="${otp.hex}/lib/erlang/lib/hex/ebin"
    export PATH=$MIX_HOME/bin:$HEX_HOME/bin:$PATH

    # Dev env
    export PUSHER_PORT=4000
    export PUSHER_JWT_SIGNER_SECRET=secret
    export PUSHER_CONTROL_SECRET=secret
  '';
}
