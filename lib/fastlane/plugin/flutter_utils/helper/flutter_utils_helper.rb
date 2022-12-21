require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class FlutterUtilsHelper
      # class methods that you define here become available in your action
      # as `Helper::FlutterUtilsHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the flutter_versioning plugin helper!")
      end


      def set_version_number(version_number, target)
        UI.message("Settings version number #{version_number} in #{target} target")

        xc_project_path = find_xcode_project_path
        project = find_xcode_project(xc_project_path)

        xc_target = find_xcode_target_by_name(project, target)
        xc_target.build_configurations.each { |build_configuration| 
            build_configuration.build_settings["MARKETING_VERSION"] = version_number
        }
        project.save
      end

      def set_build_number(build_number, target)
        UI.message("Settings build number #{build_number} in #{target} target")

        xc_project_path = find_xcode_project_path
        project = find_xcode_project(xc_project_path)

        xc_target = find_xcode_target_by_name(project, target)
        xc_target.build_configurations.each { |build_configuration| 
          build_configuration.build_settings["CURRENT_PROJECT_VERSION"] = build_number
        }
        project.save
      end

      private

      def find_xcode_project_path
        absolute_dir_path = Dir.getwd
        loop do
            entries = Dir.entries(absolute_dir_path)
            index = entries.find_index{ |entry| entry.include?(".xcodeproj") }
            if index != nil
              return "#{absolute_dir_path}/#{entries[index]}"
            end
    
            absolute_dir_path = File.dirname(absolute_dir_path)
            if absolute_dir_path == nil || absolute_dir_path == "/"
              break
            end
        end
    
        raise(StandardError, "Xcode project not found")
      end

      def find_xcode_project(xc_project_path)
        xc_codeproj = Xcodeproj::Project.open(xc_project_path)
        raise(StandardError, "Project not found") if xc_codeproj == nil
        xc_codeproj
      end

      def find_xcode_target_by_name(project, target_name)
        xc_target = project.targets.find { |target| target.name == target_name }
        raise(StandardError, "Target not found") if xc_target == nil
        xc_target
      end
    end
  end
end