#!/usr/bin/env ruby

require 'rubygems'
require 'spec'
require File.join(File.dirname(__FILE__), '..', 'lib', 'string')

describe String do
  it "should recognize subtitle time format" do
    "01:59:59,210 --> 01:31:54,893\n".subtitle_time_format?.should be_true
  end
  
  it "should set time instance variables" do
    line = "01:59:59,210 --> 01:31:54,893\n"
    line.subtitle_time_format?
    line.hours.should == '01'
    line.mins.should == '59'
    line.secs.should == '59'
    line.millis.should == '210'
    line.end_hours.should == '01'
    line.end_mins.should == '31'
    line.end_secs.should == '54'
    line.end_millis.should == '893'
  end
  
  it "should recognize bad subtitle file format" do
    "1:59:59,210 --> 01:31:54,893\n".subtitle_time_format?.should be_false
  end
  
  it "should recognize offset time format" do
    "03,500".subtitle_offset_format?.should be_true
  end
  
  it "should set offset instance variables" do
    line = "03,500"
    line.subtitle_offset_format?
    line.hours.should == '0'
    line.mins.should == '0'
    line.secs.should == '03'
    line.millis.should == '500'
  end
  
  it "should recognize bad subtitle offset format" do
    "02,3".subtitle_offset_format?.should be_false
  end
end
