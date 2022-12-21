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

    it 'prints a error when xcodeproj is not found' do
      expect { Fastlane::Actions::SetIosVersionNumberAction.run(target_name: 'any', version: 'any') }.to raise_error
    end

    it 'increment patch' do
      new_version = Fastlane::Actions::IncrementSemanticVersionAction.run(sem_ver: '1.1.1', increment_type: 'patch')
      expect(new_version).to eq('1.1.2')
    end

    it 'increment minor' do
      new_version = Fastlane::Actions::IncrementSemanticVersionAction.run(sem_ver: '1.1.1', increment_type: 'minor')
      expect(new_version).to eq('1.2.1')
    end

    it 'increment major' do
      new_version = Fastlane::Actions::IncrementSemanticVersionAction.run(sem_ver: '1.1.1', increment_type: 'major')
      expect(new_version).to eq('2.1.1')
    end
  end
end
