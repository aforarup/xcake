module Xcake
  class Command
    class Echo < Command
      self.summary = 'Tells which xcake is being used'
      self.description = 'Tells which xcake is being used'

      def run
        puts 'Arup'
      end
    end
  end
end
