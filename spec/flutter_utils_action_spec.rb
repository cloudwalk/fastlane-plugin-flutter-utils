describe Fastlane::FlutterUtils do
  describe '#run' do
    it 'prints a message when the build number  action is running' do
      expect(Fastlane::UI).to receive(:message).with("Settings build number 20 in example target")
      expect(Fastlane::UI).to receive(:message).with("Successfully updated build number!")

      Fastlane::Actions::SetIosBuildNumberAction.run(target_name: 'example', build: '20', xcodeproj: 'spec/fixtures/example.xcodeproj')
    end

    it 'prints a message when the version number action is running' do
      expect(Fastlane::UI).to receive(:message).with("Settings version number 1.1.1 in example target")
      expect(Fastlane::UI).to receive(:message).with("Successfully updated version number!")

      Fastlane::Actions::SetIosVersionNumberAction.run(target_name: 'example', version: '1.1.1', xcodeproj: 'spec/fixtures/example.xcodeproj')
    end
  end
end
