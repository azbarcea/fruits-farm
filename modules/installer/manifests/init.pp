# Class: installer
#
# This module manages the Java runtime package
#
# Parameters:
#
#  [*distribution*]
#    The java distribution to install. Can be one of "jdk" or "jre",
#    or other platform-specific options where there are multiple
#    implementations available (eg: OpenJDK vs Oracle JDK).
#
#  [*version*]
#    The version of java to install. By default, this module simply ensures
#    that java is present, and does not require a specific version.
#
#  [*package*]
#    The name of the java package. This is configurable in case a non-standard
#    java package is desired.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class installer(
  $distribution          = 'jdk',
  $version               = 'present',
  $package               = undef
) {
  include installer::params
	
  validate_re($version, 'present|installed|latest|^[.+_0-9a-zA-Z:-]+$')

  if has_key($installer::params::java, $distribution) {
    $default_package_name     = $installer::params::java[$distribution]['package']
    $java_home                = $installer::params::java[$distribution]['java_home']
  } else {
    fail("Java distribution ${distribution} is not supported.")
  }

  $use_java_package_name = $package ? {
    undef   => $default_package_name,
    default => $package,
  }

  ## If $java_alternative is set, use that.
  ## Elsif the DEFAULT package is being used, then use $default_alternative.
  ## Else undef
  $use_java_alternative = $java_alternative ? {
    undef   => $use_java_package_name ? {
      $default_package_name => $default_alternative,
      default               => undef,
    },
    default => $java_alternative,
  }

  ## Same logic as $java_alternative above.
  $use_java_alternative_path = $java_alternative_path ? {
    undef   => $use_java_package_name ? {
      $default_package_name => $default_alternative_path,
      default               => undef,
    },
    default => $java_alternative_path,
  }

  $jre_flag = $use_java_package_name ? {
    /headless/ => '--jre-headless',
    default    => '--jre'
  }

  anchor { 'java::begin:': }
  ->
  package { 'java':
    ensure => $version,
    name   => $use_java_package_name,
  }
  ->
  class { 'java::config': }
  -> anchor { 'java::end': }

}
