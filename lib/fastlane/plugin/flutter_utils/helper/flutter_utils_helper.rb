require 'fastlane_core/ui/ui'
require "xcodeproj"
require 'yaml'
require 'yaml/store'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?(:UI)

  module Helper
    class FlutterUtilsHelper
      # class methods that you define here become available in your action
      # as `Helper::FlutterUtilsHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the flutter_versioning plugin helper!")
      end

      def set_version_number(version_number, target, xcodeproj_path: nil)
        UI.message("Settings version number #{version_number} in #{target} target")

        xc_project_path = xcodeproj_path || find_xcode_project_path
        xc_project_path = "#{Dir.getwd}/#{xc_project_path}" if xcodeproj_path
        project = find_xcode_project(xc_project_path)

        xc_target = find_xcode_target_by_name(project, target)
        xc_target.build_configurations.each do |build_configuration|
          build_configuration.build_settings["MARKETING_VERSION"] = version_number
        end
        project.save
      end

      def set_build_number(build_number, target, xcodeproj_path: nil)
        UI.message("Settings build number #{build_number} in #{target} target")

        xc_project_path = xcodeproj_path || find_xcode_project_path
        full_path = "#{Dir.getwd}/#{xc_project_path}"
        project = find_xcode_project(full_path)

        xc_target = find_xcode_target_by_name(project, target)
        xc_target.build_configurations.each do |build_configuration|
          build_configuration.build_settings["CURRENT_PROJECT_VERSION"] = build_number
        end
        project.save
      end

      def increment_sem_ver(sem_ver:, increment_type:)
        unless /\d+\.\d+\.\d+/ =~ sem_ver
          raise "Your semantic version must match the format 'X.X.X'."
        end
        unless ["patch", "minor", "major"].include?(increment_type)
          raise "Only 'patch', 'minor', and 'major' are supported increment types."
        end

        major, minor, patch = sem_ver.split(".")
        case increment_type
        when "patch"
          patch = patch.to_i + 1
        when "minor"
          minor = minor.to_i + 1
        when "major"
          major = major.to_i + 1
        end

        "#{major}.#{minor}.#{patch}"
      end

      def get_flutter_version_number(pubspec_path:)
        version = get_flutter_version(pubspec_path)
        UI.message("Current version #{version}")
        version.split('+')[0]
      end

      def get_flutter_build_number(pubspec_path:)
        version = get_flutter_version(pubspec_path)
        UI.message("Current build number #{version}")
        version.split('+')[1]
      end

      def set_flutter_version_number(version:, pubspec_path:)
        current_build_number = get_flutter_build_number(pubspec_path: pubspec_path)
        version = "#{version}+#{current_build_number}"
        update_flutter_version(version: version, pubspec_path: pubspec_path)
      end

      def set_flutter_build_number(build:, pubspec_path:)
        current_version_number = get_flutter_version_number(pubspec_path: pubspec_path)
        version = "#{current_version_number}+#{build}"
        update_flutter_version(version: version, pubspec_path: pubspec_path)
      end

      def increment_flutter_build_number(value:, pubspec_path:)
        current_build_number = get_flutter_build_number(pubspec_path: pubspec_path)
        value = 1 if value.nil?
        UI.message("Current build number #{current_build_number}")
        incremented_build_number = current_build_number.to_i + value.to_i
        current_version_number = get_flutter_version_number(pubspec_path: pubspec_path)

        UI.message("Incremented build number #{incremented_build_number}")

        version = "#{current_version_number}+#{incremented_build_number}"
        update_flutter_version(version: version, pubspec_path: pubspec_path)
      end

      def increment_flutter_version_number(increment_type:, pubspec_path:)
        current_version_number = get_flutter_version_number(pubspec_path: pubspec_path)
        current_build_number = get_flutter_build_number(pubspec_path: pubspec_path)
        incremented_version_number = increment_sem_ver(sem_ver: current_version_number, increment_type: increment_type)

        UI.message("Current version number #{current_version_number}")
        UI.message("Incremented version number #{incremented_version_number}")

        version = "#{incremented_version_number}+#{current_build_number}"
        update_flutter_version(version: version, pubspec_path: pubspec_path)
      end

      private

      def update_flutter_version(version:, pubspec_path:)
        pubspec = YAML.safe_load(File.read(pubspec_path))
        pubspec['version'] = version

        data = File.read(pubspec_path)
        current_version = get_flutter_version(pubspec_path)
        new_contents = data.gsub(current_version, version)
        puts(new_contents)

        File.open(pubspec_path, "w") { |file| file.puts(new_contents) }
      end

      def get_flutter_version(path)
        pubspec = YAML.safe_load(File.read(path))
        UI.message("Get flutter version #{pubspec['version']}")
        pubspec['version']
      end

      def find_xcode_project_path
        absolute_dir_path = Dir.getwd
        loop do
          entries = Dir.entries(absolute_dir_path)
          index = entries.find_index { |entry| entry.include?(".xcodeproj") }
          unless index.nil?
            return "#{absolute_dir_path}/#{entries[index]}"
          end

          absolute_dir_path = File.dirname(absolute_dir_path)
          if absolute_dir_path.nil? || absolute_dir_path == "/"
            break
          end
        end

        raise(StandardError, "Xcode project not found")
      end

      def find_xcode_project(xc_project_path)
        xc_codeproj = Xcodeproj::Project.open(xc_project_path)
        raise(StandardError, "Project not found") if xc_codeproj.nil?

        xc_codeproj
      end

      def find_xcode_target_by_name(project, target_name)
        xc_target = project.targets.find { |target| target.name == target_name }
        raise(StandardError, "Target not found") if xc_target.nil?

        xc_target
      end
    end
  end
end
