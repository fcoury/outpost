require 'test_helper'

require 'outpost/scouts'

describe "using SSH backed DSL" do
  class ExampleServerLoad < Outpost::DSL
    # this scout will connect to the server via SSH
    using Outpost::Scouts::Ssh => 'master http server' do
      # it will connect to 10.0.1.1, on port 22 using fcoury as the user
      # this example implies that the authentication will take place
      # using public key authentication
      # once connected, it will execute the "w" command, that outputs:
      # $ w
      #  18:58:38 up 59 days, 16:47,  1 user,  load average: 0.90, 0.62, 0.61
      # USER     TTY      FROM              LOGIN@   IDLE   JCPU   PCPU WHAT
      # 1btAdm1n pts/0    10.0.1.230       10:16    0.00s  0.49s  0.04s sshd: 1btAdm1n [priv]
      options :server => '10.0.1.1', :port => '22', :user => 'fcoury', :command => 'w'
      
      # it will be reported as up if the output (those 3 lines)
      # contain the text "load average: xx, xx, xx" and will
      # take the first number as the parameter for less_than
      report :up, :output => {
        :match => /load average: (.+), .+, .+/,
        :result => {
          :less_than => 1
        }
      }
    end

    # this is a completely equivalent scout that abstracts the 
    # command to run and how to parse the output
    # using Outpost::Scouts::ServerLoad => 'master http server' do
    #   options :server => '10.0.1.1', :port => '22', :user => 'fcoury'
    #   report :up, :load => { :less_than => 1 }
    # end
  end
  
end