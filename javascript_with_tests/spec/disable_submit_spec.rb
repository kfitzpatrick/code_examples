require "#{File.dirname(__FILE__)}/javascript_spec_helper"

run_javascript_spec("disable_submit", "/messages/new.html.erb") do
  assigns[:message] = Message.new
end