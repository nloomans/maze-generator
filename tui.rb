module TUI
  class Screen
    def self.save()
      print "\e[?1049h"
    end

    def self.reset()
      print "\e[2J"
      print "\e[0;0H"
    end

    def self.restore()
      print "\e[?1049l"
    end
  end

  class Cursor
    def self.save()
      print "\e[s"
    end

    def self.restore()
      print "\e[u"
    end
  end

  class Color
    def self.red
      "\e[0;31;1m"
    end

    def self.purple
      "\e[1;35m"
    end

    def self.reset
      "\e[0m"
    end
  end
end
