require "test/unit"
require "#{File.dirname(__FILE__)}/../lib/pressman"

class Test::Unit::TestCase

 def self.must(name, &block)
   test_name = "test_#{name.gsub(/\s+/,'_')}".to_sym
   defined = instance_method(test_name) rescue false
   raise "#{test_name} is already defined in #{self}" if defined
   if block_given?
     define_method(test_name, &block)
   else
     define_method(test_name) do
       flunk "No implementation provided for #{name}"
     end
   end
 end
 
 def self.setup(&block)
   define_method :setup, &block
 end
 
 def self.teardown(&block)
   define_method :teardown, &block
 end

end

def describe(name, &block)
  klass = Class.new(Test::Unit::TestCase)
  klass.instance_eval(&block)
end


