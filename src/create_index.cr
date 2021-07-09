###############################################
# DEFINE THE OPTIONPARSER
###############################################

module StaticAlbumCreatorFunctions 
  extend self

  def create_index(directory, subdirectories, number_of_thumbnails, accepted_formats)

    subdirectories.map!{|subdirectory| subdirectory.split("/").last}
    File.open("#{directory}/index.html", mode="w") do |f|
      f << "<html><body><center><h2><table>"
        subdirectories.sort.reverse.each do |subdirectory|
           thumbnails=select_thumbnails_for_index(directory, subdirectory, number_of_thumbnails, accepted_formats)
           f << "<tr><td><h2><a href=\"#{subdirectory}/thumbs/index.html\">#{subdirectory}</a></h2></td><td>#{thumbnails}</td></tr>"
        end
      f << "</table></h2></center></body></html>"
    end
  end

end
