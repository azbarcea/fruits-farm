class schedule{
	schedule {"first":
		range => "14:00 - 14:22",
		repeat=> 2
	 	 }
        schedule {"second":
                range => "14:22 - 14:27",
                repeat=> 2
                 }
        schedule {"third":
                range => "14:27 - 17:00",
                repeat=> 10000
                 }

	if $hostname == "coors" 
	{
		package {"ensure tomcat6 coors":
				name => 'tomcat6',
				schedule => "first",
				ensure => "installed"
			}
	        file	{"install sample app for tomcat6":
				path => "/var/lib/tomcat6/webapps/sample.war",
                		schedule => "first",
				source=> "puppet:///modules/schedule/sample.war"
               		 }
                package {["tomcat6, tomcat6-common", "libtomcat6-java"]:
                        	schedule => "third",
                        	ensure => "absent"
                        }
                package {"ensure tomcat7 coors":
				name => 'tomcat7',
                        	schedule => "third",
                        	ensure => "installed"
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
                file    {"sample for tomcat7 becks":
				path => "/var/lib/tomcat7/webapps/sample.war",
                        	schedule => "second",
                        	source=> "puppet:///modules/schedule/sample.war"
                        }
	}
	elsif $hostname == "bluemoon"
	{
#		package {"ensure apache2 is installed":
#				name => "apache2",
#				ensure => "installed"
#			}
		
#		a2mod { "Enable proxy mod":
#		    name => "proxy",
#		    ensure => "present"
#		}
 #
#		a2mod { "Enable proxy_http mod":
#		    name => "proxy_http",
#		    ensure => "present"
#		}
 
		apache::vhost { "bluemoon.swift.com":
		    servername => "bluemoon.swift.com",
		    docroot => "/var/www",
		    port => 80,
		    proxy_dest => "http://becks.swift.com:8080"
		}

		file    {"proxy pass from coors to becks":
                                path => "/etc/apache2/sites-available/000-default.conf",
#                                schedule => "second",
                                source=> "puppet:///modules/schedule/beckchange"
                        }

#                file    {"proxy pass becks to coors":
#                                path => "/etc/apache2/sites-available/000-default.conf",
#                                schedule => "first"
#                                source => "puppet:///modules/schedule/coorschange"
#                        }
#                file    {"proxy pass becks to coors2":
#                                path => "/etc/apache2/sites-available/000-default.conf",
#                                schedule => "third",
#                                source=> "puppet:///modules/schedule/coorschange"
#                        }
		exec { "reload":
                	command => "/etc/init.d/apache2 reload",
                	refreshonly => true,
#                	require => Service[[apache2]],
	             }

	}


}
