# frozen_string_literal: true

require_relative './application.rb'
require_relative './router.rb'
require_relative './dsl.rb'

def router
  @router ||= Makanai::Router.new
end

# MEMO: When launching an application using rackup,
# the application starts even when the application ends.
# Therefore, start the application with `at_exit` only when started with `ruby app.rb`.
at_exit do
  Makanai::Application.new(router: @router).run! if $PROGRAM_NAME.to_s.match?(/.+\.rb/)
end
