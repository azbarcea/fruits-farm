# Class: java::params
#
# This class builds a hash of JDK/JRE packages and (for Debian)
# alternatives.  For wheezy/precise, we provide Oracle JDK/JRE
# options, even though those are not in the package repositories.
#
# For more info on how to package Oracle JDK/JRE, see the Debian wiki:
# http://wiki.debian.org/JavaPackage
#
# Because the alternatives system makes it very difficult to tell
# which Java alternative is enabled, we hard code the path to bin/java
# for the config class to test if it is enabled.
class installer::params {
  case $::osfamily {
    'RedHat': {
      case $::operatingsystem {
        'RedHat', 'CentOS', 'OracleLinux', 'Scientific': {
          if (versioncmp($::operatingsystemrelease, '5.0') < 0) {
            $jdk_package = 'java-1.6.0-sun-devel'
            $jre_package = 'java-1.6.0-sun'
          }
          elsif (versioncmp($::operatingsystemrelease, '6.3') < 0) {
            $jdk_package = 'java-1.6.0-openjdk-devel'
            $jre_package = 'java-1.6.0-openjdk'
          }
          else {
            $jdk_package = 'java-1.7.0-openjdk-devel'
            $jre_package = 'java-1.7.0-openjdk'
          }
        }
        default: { fail("unsupported os ${::operatingsystem}") }
      }
      $java = {
        'jdk' => { 'package' => $jdk_package, },
        'jre' => { 'package' => $jre_package, },
      }
    }
    default: { fail("unsupported platform ${::osfamily}") }
  }
}
