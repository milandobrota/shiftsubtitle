#!/usr/bin/env ruby

require 'rubygems'
require 'spec'
require File.join(File.dirname(__FILE__), '..', 'lib', 'shiftsubtitle', 'shifter')
require File.join(File.dirname(__FILE__), 'arrayextension')

describe ShiftSubtitle::Shifter do
  it "should call forward for each time line and write in file" do
    shifter = ShiftSubtitle::Shifter.new(
      :oadd => true,
      :osub => false,
      :offset => '02,300',
      :input_file_path => File.join('subtitles','sub.srt'),
      :output_file_path => File.join('subtitles','shifted.srt')
    )
    shifter.should_receive(:forward).with("01:59:59,210 --> 01:31:54,893\n").and_return('02:00:01,510 --> 01:31:57,193')
    shifter.should_receive(:forward).with("01:31:54,928 --> 01:31:57,664\n").and_return('01:31:57,228 --> 01:31:59,964')
    
    shifter.shift
    File.read(File.join('subtitles', 'shifted.srt')).should == File.read(File.join('subtitles', 'correct.srt'))
  end
  
  it "should recognize bad input file when created" do
    Process.should_receive(:exit)
    $stdout.should_receive(:write).with("input file is not properly set")
    $stdout.should_receive(:write).with("\n")
    shifter = ShiftSubtitle::Shifter.new(
      :oadd => true,
      :osub => false,
      :offset => '02,300',
      :input_file_path => File.join('subtitles','nonexistant.srt'),
      :output_file_path => File.join('subtitles','shifted.srt')
    )
  end
  
  it "should forward the time line" do
    shifter = ShiftSubtitle::Shifter.new(
        :oadd => true,
        :osub => false,
        :offset => '02,300',
        :input_file_path => File.join('subtitles','sub.srt'),
        :output_file_path => File.join('subtitles','shifted.srt')
      )
    shifter.forward("01:59:59,210 --> 01:31:54,893\n").should == "02:00:01,510 --> 01:31:57,193"
  end
  
  it "should calculate milliseconds" do
    ShiftSubtitle::Shifter.millis_from('01', '01', '01', '100').should == 3661100
  end
  
  it "should ensure files are closed" do
    input_file = File.open(File.join('subtitles', 'sub.srt'))
    output_file = File.new(File.join('subtitles', 'shifted.srt'), "w")
    shifter = ShiftSubtitle::Shifter.new(:input_file => input_file, :output_file => output_file)
    shifter.ensure_files_are_closed
    shifter.input_file.closed?.should be_true
    shifter.output_file.closed?.should be_true    
  end
  
  
end

