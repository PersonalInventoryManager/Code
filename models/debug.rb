=begin
  debug level meanings:
    0 => off
    1 => errors
    2 => errors and debug statements
=end
debug_level = 0

=begin
  usage of printd:
    printd(lvl, s)
      lvl => minimum value of debug_level at which this message will print
      s => the message to print
    
    NOTE: all messages print in red on the command line in order to stand out
=end
def printd(lvl, s)
  if debug_level < lvl
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