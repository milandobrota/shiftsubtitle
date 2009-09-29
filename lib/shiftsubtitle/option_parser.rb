#!/usr/bin/env ruby

require 'optparse'
require File.join(File.dirname(__FILE__), "..", "string")


module ShiftSubtitle
  class OptionParser
    
    def self.parse
      options = {}
      begin
        ::OptionParser.new do |opts|
          # Set a banner, displayed at the top
          # of the help screen.
          opts.banner = "Usage: shift_subtitle.rb [options] input_file output_file"

          # Define the options, and what they do       
          options[:offset] = false
          opts.on("-t", "--time TIME", "Enter TIME") do |delay_time|
            if delay_time.subtitle_offset_format?
              options[:offset] = delay_time
            else
              puts "--time accepts SS,MMM format"
              Process.exit
            end
          end
          
          options[:oadd] = options[:osub] = false
          opts.on( '-o', "--operation OPERATION", 'Add/Subtract' ) do |operation|
            if operation == 'add'
              options[:oadd] = true
            elsif operation == 'sub'
              options[:osub] = true
            else
              puts "--operation accepts add or sub"
              Process.exit
            end
          end

          # This displays the help screen, all programs are
          # assumed to have this option.
          opts.on( '-h', '--help', 'Display this screen' ) do
            puts opts
            exit
          end
        end.parse!
      rescue ::OptionParser::MissingArgument
        puts "argument missing"
      end
      options[:input_file_path], options[:output_file_path] = ARGV
      options
    end
  end
end
