# frozen_string_literal: true

require 'spec_helper'
require_relative '../lib/application.rb'

describe Makanai::Application do
  it 'respond to call.' do
    expect(Makanai::Application.new(router: nil)).to respond_to :call
  end
end
