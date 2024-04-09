{ config, pkgs, ... }:
{
  imports = [
    ./vpsadminos.nix
  ];

  nix.settings.experimental-features = "nix-command flakes";
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 113272;
    "fs.inotify.max_user_instances" = 256;
    "fs.inotify.max_queued_events" = 32768;
  };

  environment.systemPackages = with pkgs; [
    ((vim_configurable.override {  }).customize{
      name = "vim";
      vimrcConfig.customRC = ''
        " your custom vimrc
        set mouse=a
        set nocompatible
        colo torte
        syntax on
        set tabstop     =2
        set softtabstop =2
        set shiftwidth  =2
        set expandtab
        set autoindent
        set smartindent
        " ...
      '';
      }
    )
    #vim
    openssl
    curl
    wget
    lynx
    git
    tmux
    python311Packages.pillow
    python311Packages.pylibjpeg-libjpeg
    zlib
    lzlib
    dig
    killall
    pwgen
    python311Full
    python311Packages.pypdf2
    python311Packages.python-ldap
    python311Packages.pq
    python311Packages.aiosasl
    python311Packages.psycopg2
    python311Packages.bleach
    python311Packages.cffi
    python311Packages.chardet
    python311Packages.django
    python311Packages.django-formtools
    python311Packages.django-picklefield
    python311Packages.django-simple-captcha
    python311Packages.django-statici18n
    python311Packages.django-webpack-loader
    python311Packages.djangorestframework
    python311Packages.future
    python311Packages.gunicorn
    python311Packages.markdown
    # python311Packages.mysqlclient
    # python311Packages.mysqlclient
    python311Packages.openpyxl
    python311Packages.pillow
    python311Packages.pip
    python311Packages.pycryptodome
    python311Packages.pyjwt
    python311Packages.pysaml2
    python311Packages.python-dateutil
    python311Packages.python-ldap
    python311Packages.qrcode
    python311Packages.requests
    python311Packages.requests-oauthlib
    python311Packages.setuptools
    python311Packages.simplejson
    python311Packages.python3-gnutls
    python311Packages.gunicorn
    python311Packages.pip
    python311Packages.venvShellHook
    python311Packages.pylibjpeg-libjpeg
    python311Packages.pypdf2
    # python311Packages.python-ldap
    python311Packages.pq
    python311Packages.aiosasl
    python311Packages.psycopg2
    gettext
    sqlite
    postgresql_14
    apparmor-bin-utils

  ];

  users.users.django = {
    isNormalUser = true;
  };

  services.httpd = {
    enable = true;
    virtualHosts = {
        "grore.resdigita.com" = {
            enableACME = true;
            documentRoot = "/home/django/grore-django-app/images/static";
            extraConfig = ''
            ProxyPass /.well-known !
            ProxyPass /images/ !
            ProxyPass / http://127.0.0.1:8000/
            '';
        };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "chris@mann.fr";
  };

  systemd.services.django = {
    description = "Grore Django Website";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
        WorkingDirectory = "/home/django/grore-django-app/";
        ExecStart = ''/home/django/venv/bin/gunicorn --env DJANGO_ENV='production' --access-logfile /home/django/access.log --error-logfile /home/django/error.log --chdir /home/django/grore-django-app --workers 12 --bind 127.0.0.1:8000 grore.wsgi:application'';
        Restart = "always";
        RestartSec = "10s";
        User = "django";
        Group = "users";
    };
    unitConfig = {
        StartLimitInterval = "1min";
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";
  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";
  #users.extraUsers.root.openssh.authorizedKeys.keys =
  #  [ "..." ];

  systemd.extraConfig = ''
    DefaultTimeoutStartSec=900s
  '';

  system.stateVersion = "23.11";

  networking.firewall.allowedTCPPorts = [ 22 25 80 443 143 587 993 995 636 8443 9443 ];

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "grore" ];
    ensureUsers = [ {name = "groreuser"; } 
    {name = "grore"; ensureDBOwnership = true;} ];
    # authentication = pkgs.lib.mkForce ''
    #  #type database  DBuser  auth-method
    #  local all       all     trust
    #  host   grore     groreuser ::1/128 trust
    #  host   grore     groreuser 127.0.0.1/32 trust
    # '';  


  };
  

}
