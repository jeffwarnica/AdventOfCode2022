#!/usr/bin/ruby
#start 12:45
#pt 1 13:02
#pt 2 13:43

#BUT VHOLD and pt1 is now wrong
# should be 14320
#pt should be PCPBKAPJ

class Clock
  def initialize(computer)
    $computer = computer
    $computer.setClock(self)
    $cycle = 0
  end
  def cycle()
    $cycle+=1
    $computer.display.cycle()
    if $cycle == 20
      $computer.cpu.addSignalStrength()
    elsif ($cycle-20).modulo(40) == 0
      $computer.cpu.addSignalStrength()
    end
  end
  def getCycle()
    return $cycle
  end
end

class CPU
  attr_accessor :regX
  def initialize(computer)
    $computer = computer
    $computer.setCPU(self)
    # $clock = computer.clock
    @regX = 1
    $importants = []
  end
  def noop()
    $computer.clock.cycle()
  end
  def addX(val)
    $computer.clock.cycle()
    @regX += val.to_i
    $computer.clock.cycle()
  end
  def addSignalStrength()
    $importants.push(@regX*$computer.clock.getCycle())
  end
  def getImportants()
    return $importants
  end
end

class Computer
  attr_accessor :clock
  attr_accessor :cpu
  attr_accessor :display
  def setClock(clock)
    @clock = clock
  end
  def setCPU(cpu)
    @cpu = cpu
  end
  def setDisplay(display)
    @display = display
  end
end

class Display
  def initialize(computer)
    $computer = computer
    $computer.setDisplay(self)
  end
  def cycle()
    cycle = $computer.clock.getCycle()
    linePos = cycle.modulo(40)
    if (cycle-1).modulo(40) == 0 #start of line
      print "Cycle " + ("%03d" % cycle) + " -> "
    end
    x = $computer.cpu.regX
    # puts "|#{x}/#{linePos}"
    if (x-1==linePos || x==linePos || x+1==linePos)
      print "██"
    else
      print "░░"
    end
    # print $computer.cpu.regX.to_s + "|"
    if (cycle).modulo(40) == 0 #end of line
      print " <- Cycle " + ("%03d" % cycle) + "\n"
    end
  end
end


computer = Computer.new()
cpu = CPU.new(computer)
display = Display.new(computer)
clock = Clock.new(computer)

DATA.each_line do |line|
 (op, val) = line.split(' ')
 if op == "noop"
  cpu.noop()
 elsif op =="addx"
  cpu.addX(val.to_i)
 else
  raise "BAD OP <#{op}>"
 end
end
importants = cpu.getImportants

puts "PART 1: TOTAL SS: <#{importants.sum}>"

__END__
noop
noop
noop
addx 6
noop
addx 30
addx -26
noop
addx 5
noop
noop
noop
noop
addx 5
addx -5
addx 6
addx 5
addx -1
addx 5
noop
noop
addx -14
addx -18
addx 39
addx -39
addx 25
addx -22
addx 2
addx 5
addx 2
addx 3
addx -2
addx 2
noop
addx 3
addx 2
addx 2
noop
addx 3
noop
addx 3
addx 2
addx 5
addx 4
addx -18
addx 17
addx -38
addx 5
addx 2
addx -5
addx 27
addx -19
noop
addx 3
addx 4
noop
noop
addx 5
addx -1
noop
noop
addx 4
addx 5
addx 2
addx -4
addx 5
noop
addx -11
addx 16
addx -36
noop
addx 5
noop
addx 28
addx -23
noop
noop
noop
addx 21
addx -18
noop
addx 3
addx 2
addx 2
addx 5
addx 1
noop
noop
addx 4
noop
noop
noop
noop
noop
addx 8
addx -40
noop
addx 7
noop
addx -2
addx 5
addx 2
addx 25
addx -31
addx 9
addx 5
addx 2
addx 2
addx 3
addx -2
noop
addx 3
addx 2
noop
addx 7
addx -2
addx 5
addx -40
addx 20
addx -12
noop
noop
noop
addx -5
addx 7
addx 7
noop
addx -1
addx 1
addx 5
addx 3
addx -2
addx 2
noop
addx 3
addx 2
noop
noop
noop
noop
addx 7
noop
noop
noop
noop
