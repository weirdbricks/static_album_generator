###############################################
# DEFINE THE OPTIONPARSER
###############################################

module StaticAlbumCreatorFunctions 
  extend self

  def optionparse
    # defining some empty variables as placeholders
    directory    = String.new
    yes_redo_all = false

    parser = OptionParser.parse do |parser|
      parser.banner = "Usage: [arguments]"
      parser.on("-d DIRECTORY","--directory=DIRECTORY", "Specifies the directory that includes your photos") { |_directory| directory = _directory }
      parser.on("--yes_redo_all", "Redo all resizing! (Default: off)") { yes_redo_all = true }
      parser.on("-h", "--help", "Show this help") do
        puts parser
        exit(1)
      end
      # do this if the option has no value associated with it
      parser.missing_option do |flag|
        STDERR.puts "ERROR: #{flag} value is missing."
        STDERR.puts parser
        exit(1)
      end
      # do this if the option isn't set
      parser.invalid_option do |flag|
        STDERR.puts "ERROR: #{flag} is not a valid option."
        STDERR.puts parser
        exit(1)
      end
      # if no arguments, then show the help and exit
      if ARGV.size == 0
        STDERR.puts parser
        exit(1)
      end
    end
  return directory, yes_redo_all
  end
end
