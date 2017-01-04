require './spec_helper'

describe ec2('base') do
  it { should be_running }
  its(:image_id) { should eq 'ami-24506250' }
end