require 'fastlane/action'
require 'fastlane_core'
require_relative '../helper/flutter_utils_helper'

module Fastlane
  module Actions
    class IncrementSemanticVersionAction < Action
      def self.run(params)
        helper = Helper::FlutterUtilsHelper.new
        helper.increment_sem_ver(sem_ver: params[:sem_ver], increment_type: params[:increment_type])
      end

      def self.description
        "Automatic versioning of a Flutter app"
      end

      def self.authors
        ["Jonathan Ferreira"]
      end

      def self.return_value
        "Return an incremented semantic version"
      end

      def self.details
        "This plugin is used to separately version a Flutter app for IOS and Android"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(
            key: :sem_ver,
            env_name: "SEM_VER",
            description: "Actual semantic version",
            optional: true,
            type: String,
            default_value: 'Runner'
          ),
          FastlaneCore::ConfigItem.new(
            key: :increment_type,
            env_name: "INCREMENT_TYPE",
            description: "Increment type",
            optional: true,
            type: String,
            default_value: 'path'
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
