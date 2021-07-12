###############################################
# SET DEPENDENCIES
###############################################

# https://github.com/xtokio/imgkit 
require "imgkit"
require "option_parser"
require "./option_parser.cr"
require "./create_gallery.cr"
require "./create_index.cr"
require "./create_single_photo_viewer.cr"
require "./select_thumbnails_for_index.cr"
include StaticAlbumCreatorFunctions 

###############################################
# PARSE COMMAND LINE ARGUMENTS
###############################################

directory, yes_redo_all = optionparse
puts "directory: #{directory}"
puts "yes_redo_all: #{yes_redo_all}"

###############################################
# DIRECTORY CHECKS 
###############################################

unless Dir.exists?(directory)
  puts "The directory doesn't exist"
  exit 1
end

if Dir.empty?(directory)
  puts "The directory is empty"
  exit 1
end

if directory.ends_with?("/")
  puts "Removing ending \"/\" from the directory"
  # this will delete the last "/"
  directory=directory.rchop('/')
  puts "Adjusted directory: \"#{directory}\""
end

###############################################
# SETTINGS
###############################################

accepted_formats = [".jpg", ".jpeg", ".JPG", ".JPEG"]
directories_to_ignore = [ "yumrepo", "lost+found", "thumbs" ] 
thumbnails_per_row = 3
image_width = 250

###############################################
# GET SUBDIRECTORIES
###############################################

subdirectories = Dir.new(directory).children.select { |child| File.directory?("#{directory}/#{child}") }
puts "Subdirectories found: #{subdirectories}"

###############################################
# IGNORE SPECIFIC DIRECTORIES
###############################################
directories_to_ignore.each do |item|
  subdirectories.delete(item)
end

subdirectories.each do |subdirectory|
  if Dir.empty?("#{directory}/#{subdirectory}")
    puts "The subdirectory: #{subdirectory} is empty - removing from the list"
    subdirectories.delete(subdirectory)
  end
end

###############################################
# ITERATE OVER ALL SUBDIRECTORIES AND CREATE 
# THUMBNAILS
###############################################

start_time = Time.monotonic
total_images_counter=0
total_images_skipped=0
total_images_resized=0

subdirectories.each do |subdirectory|
  puts "Looking for images in directory: #{subdirectory}.."
  files=Dir.entries("#{directory}/#{subdirectory}")
  puts "Found #{files.size} files and directories in #{subdirectory}"
  puts "Removing directories..."
  if File.directory?("#{directory}/#{subdirectory}/thumbs")
    puts "#{directory}/#{subdirectory}/thumbs is a directory - removing"
    files.delete("thumbs")
  end
  files.reject! { |item| File.directory?("#{directory}/#{subdirectory}/#{item}") }
  puts "Found #{files.size} files in directory #{subdirectory}"
  puts "Checking if any of the files start with a \".\".."
  files.reject! { |item| item.starts_with?(".")}
  puts "Found #{files.size} files in directory: #{subdirectory}"
  puts "Checking for acceptable extensions..."
  files.reject! { |item| !accepted_formats.includes?(File.extname("#{directory}/#{subdirectory}/#{item}")) }
  puts "Found #{files.size} files in directory: #{subdirectory}"
  total_images_counter=total_images_counter+files.size
  thumb_dir = "#{directory}/#{subdirectory}/thumbs"
  unless Dir.exists?(thumb_dir)
    puts "Creating subdirectory for thumbnails: #{thumb_dir}"
    Dir.mkdir(thumb_dir)
  else
    puts "The subdirectory \"#{thumb_dir}\" already exists"
  end
  files.sort!
  files.each do |image|
    if File.exists?("#{directory}/#{subdirectory}/thumbs/#{image}") && yes_redo_all==false
      puts "Thumbnail exists: #{directory}/#{subdirectory}/thumbs/#{image}"
      total_images_skipped=total_images_skipped+1
    else
      total_images_resized=total_images_resized+1
      puts "Creating thumbnail #{directory}/#{subdirectory}/thumbs/#{image}.."
      img = ImgKit::Image.new("#{directory}/#{subdirectory}/#{image}")
      img.resize(width: image_width)
      img.save("#{directory}/#{subdirectory}/thumbs/#{image}")
      img.finish
    end
  end
  create_gallery("#{directory}/#{subdirectory}", files, thumbnails_per_row)
  create_single_photo_viewer("#{directory}/#{subdirectory}", files)
end

create_index(directory, subdirectories, thumbnails_per_row, accepted_formats)
elapsed_time = Time.monotonic - start_time
puts "======= COMPLETE ======="
puts "Total images found: #{total_images_counter}"
puts "Total images skipped: #{total_images_skipped}"
puts "Total images resized: #{total_images_resized}"
puts "Time: #{elapsed_time}"
