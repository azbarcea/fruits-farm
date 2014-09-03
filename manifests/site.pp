include all

node 'becks.swift.com', 'coors.swift.com', 'bluemoon.swift.com' {
      include schedule
      include apache
}

node 'tap.swift.com' {
     include graphite
}



