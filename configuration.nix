# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "doloresdeuniversitario"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "es";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "es";

  fonts.packages = with pkgs; [
      nerd-fonts.hasklug
  ];

  programs.bash.promptInit = ''
  PS1='\[\e[38;5;196m\][\[\e[38;5;202m\]\u\[\e[38;5;64m\]@\[\e[38;5;68m\]\h\[\e[38;5;196m\]]\[\e[0m\] \[\e[38;5;226m\]{\[\e[38;5;51m\]\t\[\e[38;5;226m\]}\[\e[0m\] \[\e[38;5;27m\]\w\[\e[0m\] \[\e[38;5;57m\]λ\[\e[38;5;93m\]>\[\e[0m\] '
    '';

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."ford" = {
    isNormalUser = true;
    description = "ford";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = ''
        set clipboard+=unnamedplus
        set number
        set relativenumber
	set tabstop=2
	set shiftwidth=2
      	set softtabstop=2
      	set expandtab
      '';
    };
  };

  programs.git = {
    enable = true;
    config = {
      user = {
        name = "Your Name";
        email = "your.email@example.com";
      };
      credential = {
        helper = "store";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    xclip 
    tree-sitter
    networkmanagerapplet
    dmenu
    (slstatus.overrideAttrs (oldAttrs: {
      postPatch = ''
        cat > config.def.h <<'EOF'
        const unsigned int interval = 1000;

        static const char unknown_str[] = "n/a";

        #define MAXLEN 2048

        static const struct arg args[] = {
            /* function      format              argument */
            { run_command,   " %s%% Vol  | ",    "pamixer --get-volume" },
            { datetime,      "%s  | ",      "%T , %a %d, %b %m" },
            { ram_perc,      "%s%% RAM  | ",     NULL },
            { cpu_perc,      "%s%% CPU  ",       NULL },
        };
        EOF
      '';
    })) 
    alacritty
    scrot
    firefox
    pamixer
    feh
    gimp
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  
  services.xserver.enable = true;

  services.xserver.windowManager.dwm = {
      enable = true;
      package = pkgs.dwm.overrideAttrs (oldAttrs: {
        postPatch = ''
          cat > config.def.h <<'EOF'
  /* See LICENSE file for copyright and license details. */
  
  /* appearance */
  static const unsigned int borderpx  = 1;        /* border pixel of windows */
  static const unsigned int snap      = 32;       /* snap pixel */
  static const int showbar            = 1;        /* 0 means no bar */
  static const int topbar             = 1;        /* 0 means bottom bar */
  static const char *fonts[]          = { "HasklugNerdFont:size=10" };
  static const char dmenufont[]       = "HasklugNerdFont:size=10";
  static const char col_gray1[]       = "#222222";
  static const char col_gray2[]       = "#444444";
  static const char col_gray3[]       = "#bbbbbb";
  static const char col_gray4[]       = "#eeeeee";
  static const char col_cyan[]        = "#005577";
  static const char *colors[][3]      = {
      /*               fg         bg         border   */
      [SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
      [SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
  };
  
  /* tagging */
  static const char *tags[] = { "󰈹", "", "", "󰂫", "", "", "7", "8", "9" };
  
  static const Rule rules[] = {
      /* xprop(1):
       *  WM_CLASS(STRING) = instance, class
       *  WM_NAME(STRING) = title
       */
      /* class      instance    title       tags mask     isfloating   monitor */
      { "Gimp",     NULL,       NULL,       0,            0,           -1 },
      { "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
  };
  
  /* layout(s) */
  static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
  static const int nmaster     = 1;    /* number of clients in master area */
  static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
  static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */
  
  static const Layout layouts[] = {
      /* symbol     arrange function */
      { "[]=",      tile },    /* first entry is default */
      { "><>",      NULL },    /* no layout function means floating behavior */
      { "[M]",      monocle },
  };
  
  /* key definitions */
  #define MODKEY Mod4Mask
  #define TAGKEYS(KEY,TAG) \
      { MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
      { MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
      { MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
      { MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },
  
  /* helper for spawning shell commands in the pre dwm-5.0 fashion */
  #define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }
  
  /* commands */
  static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
  static const char *dmenucmd[]   = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4, NULL };
  static const char *termcmd[]    = { "alacritty", NULL };
  static const char *volumeup[]   = { "pamixer", "--increase", "5", NULL };
  static const char *volumedwn[]  = { "pamixer", "--decrease", "5", NULL };
  static const char *screenshot[] = { "scrot", "-s", NULL };
  
  static Key keys[] = {
      /* modifier                     key        function        argument */
      { MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
      { MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
      { MODKEY,                       XK_b,      togglebar,      {0} },
      { MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
      { MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
      { MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
      { MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
      { MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
      { MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
      { MODKEY,                       XK_Return, zoom,           {0} },
      { MODKEY,                       XK_Tab,    view,           {0} },
      { MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
      { MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
      { MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
      { MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
      { MODKEY,                       XK_space,  setlayout,      {0} },
      { MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
      { MODKEY,                       XK_0,      view,           {.ui = ~0 } },
      { MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
      { MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
      { MODKEY,                       XK_period, focusmon,       {.i = +1 } },
      { MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
      { MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
      { MODKEY,                       XK_Up,     spawn,          {.v = volumeup } },
      { MODKEY,                       XK_Down,   spawn,          {.v = volumedwn } },
      { MODKEY|ShiftMask,             XK_s,      spawn,          {.v = screenshot } },
      TAGKEYS(                        XK_1,                      0)
      TAGKEYS(                        XK_2,                      1)
      TAGKEYS(                        XK_3,                      2)
      TAGKEYS(                        XK_4,                      3)
      TAGKEYS(                        XK_5,                      4)
      TAGKEYS(                        XK_6,                      5)
      TAGKEYS(                        XK_7,                      6)
      TAGKEYS(                        XK_8,                      7)
      TAGKEYS(                        XK_9,                      8)
      { MODKEY|ShiftMask,             XK_q,      quit,           {0} },
  };
  
  /* button definitions */
  /* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
  static Button buttons[] = {
      /* click                event mask      button          function        argument */
      { ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
      { ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
      { ClkWinTitle,          0,              Button2,        zoom,           {0} },
      { ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
      { ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
      { ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
      { ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
      { ClkTagBar,            0,              Button1,        view,           {0} },
      { ClkTagBar,            0,              Button3,        toggleview,     {0} },
      { ClkTagBar,            0,              Button1,        tag,            {0} },
      { ClkTagBar,            0,              Button3,        toggletag,      {0} },
  };
  EOF
        '';
      });
    };

  services.xserver.displayManager.sessionCommands = ''
      slstatus &
      feh --bg-scale /home/ford/Wallpapers/Lorenz_attractor.png &
    '';

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
