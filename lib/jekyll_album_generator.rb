# Copyright 2015 Johan Ask.
# E-mail: jhnesk@gmail.com
#
# This file is part of Jekyll Album Generator.
#
# Jekyll Album Generator is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Jekyll Album Generator is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with Jekyll Album Generator. If not, see <http://www.gnu.org/licenses/>.
#
require "exifr"

module Jekyll

	class AlbumGenerator < Generator

		def generate(site)
			file = 	File.open("_data/albums.yml", "w")
			print_albums(file)
			file.close
		end

		def print_albums(output)
			Dir.glob('albums/*').each do |album|
				print_album(output, album)
			end
		end

		def print_album(output, dir)
			output.puts '- album: ' + File.basename(dir)
			output.puts '  photos:'
			Dir.glob(dir + '/*.jpg').each do |image|
				print_image(output, image)
			end
		end

		def print_image(output, image)
			exif = EXIFR::JPEG.new(image)
			output.puts '    - image   : ' + File.basename(image)
			output.puts '      time    : ' + exif.date_time.to_s
			output.puts '      width   : ' + exif.width.to_s
			output.puts '      height  : ' + exif.height.to_s
			if(exif.gps)
				output.puts '      gps:'
				output.puts '        longitude: ' + exif.gps.longitude.to_s
				output.puts '        latitude : ' + exif.gps.latitude.to_s
			end
		end
	end
end
