# Script to build uranium into a single file
#############################################
# TODO - To support the blackberry/IE xui versions, I can just add different yaml files
# 

require 'yaml'

if ARGV.size == 0
  puts "Syntax: ruby enrich.rb  build_config_name.yaml"
  exit
end

compilation_modes = YAML::load(File.open("compilation_modes.yaml","r") {|f| f.read})

compilation_modes.each do |compilation_mode|
  options = []
  options << ["js_output_file", "uranium#{compilation_mode[:output_suffix]}.js"]

  compilation_mode[:options].each do |option|
    options << option
  end


  build_options = YAML::load(File.open(ARGV[0],"r") {|f| f.read} )

  files = [build_options[:external],
           build_options[:global],
           build_options[:widgets]].flatten 

  puts "Sources:"
  puts "-"*10   
  puts files
  puts "-"*10   

  files.each do |widget|
    options << ["js", File.join("../",widget)]
  end

  options.collect! do |option|
    "--#{option[0]} #{option[1]}"
  end

  %x`java -jar ./compiler/compiler.jar #{options.join(" ")}`

end