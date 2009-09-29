#!/usr/bin/env ruby

class Array
  def merge(array2)
    array2.each do |element|
      self << element
    end
  end
end
