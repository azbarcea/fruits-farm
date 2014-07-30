class all{
        file { '/tmp/testtest':
                content => "test to see if puppet is running."
             }
       package {["git", "openjdk-6-jdk"]:
		ensure => "installed"
		}

}
