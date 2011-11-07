require 'spec_helper'

describe Guard::AssetCopy do
  subject { Guard::AssetCopy.new }

  describe 'run all' do
    it 'should rebuild all files being watched' do
      Guard::AssetCopy.stub(:run_on_change).with([]).and_return([])
      Guard.stub(:guards).and_return([subject])
      subject.run_all
    end
  end

  describe '#get_output' do
    context 'by default' do
      it 'should return app/assets/javascripts/test.js as public/assets/test.js' do
        subject.get_output('app/assets/javascripts/test.js').should eq('public/assets/test.js')
      end

      it 'should return app/assets/javascripts/yay/test.js as public/assets/yay/test.js' do
        subject.get_output('app/assets/javascripts/yay/test.js').should eq('public/assets/yay/test.js')
      end

      it 'should return app/assets/javascripts/yay/woo/test.js as public/assets/yay/woo/test.js' do
        subject.get_output('app/assets/javascripts/yay/woo/test.js').should eq('public/assets/yay/woo/test.js')
      end
    end
  end

end
