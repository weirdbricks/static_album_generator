###############################################
# DEFINE THE OPTIONPARSER
###############################################

module StaticAlbumCreatorFunctions 
  extend self

  def select_thumbnails_for_index(directory, subdirectory, number_of_thumbnails, accepted_formats)
    selected_thumbnails = 0
    output = ""
    files=Dir.entries("#{directory}/#{subdirectory}/thumbs")
    # remove files that their extensions don't match the ones in the "accepted_formats"
    files.reject! { |item| !accepted_formats.includes?(File.extname("#{directory}/#{subdirectory}/#{item}")) }
    # remove any items that are directories
    files.reject! { |item| File.directory?("#{directory}/#{subdirectory}/#{item}") }
    if files.size < number_of_thumbnails
      number_of_thumbnails=files.size
    end
    selected_thumbnails = files.sample(number_of_thumbnails)
    selected_thumbnails.each do |thumb_image|
      output="#{output}<img src=\"#{subdirectory}/thumbs/#{thumb_image}\">"
    end
    return output
  end
end
