{
  inputs,
  pkgs,
  ...
}: {
  services.caddy.enable = true;
  services.caddy.virtualHosts = {
    "www.nezia.dev" = {
      extraConfig = ''
        redir https://nezia.dev{uri}
      '';
    };
    "nezia.dev" = {
      extraConfig = ''
        root * ${inputs.portfolio.packages.${pkgs.system}.default}
        file_server
        encode gzip
      '';
    };
  };
}
