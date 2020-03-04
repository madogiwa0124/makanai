# frozen_string_literal: true

module Makanai
  module Dbms
    class Base
      def db
        raise NotImplementedError
      end

      def execute_sql
        raise NotImplementedError
      end
    end
  end
end
