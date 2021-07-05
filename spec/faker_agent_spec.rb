require 'rails_helper'
require 'huginn_agent/spec_helper'

describe Agents::FakerAgent do
  before(:each) do
    @valid_options = Agents::FakerAgent.new.default_options
    @checker = Agents::FakerAgent.new(:name => "FakerAgent", :options => @valid_options)
    @checker.user = users(:bob)
    @checker.save!
  end

  pending "add specs here"
end
