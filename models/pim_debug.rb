=begin
  debug level meanings:
    0 => off
    1 => errors
    2 => errors and debug statements
    3 => errors and verbose debug statements
=end
$debug_level = 0

=begin
  Prints a debug message
  NOTE: all messages print in red on the command line in order to stand out
  
  printd(lvl, s)
    lvl:Integer => minimum value of debug_level at which this message will print
                        (required, non-nil, non-negative)
    s:String => the message to print (required) (nil or empty string would be
                                                      pointless)
=end
def printd(lvl, s)
  if $debug_level < lvl
    return
  end
  puts(red(s))
end

=begin
  colorize is a utility method for printd that makes text a certain color
=end
def colorize(text, color_code)
  "\e[#{color_code}m#{text}\e[0m"
end

=begin
  red is a utility method for printd that makes text red
=end
def red(text)
  colorize(text, 31)
end