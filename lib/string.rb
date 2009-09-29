#!/usr/bin/env ruby

class String
                attr_accessor :hours, :mins, :secs, :millis, :end_hours, :end_mins, :end_secs, :end_millis
  def subtitle_time_format?
    value = !!(self =~ /(\d{2}):(\d{2}):(\d{2}),(\d{3})\s*-->\s*(\d{2}):(\d{2}):(\d{2}),(\d{3})/)
    @hours, @mins, @secs, @millis = $1, $2, $3, $4
    @end_hours, @end_mins, @end_secs, @end_millis = $5, $6, $7, $8
    value
  end
  
  def subtitle_offset_format?
    value = !!(self =~ /(\d{2}),(\d{3})/)
    @hours, @mins, @secs, @millis = "0", "0", $1, $2
    value
  end
end
