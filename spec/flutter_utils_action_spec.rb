describe Fastlane::Actions::FlutterUtilsAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The flutter_utils plugin is working!")

      Fastlane::Actions::FlutterUtilsAction.run(nil)
    end
  end
end
