require 'test_helper'
require 'ostruct'

require 'test_helper'

describe Outpost::Expectations::Ssh::Output do
  class SubjectBody
    class << self
      attr_reader :expectation, :evaluation_method

      def expect(expectation, evaluation_method)
        @expectation       = expectation
        @evaluation_method = evaluation_method
      end

    end
    extend Outpost::Expectations::Ssh::Output
  end
  
  describe ".evaluate_output with match" do
    it "should return true when it matches" do
      assert SubjectBody.evaluate_output(scout_mock, :match => /load average: (.+), .+, .+/, :less_than => 1)
    end
    
    it "should return false when it doesn't" do
      refute SubjectBody.evaluate_output(scout_mock, :match => /omfgz/)
    end
  end

  describe ".evaluate_output with match and less_than" do
    it "should return true when it matches and the captured group is less than the value specified" do
      assert SubjectBody.evaluate_output(scout_mock, :match => /load average: (.+), .+, .+/, :less_than => 1)
    end
    
    it "should return false when the captured group is not less than the value specified" do
      refute SubjectBody.evaluate_output(scout_mock, :match => /load average: (.+), .+, .+/, :less_than => 0.1)
    end
  end

  # describe ".evaluate_output with not_match" do
  #   it "should return true when it matches" do
  #     assert SubjectBody.evaluate_output(scout_mock, :not_match => /omfgz/)
  #   end
  # 
  #   it "should return false when it doesn't" do
  #     refute SubjectBody.evaluate_output(scout_mock, :not_match => /load/)
  #   end
  # end

  # describe ".evaluate_response_body with equals" do
  #   it "should return true when it matches" do
  #     assert SubjectBody.evaluate_response_body(scout_mock, :equals => "Hello!")
  #   end
  # 
  #   it "should return false when it doesn't" do
  #     refute SubjectBody.evaluate_response_body(scout_mock, :equals => "Hell")
  #   end
  # end
  # 
  # describe ".evaluate_response_body with differs" do
  #   it "should return true when it matches" do
  #     assert SubjectBody.evaluate_response_body(scout_mock, :differs => "Hell")
  #   end
  # 
  #   it "should return false when it doesn't" do
  #     refute SubjectBody.evaluate_response_body(scout_mock, :differs => "Hello!")
  #   end
  # end
  # 
  # describe ".evaluate_response_body with multiple rules" do
  #   it "should return true when all rules matches" do
  #     rules = {:differs => 'omg', :match => /ll/}
  #     assert SubjectBody.evaluate_response_body(scout_mock, rules)
  #   end
  # 
  #   it "should return false when there are no matches" do
  #     rules = {:equals => 'omg', :not_match => /ll/}
  #     refute SubjectBody.evaluate_response_body(scout_mock, rules)
  #   end
  # 
  #   it "should return false when at least one rule doesn't match" do
  #     rules = {:equals => 'Hello!', :match => /Hell/, :differs => 'Hello!'}
  #     refute SubjectBody.evaluate_response_body(scout_mock, rules)
  #   end
  # end
  # 
  # it "should set expectation correctly" do
  #   assert_equal :response_body, SubjectBody.expectation
  # end
  # 
  # it "should set evaluation method correctly" do
  #   assert_equal SubjectBody.method(:evaluate_response_body), \
  #     SubjectBody.evaluation_method
  # end

  private
  def scout_mock
    @scout_mock ||= OpenStruct.new.tap do |scout_mock|
      scout_mock.output = <<-EOS
 18:58:38 up 59 days, 16:47,  1 user,  load average: 0.90, 0.62, 0.61
USER     TTY      FROM              LOGIN@   IDLE   JCPU   PCPU WHAT
1btAdm1n pts/0    10.0.1.230       10:16    0.00s  0.49s  0.04s sshd: 1btAdm1n [priv]
EOS
    end
  end
end
