#!/usr/bin/ruby
#start 1310
#pt 1 1430
#pt 2 ?? but done
#refactor 18:20 -- 18:32

$DEBUG = false
monkeysPt1 = {}
monkeysPt2 = {}

class Monkey
  attr_accessor :inspections
  attr_accessor :divisor
  def initialize(idx,items,op,opVal,divisor,onTrue,onFalse,monkeys)
    @idx = idx
    @items = items
    @op = op
    @opVal = opVal
    @divisor = divisor
    @onTrue = onTrue
    @onFalse = onFalse
    @inspections = 0
    @monkeys = monkeys
  end
  def getItems()
    return @items
  end
  def tick(part='1')
    puts "Monkey #{@idx}" if @DEBUG
    while @items.size >0 do
      @inspections += 1
      i = @items.shift
      if @op == "*"
        if @opVal == "old"
          newVal = i.to_i * i.to_i
        else
          newVal = i.to_i * @opVal.to_i
        end
      elsif @op == "+"
        if @opVal == "old"
          newVal = i.to_i + i.to_i
        else
          newVal = i.to_i + @opVal.to_i
        end
      else
        raise "Bad OP: <#{@op}>"
      end

      if part == "1"
        boredVal = newVal / 3
      else
        boredVal = newVal % $modulus
      end
      isDiv = (boredVal % @divisor.to_i) == 0
      if isDiv
        throwTo = @onTrue
      else
        throwTo = @onFalse
      end

      @monkeys[throwTo].beThrown(boredVal)
      notS =  isDiv ? "" : "not "
      puts "        Monkey inspects an item with a worry level of #{i}.
          Worry level is #{@op} by #{@opVal} to #{newVal}.
          Monkey gets bored with item. Worry level is divided by 3 to #{boredVal}.
          Current worry level is #{notS}divisible by #{@divisor}.
          Item with worry level #{boredVal} is thrown to monkey #{throwTo}." if @DEBUG
    end
  end
  def beThrown(newVal)
    @items.append(newVal)
  end

end

def printMonkeyStatuses(monkeys)
  monkeys.each do |k,m|
    puts "Monkeys #{k}: #{m.getItems().join(",")}"
  end
end
def processMonkey(midx, startings, op, opVal, divisor, onTrue, onFalse,monkeys)
  # puts "m: <#{midx}> <#{startings}> <#{op}><#{opVal}> <#{divisor}> <#{onTrue}> <#{onFalse}>"
  m = Monkey.new(midx, startings, op, opVal, divisor, onTrue, onFalse,monkeys)
  monkeys[midx] = m
end

DATA.each_line do |line|
    matches = line.match(/Monkey (\d+):/)
    unless matches.nil?
      $midx = matches[1].to_i
    end
    matches = line.match(/Starting items: (.+)/)
    unless matches.nil?
      $startings = matches[1].split(",")
      $startings.map! do |x| x.lstrip.rstrip.to_i; end
    end
    matches = line.match(/Operation: new = old (.) (.+)/)
    unless matches.nil?
      $op = matches[1]
      $opVal = matches[2]
    end
    matches = line.match(/Test: divisible by (.+)/)
    unless matches.nil?
      $divisor = matches[1].to_i
    end
    matches = line.match(/If true: throw to monkey (.+)/)
    unless matches.nil?
      $onTrue = matches[1].to_i
    end
    matches = line.match(/If false: throw to monkey (.+)/)
    unless matches.nil?
      $onFalse = matches[1].to_i
    end
    if line.match?(/^$/)
      processMonkey($midx, $startings, $op, $opVal, $divisor, $onTrue, $onFalse, monkeysPt1)
      processMonkey($midx, $startings, $op, $opVal, $divisor, $onTrue, $onFalse,monkeysPt2)
    end
end
processMonkey($midx, $startings, $op, $opVal, $divisor, $onTrue, $onFalse,monkeysPt1)
processMonkey($midx, $startings, $op, $opVal, $divisor, $onTrue, $onFalse,monkeysPt2)


def printInspectionStatuses(monkeys, part="1")
  inspectionCounts=[]
  monkeys.each do |i, m|
    inspectionCounts.append(m.inspections)
    puts "Monkey #{i} inspected #{m.inspections} times."
  end
  inspectionCounts.sort!
  mb = inspectionCounts[-1]*inspectionCounts[-2]
  puts "PART #{part}: Monkey Business: #{mb}"
end

printMonkeyStatuses(monkeysPt1)
for r in 1..20 do
  monkeysPt1.each do |i, m|
    m.tick()
  end
  if r == 1 || r == 20 || (r.modulo(500) == 0)
    if $DEBUG
      puts "After round #{r}, the monkeys are holding items with these worry levels:  "
      printMonkeyStatuses(monkeysPt1)
    end
    puts "== After round #{r} =="
    printInspectionStatuses(monkeysPt1,1)
  end
end
printInspectionStatuses(monkeysPt1,1)

divisors = monkeysPt2.map{|i,m| m.divisor}
$modulus = divisors.reduce(1,:lcm)
puts "Divisors: <#{divisors}>, modulus: <#{$modulus}>"

printMonkeyStatuses(monkeysPt2)
for r in 1..10000 do
  monkeysPt2.each do |i, m|
    m.tick()
  end
  if r == 1 || r == 20 || (r.modulo(500) == 0)
    if $DEBUG
      puts "After round #{r}, the monkeys are holding items with these worry levels:  "
      printMonkeyStatuses(monkeysPt2)
    end
    puts "== After round #{r} =="
    printInspectionStatuses(monkeysPt2,2)
  end
end

printInspectionStatuses(monkeysPt1,1)
printInspectionStatuses(monkeysPt2,2)

__END__
Monkey 0:
  Starting items: 85, 79, 63, 72
  Operation: new = old * 17
  Test: divisible by 2
    If true: throw to monkey 2
    If false: throw to monkey 6

Monkey 1:
  Starting items: 53, 94, 65, 81, 93, 73, 57, 92
  Operation: new = old * old
  Test: divisible by 7
    If true: throw to monkey 0
    If false: throw to monkey 2

Monkey 2:
  Starting items: 62, 63
  Operation: new = old + 7
  Test: divisible by 13
    If true: throw to monkey 7
    If false: throw to monkey 6

Monkey 3:
  Starting items: 57, 92, 56
  Operation: new = old + 4
  Test: divisible by 5
    If true: throw to monkey 4
    If false: throw to monkey 5

Monkey 4:
  Starting items: 67
  Operation: new = old + 5
  Test: divisible by 3
    If true: throw to monkey 1
    If false: throw to monkey 5

Monkey 5:
  Starting items: 85, 56, 66, 72, 57, 99
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 1
    If false: throw to monkey 0

Monkey 6:
  Starting items: 86, 65, 98, 97, 69
  Operation: new = old * 13
  Test: divisible by 11
    If true: throw to monkey 3
    If false: throw to monkey 7

Monkey 7:
  Starting items: 87, 68, 92, 66, 91, 50, 68
  Operation: new = old + 2
  Test: divisible by 17
    If true: throw to monkey 4
    If false: throw to monkey 3
