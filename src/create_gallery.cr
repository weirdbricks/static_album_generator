###############################################
# DEFINE THE OPTIONPARSER
###############################################

module StaticAlbumCreatorFunctions 
  extend self
    def create_gallery(subdirectory, files, photos_per_row)
      # get all files in subdirectory/thumbs
      # create a table with thumbnails inside as images and links 
      # add a link for the full image file to make it easy to download them
      
      # sort the array
      files.sort!

      # write out the index for the thumbs/ directory
      File.open("#{subdirectory}/thumbs/index.html", mode="w+") do |f|
        f << "<html>"
        f << "\n<center><h2><a href=\"/\">Home</a></h2></center><p>"
	f << "\n<table>"
        files.each_slice(photos_per_row) do |slice|
	  f << "\n<tr>"
	  slice.each do |image|
            f << "\n<td><a href=\"#{image}.html\"><img src=\"#{image}\"></a></td>"
	  end
	  f << "\n</tr>"
	end
	f << "\n</table>"
        f << "\n</html>"
      end
  end
end
