# frozen_string_literal: true

require 'erb'
require 'fileutils'

# This script generates an SDF model from an ERB template.
# It takes the following arguments:
# ARGV[0]: model_name (e.g., "robot_0", "robot_1") - used as the namespace for topics
# ARGV[1]: erb_template_path (e.g., "path/to/drone_model.erb")
# ARGV[2]: output_sdf_path (e.g., "/tmp/model_0.sdf")
# ARGV[3]: x_coordinate for the drone's initial pose
# ARGV[4]: y_coordinate for the drone's initial pose

if ARGV.length < 5
  puts "Usage: ruby generate_drone_model.rb <model_name> <erb_template_path> <output_sdf_path> <x_pose> <y_pose>"
  exit 1
end

# Assign command-line arguments to Ruby variables
model_name = ARGV[0]
erb_template_path = ARGV[1]
output_sdf_path = ARGV[2]
x_pose = ARGV[3].to_f
y_pose = ARGV[4].to_f

# Default Z pose and orientation (can be extended if needed)
z_pose = 0.5
roll_pose = 0.0
pitch_pose = 0.0
yaw_pose = 0.0

# Read the ERB template file
template = File.read(erb_template_path)

# Create an ERB object and render the template.
# `binding` makes the local variables (model_name, x_pose, etc.) available within the ERB template.
erb = ERB.new(template)
rendered_sdf_content = erb.result(binding)

# Ensure the output directory exists
output_dir = File.dirname(output_sdf_path)
FileUtils.mkdir_p(output_dir) unless File.directory?(output_dir)

# Write the rendered SDF content to the output file
File.write(output_sdf_path, rendered_sdf_content)

puts "Successfully generated SDF model for '#{model_name}' at '#{output_sdf_path}'"
