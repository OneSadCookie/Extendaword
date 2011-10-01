#!/usr/bin/ruby

$band = 0
$allwords = {}
$words = []

def put_word(w)
  if w =~ /^[a-z]+$/ then
    unless $allwords[w]
      $words[$band] ||= []
      $words[$band] << w
      $allwords[w] = true
    end
  else
    #$stderr.puts "weird word: #{w}"
  end
end

File.open('2+2gfreq.txt') do |f|
  loop do
    line = f.gets
    break unless line
    line.chomp!
    if line =~ /^----- (\d+) -----$/ then
      $band = $1.to_i
    elsif line =~ /^([a-zA-Z]+)(\+?)/ then
      put_word($1)
    elsif line =~ /^    (.*)$/ then
      line = $1
      while line =~ /^([a-zA-Z]+)(\+?)(.*)/ do
        put_word($1)
        line = $3
        if line =~ /^ -> \[.*?\](.*)/ then
          line = $1
        end
        if line =~ /^, (.*)/ then
          line = $1
        end
      end
      if line != '' then
        raise "malformed remainder: '#{line}'"
      end
    else
      raise "malformed line: '#{line}'"
    end
  end
end
$words.each_with_index do |words, band|
  next unless words
  words.sort.each do |word|
    puts "#{band},#{word}"
  end
end
