require 'fastlane/action'
require 'fastlane_core'
require_relative '../helper/flutter_utils_helper'

module Fastlane
  module Actions
    class SetIosVersionNumberAction < Action
      def self.run(params)
        helper = Helper::FlutterUtilsHelper.new
        helper.set_version_number(params[:version], params[:target_name], xcodeproj_path: params[:xcodeproj])
        UI.message("Successfully updated version number!")
      end

      def self.description
        "Automatic versioning of a Flutter app"
      end

      def self.authors
        ["Jonathan Ferreira"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        "This plugin is used to separately version a Flutter app for IOS and Android"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :target_name,
            env_name: "TARGET_NAME",
            description: "The target name",
            optional: true,
            type: String,
            default_value: 'Runner'
          ),
          FastlaneCore::ConfigItem.new(
            key: :version,
            env_name: "IOS_VERSION",
            description: "The version of iOS app",
            optional: false,
            type: String
          ),
          FastlaneCore::ConfigItem.new(
            key: :xcodeproj,
            env_name: "XCODEPROJ_PATH",
            description: "The path to xcodeproj",
            optional: true,
            type: String,
            default_value: 'Runner.xcodeproj'
          )
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
