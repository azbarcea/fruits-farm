class schedule{
        schedule {"first":
                range => "07:00 - 07:49",
                repeat=> 100
                 }
        schedule {"second":
                range => "07:50 - 07:54",
                repeat=> 100
                 }
        schedule {"third":
                range => "07:55 - 14:00",
                repeat=> 100
                 }

        if $hostname == "coors"
        {
                package {"ensure tomcat6-admin coors":
                                name => 'tomcat6-admin',
                                schedule => "first",
                                ensure => "installed"
                        }
                package {"ensure tomcat6 coors":
                                name => 'tomcat6',
                                schedule => "first",
                                version => "7.0.29",
                                ensure => "installed"
                        }
                file    {"install sample app for tomcat6":
                                path => "/var/lib/tomcat6/webapps/sample.war",
                                schedule => "first",
                                source=> "puppet:///modules/schedule/sample.war"
                         }
                file    {"install users file for tomcat6":
                                path => "/etc/tomcat6/tomcat-users.xml",
                                schedule => "first",
                                source => "puppet:///modules/schedule/tomcat-use$
                                notify => Service['tomcat6'],
                         }
                service { 'tomcat6':
                        schedule => "first",
                        ensure    => running,
                        enable    => true,
                        }
                service { 'tomcat7':
                        schedule => "third",
                        ensure    => running,
                        enable    => true,
                        }

                package {["tomcat6, tomcat6-common", "libtomcat6-java"]:
                                schedule => "third",
                                ensure => "absent"
                        }
                package {["tomcat7, tomcat7-common", "libtomcat7-java"]:
                                schedule => "first",
                                ensure => "absent"
                        }
                package {"ensure tomcat7 coors":
                                name => 'tomcat7',
                                schedule => "third",
                                ensure => "installed"
                        }
                package {"ensure tomcat7-admin coors":
                                name => 'tomcat7-admin',
                                schedule => "third",
                                ensure => "installed"
                        }
                file    {"install users file for tomcat7":
                                path => "/etc/tomcat7/tomcat-users.xml",
                                schedule => "third",
                                source=> "puppet:///modules/schedule/tomcat-user$
                         }
                file    {"sample for tomcat7":
                                path => "/var/lib/tomcat7/webapps/sample.war",
                                schedule => "third",
                                source=> "puppet:///modules/schedule/sample.war"
                        }
        }
        elsif $hostname == "becks"
        {
                package {"ensure tomcat7 becks":
                                name => 'tomcat7',
                                schedule => "second",
                                ensure => "installed"
                        }
                package {"ensure tomcat7-admin becks":
                                name => 'tomcat7-admin',
                                schedule => "second",
                                ensure => "installed"
                        }
                service { 'tomcat7':
                        schedule => "third",
                        ensure    => running,
                        enable    => true,
                        }

                file    {"sample for tomcat7 becks":
                                path => "/var/lib/tomcat7/webapps/sample.war",
                                schedule => "second",
                                source=> "puppet:///modules/schedule/sample.war"
                        }

                file    {"install users file for tomcat7":
                                path => "/etc/tomcat7/tomcat-users.xml",
                                schedule => "second",
                                source=> "puppet:///modules/schedule/tomcat-user$
                                notify => Service['tomcat7']
                        }

        }
        elsif $hostname == "bluemoon"
        {
                apache::vhost { "switch to becks":
                    schedule => "second",
                    servername => "bluemoon.swift.com",
                    docroot => "/var/www",
                    port => 80,
                    proxy_dest => "http://becks.swift.com:8080"
                }
               apache::vhost { "switch to coors":
                    schedule => "first",
                    servername => "bluemoon.swift.com",
                    docroot => "/var/www",
                    port => 80,
                    proxy_dest => "http://coors.swift.com:8080"
                }

                exec { "reload":
                        command => "/etc/init.d/apache2 reload",
                        refreshonly => true,
                     }
        }
}

