###############################################
# DEFINE THE OPTIONPARSER
###############################################

module StaticAlbumCreatorFunctions 
  extend self
    def create_single_photo_viewer(subdirectory, files)
      # get all files in subdirectory/thumbs
      # create a table with thumbnails inside as images and links 
      # add a link for the full image file to make it easy to download them
      
      # sort the array
      files.sort!

      # the css header
      css_header = %q(
        <html>
          <head>
            <style>
              img {
                width:80%;
                height: auto;
              }
            </style>
          </head>
          <body>
	    <center>
      )

      # create HTML for a page that's a placeholder for the image :)
      files.each_with_index do |image, index|
        File.open("#{subdirectory}/thumbs/#{image}.html", mode="w+") do |f|
          f << css_header
          unless files[index]==files.last
            f << "<a href=\"index.html\">Back to album</a><p>"
            f << "<a href=\"#{files[index+1]}.html\"><img src=\"../#{image}\"></a>"
          else
	    f << "<a href=\"index.html\">Back to album</a><p>"
            f << "<a href=\"index.html\"><img src=\"../#{image}\"></a>"
          end
	  f << "\n</center>"
          f << "\n</body>\n</html>"
	end
      end
  end
end
