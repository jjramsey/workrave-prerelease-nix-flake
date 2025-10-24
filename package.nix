{
  lib,
  stdenv,
  fetchFromGitHub,
  wrapGAppsHook3,
  cmake,
  gettext,
  intltool,
  libtool,
  pkg-config,
  libICE,
  libSM,
  libXScrnSaver,
  libXtst,
  gobject-introspection,
  glib,
  glibmm,
  gtkmm3,
  gtk4,
  atk,
  pango,
  pangomm,
  cairo,
  cairomm,
  dbus,
  dbus-glib,
  gst_all_1,
  libsigcxx,
  boost,
  python3Packages,
  wayland,
  wayland-scanner,
  libayatana-appindicator,
  fmt,
  spdlog,
}:

stdenv.mkDerivation rec {
  pname = "workrave";
  version = "1.11.0-rc.2-unstable-2025-10-17";

  src = fetchFromGitHub {
    repo = "workrave";
    owner = "rcaelers";
    rev = "0c015cbd4be26b5338f8a44ceb6a013bf571f52f";
    sha256 = "sha256-VuLYqM/nq+GUuP90k2DsbelaA3q/2UWABPSwLNe8plI=";
  };

  nativeBuildInputs = [
    cmake
    gettext
    intltool
    libtool
    pkg-config
    wrapGAppsHook3
    python3Packages.jinja2
    gobject-introspection
    wayland-scanner
    spdlog
  ];

  buildInputs = [
    libICE
    libSM
    libXScrnSaver
    libXtst
    glib
    glibmm
    gtkmm3
    gtk4
    atk
    pango
    pangomm
    cairo
    cairomm
    dbus
    dbus-glib
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    libsigcxx
    boost
    wayland
    libayatana-appindicator
    fmt
  ];

  cmakeFlags = [ "-DWITH_GNOME45=ON" "-DHAVE_WAYLAND:BOOL=TRUE"
                 "-DLOCALINSTALL:BOOL=TRUE" "-DGSETTINGS_COMPILE:BOOL=ON" ];

  patches = [ ./fix-workrave-paths.patch ];

  postPatch = ''
    substituteInPlace ui/applets/gnome-shell-45/src/extension.js \
       --subst-var-by workrave_typelib_path "$out/lib/girepository-1.0"

    substituteInPlace libs/config/src/GSettingsConfigurator.cc \
       ui/applets/common/src/control.c \
       ui/applets/common/src/timerbox.c \
       ui/applets/indicator/src/indicator-workrave.c \
       --subst-var-by workrave_schema_path ${glib.makeSchemaPath "$out" "${pname}-${version}"}
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Program to help prevent Repetitive Strain Injury";
    mainProgram = "workrave";
    longDescription = ''
      Workrave is a program that assists in the recovery and prevention of
      Repetitive Strain Injury (RSI). The program frequently alerts you to
      take micro-pauses, rest breaks and restricts you to your daily limit.
    '';
    homepage = "http://www.workrave.org/";
    downloadPage = "https://github.com/rcaelers/workrave/releases";
    license = licenses.gpl3;
    maintainers = with maintainers; [ prikhi ];
    platforms = platforms.linux;
  };
}
