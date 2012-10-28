require File.expand_path('../spec_helper', __FILE__)

module Pod
  describe Version do
    describe "In general" do

      it "returns whether it is a `head` version" do
        version = Version.new('1.2.3')
        version.should.not.be.head
        version.head = true
        version.should.be.head
      end

      it "initializes from a string" do
        version = Version.from_string('1.2.3')
        version.should.not.be.head
      end

      it "serializes to a string" do
        version = Version.new('1.2.3')
        version.to_s.should == '1.2.3'
      end

      it "preserves head information when initializing from a string" do
        version = Version.from_string('HEAD based on 1.2.3')
        version.should.be.head
      end

      it "preserves head information when serializing to a string" do
        version = Version.from_string('1.2.3')
        version.head = true
        version.to_s.should == 'HEAD based on 1.2.3'
      end

      it "supports the previous way that a HEAD version was described" do
        version = Version.from_string('HEAD from 1.2.3')
        version.should.be.head
        version.to_s.should == 'HEAD based on 1.2.3'
      end
    end
  end
end
