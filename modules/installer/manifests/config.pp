# On Debian systems, if alternatives are set, manually assign them.
class installer::config ( ) {
  case $::osfamily {
    'RedHat': {
      if $installer::use_java_alternative != undef and $installer::use_java_alternative_path != undef {
        # The standard packages install alternatives, custom packages do not
        # For the standard packages installer::params needs these added.
        if $java::use_java_package_name != $java::default_package_name {
          exec { 'create-java-alternatives':
            path    => '/usr/bin:/usr/sbin:/bin:/sbin',
            command => "alternatives --install ${installer::use_java_alternative} java ${$installer::use_java_alternative_path} 20000" ,
            unless  => "alternatives --display java | grep -q ${$installer::use_java_alternative_path}",
            before  => Exec['update-java-alternatives']
          }
        }

        exec { 'update-java-alternatives':
          path    => '/usr/bin:/usr/sbin',
          command => "alternatives --set java ${$installer::use_java_alternative_path}" ,
          unless  => "test /etc/alternatives/java -ef '${installer::use_java_alternative_path}'",
        }
      }
    }
    default: {
      # Do nothing.
    }
  }
}
