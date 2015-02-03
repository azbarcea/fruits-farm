# On Debian systems, if alternatives are set, manually assign them.
class installer::fallback ( ) {
  case $::osfamily {
    'RedHat': {
      # Uninstall jdk or jre, whatever it was installed.
    }
    default: {
      # Do nothing.
    }
  }
}
