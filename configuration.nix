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
    python311Packages.pypdf2
    python311Packages.python-ldap
    python311Packages.pq
    python311Packages.aiosasl
    python311Packages.psycopg2
    bleach
    cffi
    chardet
    django
    django-formtools
    django-picklefield
    django-simple-captcha
    django-statici18n
    django-webpack-loader
    djangorestframework
    future
    gunicorn
    markdown
    mysqlclient
    mysqlclient
    openpyxl
    pillow
    pip
    pycryptodome
    pyjwt
    pysaml2
    python-dateutil
    python-ldap
    qrcode
    requests
    requests-oauthlib
    setuptools
    simplejson
    python3-gnutls
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
  ];

  users.users.grore = {
    isnormaluser = true;
  };

  systemd.services.django = {
    description = "Les Grands Voisins Wagtail Website";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
        WorkingDirectory = "/home/django/grore/";
        # ExecStart = ''/home/django/venv/bin/gunicorn --env WAGTAIL_ENV='production' --access-logfile access.log --chdir /home/django/grore --workers 3 --bind unix:/var/lib/django/grore.sock grore.wsgi:application'';
        ExecStart = ''/home/django/venv/bin/gunicorn --env WAGTAIL_ENV='production' --access-logfile /var/log/django/access.log --error-logfile /var/log/django/error.log --chdir /home/django/grore --workers 12 --bind 127.0.0.1:8000 grore.wsgi:application'';
        Restart = "always";
        RestartSec = "10s";
        User = "grore";
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

  time.timeZone = "Europe/Amsterdam";

  system.stateVersion = "23.11";

  # networking.firewall.allowedTCPPorts = [ 22 25 80 443 143 587 993 995 636 8443 9443 ];

  

}
