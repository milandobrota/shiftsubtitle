#!/usr/bin/env ruby

#Usage: 'ShiftSubtitle::Shifter.new.shift

require File.join(File.dirname(__FILE__), "option_parser")

module ShiftSubtitle
  
  class Shifter    
    attr_accessor :input_file_path, :output_file_path, :offset, :oadd, :osub, :input_file, :output_file
  
    def initialize(hash)
      hash.each do |key, value|
        self.send("#{key}=", value)
      end
    end
    
    def initialize(options = ShiftSubtitle::OptionParser.parse)
      options.each do |key, value|
        self.send("#{key}=", value)
      end
      begin
        @input_file ||= File.open(@input_file_path) unless @input_file_path.nil?
      rescue
        puts "input file is not properly set"
        close_files_and_exit
      end
      @output_file ||= File.new(@output_file_path, "w") unless @output_file_path.nil?
      #@offset = options[:offset]
      #@oadd = options[:oadd]
      #@osub = options[:osub]
    end
    
    def shift
      ensure_instance_variables_are_proper
      counter = "1"
      while !@input_file.eof? do
        line = @input_file.readline
        if line.strip == counter
          @output_file.puts(line)
          line = @input_file.readline
          @output_file.puts(self.forward(line))
          counter = counter.next
        else
          @output_file.puts(line)
        end
      end
      @input_file.close
      @output_file.close
      rescue Errno::ENOENT
      puts "The file name is not valid"
    end
    
    def forward(base_time_line)
      if @offset.subtitle_offset_format?
        offset_ms = Shifter.millis_from(0, 0, @offset.secs, @offset.millis)
      end      
      if base_time_line.subtitle_time_format?
        base_ms_start = Shifter.millis_from(
          base_time_line.hours,
          base_time_line.mins,
          base_time_line.secs,
          base_time_line.millis
        )
        base_ms_end = Shifter.millis_from(
          base_time_line.end_hours,
          base_time_line.end_mins,
          base_time_line.end_secs,
          base_time_line.end_millis
        )
        if @oadd
          ms_start = base_ms_start + offset_ms
          ms_end = base_ms_end + offset_ms
        elsif @osub
          ms_start = base_ms_start - offset_ms
          ms_end = base_ms_end - offset_ms
        end
        begin
          Shifter.time_line_from(ms_start, ms_end)     
        rescue
          puts "Operation error"
        end
      end

    end
    
    def self.time_line_from(ms_start, ms_end)
      start_time = Time.at(ms_start/1000.0 - 3600)
      end_time = Time.at(ms_end/1000.0 - 3600)
      start_hours = start_time.hour
      start_mins = start_time.min
      start_secs = start_time.sec
      start_millis = start_time.usec/1000
      end_hours = end_time.hour
      end_mins = end_time.min
      end_secs = end_time.sec
      end_millis = end_time.usec/1000
      "%02d:%02d:%02d,%03d --> %02d:%02d:%02d,%03d" % [start_hours, start_mins, start_secs, start_millis, end_hours, end_mins, end_secs, end_millis]
    end
    
    def self.millis_from(hours, mins, secs, millis)
      millis.to_i + secs.to_i * 1000 + mins.to_i * 60 * 1000 + hours.to_i * 60 * 60 * 1000
    end
  
    def ensure_instance_variables_are_proper
      if @input_file_path.nil? || @input_file_path.strip.empty?
        puts "input file path is empty"
        close_files_and_exit
      elsif @output_file_path.nil? || @output_file_path.strip.empty?
        puts "output file path is empty"
        close_files_and_exit
      elsif @oadd.nil? || @osub.nil? || !(@oadd || @osub)
        puts "operation accepts add or sub"
        close_files_and_exit
      elsif !@offset.subtitle_offset_format?
        puts "offset accepts SS,MMM format"
      end
      
      if @input_file.nil? || @input_file.closed?
        begin
          @input_file = File.open(@input_file_path)
        rescue
          puts "input file is not properly set"
          close_files_and_exit
        end
      end
      if @output_file.nil? || @output_file.closed?
        begin
          @output_file = File.new(@output_file_path, "w")
        rescue
          puts "output file is not properly set"
          close_files_and_exit
        end
      end     
    end
    
    def ensure_files_are_closed
      [@input_file, @output_file].each do |file|
        if !file.nil? && !file.closed?
          file.close
        end
      end      
    end
    
    def close_files_and_exit
      ensure_files_are_closed
      Process.exit
    end
    
  end

end

