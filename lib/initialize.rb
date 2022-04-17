require 'pathname'

file_pathname = Pathname.new(__FILE__)
lib_pathname = file_pathname.parent

require lib_pathname.join('pulse-utils').to_s
