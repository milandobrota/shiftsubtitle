#!/usr/bin/env ruby

require 'rubygems'
require 'spec'
require File.join(File.dirname(__FILE__), '..', 'lib', 'shiftsubtitle', 'shifter')
require File.join(File.dirname(__FILE__), 'arrayextension')

describe ShiftSubtitle::OptionParser do
  it "should parse command line options (add)" do
    ARGV.clear.merge ['--operation', 'add', '--time', '03,500',  File.join('subtitles', 'sub.srt'), File.join('subtitles', 'shifted.srt')]
    ShiftSubtitle::OptionParser.parse.should == {:oadd=>true, :osub=>false, :offset=>"03,500", :input_file_path=>"subtitles/sub.srt", :output_file_path=>"subtitles/shifted.srt"}
  end
  
  it "should parse command line options (subtract)" do
    ARGV.clear.merge ['--operation', 'sub', '--time', '03,500', File.join('subtitles', 'sub.srt'), File.join('subtitles', 'shifted.srt')]
    ShiftSubtitle::OptionParser.parse.should == {:oadd=>false, :osub=>true, :offset=>"03,500", :input_file_path=>"subtitles/sub.srt", :output_file_path=>"subtitles/shifted.srt"}
  end
  
  it "should let you know if operation is incorrect" do
    ARGV.clear.merge ['--operation', 'incorrect', '--time', '03,500', File.join('subtitles', 'sub.srt'), File.join('subtitles', 'shifted.srt')]
    $stdout.should_receive(:write).with("--operation accepts add or sub")
    $stdout.should_receive(:write).with("\n")
    Process.should_receive(:exit)
    ShiftSubtitle::OptionParser.parse
  end
  
  it "should let you know if offset is incorrect" do
    ARGV.clear.merge ['--operation', 'sub', '--time', '3,500', File.join('subtitles', 'sub.srt'), File.join('subtitles', 'shifted.srt')]
    $stdout.should_receive(:write).with("--time accepts SS,MMM format")
    $stdout.should_receive(:write).with("\n")
    Process.should_receive(:exit)
    ShiftSubtitle::OptionParser.parse
  end
end
