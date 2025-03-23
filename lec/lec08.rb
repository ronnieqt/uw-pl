# ============================================================
# Double-Dispatch

class Expr
  # could put default implementations or helper methods here
end

class Value < Expr
  def eval()
    self
  end
end

# ============================================================

class Int < Value
  attr_reader :i

  def initialize(i)
    @i = i 
  end

  def to_string()
    @i.to_s
  end

  def has_zero()
    @i == 0
  end

  # --- double-dispatch for adding values ---

  # dispatch 1: actual type of lhs determines which add() to call
  def add(v)  # self + v
    # dispatch 2: actual type of v determines which add_int() to call
    #     if actual_type(v) == Int, then Int.add_int() will be called
    #     if actual_type(v) == MyString, then MyString.add_int() will be called
    v.add_int(self)
  end

  def add_int(v)
    Int.new(v.i + @i)
  end

  def add_string(v)
    # v is self (lhs) when called
    MyString.new(v.s + i.to_s())
  end

  # -----------------------------------------

end

# ------------------------------------------------------------

class MyString < Value 
  attr_reader :s

  def initialize(s)
    @s = s 
  end

  def to_string()
    @s 
  end

  def has_zero()
    false 
  end

  # --- double-dispatch for adding values ---

  def add(v)
    v.add_string self
  end

  def add_int(v)
    Int.new(v.i.to_s() + @s)
  end

  def add_string(v)
    MyString.new(v.s + @s)
  end

  # -----------------------------------------

end

# ============================================================

class Negate < Expr
  attr_reader :e

  def initialize(e)
    @e = e 
  end

  def eval 
    Int.new(-1 * e.eval().i)
  end

  def to_string()
    "-(" + @e.to_string() + ")"
  end

  def has_zero()
    @e.has_zero()
  end

end

# ------------------------------------------------------------

class Add < Expr
  attr_reader :e1, :e2

  def initialize(e1,e2)
    @e1 = e1
    @e2 = e2
  end

  def eval
    # double-dispatch
    # dispatch 1: e1.eval()<-self determines which add() to call
    # dispatch 2: e2.eval()<-self determines which add_xxx() to call
    @e1.eval().add(@e2.eval())
    # example: e1.eval() is an Int, e2.eval() is an MyString
    # lhs.add() -> rhs.add_int()
  end

  def to_string()
    "(" + @e1.to_string() + " + " + e2.to_string() + ")"
  end

  def has_zero()
    @e1.has_zero() || @e2.has_zero()
  end

end

# ============================================================

e = Add.new(Add.new(Int.new(3),Negate.new(Int.new(2))),Int.new(0))
puts e.to_string()
puts e.eval().to_string()
puts e.has_zero()

# ============================================================
# Mixins: a collection of methods (Mixins can not be instantiated)
# The goal is to: add method definitions to some class when you include the Mixin
# We use mixins to define certain methods in terms of other methods already defined in the class. 

# an Mixin
module Doubler
  def double 
    # uses self's + message, not defined in Doubler
    self + self
  end
end

class Pt 
  attr_accessor :x, :y
  include Doubler  # include an Mixin
  def initialize(x,y)
    @x = x 
    @y = y
  end
  def + other 
    ans = Pt.new(0,0)
    ans.x = self.x + other.x 
    ans.y = self.y + other.y
    ans
  end
  def to_s 
    "Point(x="+self.x.to_s()+", y="+self.y.to_s()+")"
  end
end

p = Pt.new(2,3)
puts p.double

# ------------------------------------------------------------
# these are probably the two most common uses in the Ruby library:
#  Comparable and Enumerable

# you define <=> and you get ==, >, <, >=, <= from the mixin
# (overrides Object's ==, adds the others)
class Name
  attr_accessor :first, :middle, :last
  include Comparable
  def initialize(first,last,middle="")
    @first = first
    @last = last
    @middle = middle
  end
  def <=> other  # x1 <=> x2: signum[x1-x2]
    l = @last <=> other.last # <=> defined on strings
    return l if l != 0
    f = @first <=> other.first
    return f if f != 0
    @middle <=> other.middle
  end
end

n1 = Name.new("Tom","Cruise")
n2 = Name.new("Michael","Jackson")
puts n1>n2

# Note ranges are built in and very common
# you define each and you get map, any?, etc.
# (note map returns an array though)
class MyRange
  include Enumerable
  def initialize(low,high)
    @low = low
    @high = high
  end
  def each
    i=@low
    while i <= @high
      yield i
      i=i+1
    end
  end
end

r = MyRange.new(3,5)
r.map { |i| puts i+1 }

# here is how module Enumerable could implement map:
# (but notice Enumerable's map returns an array,
#  *not* another instance of the class :( )
# def map
#   arr = []
#   each { |x| arr.push x }
#   arr
# end

# ------------------------------------------------------------
# Interfaces

# Interface: an abstract class that only contains method declarations (signatures); no method bodies no fields
# If a class implements an interface, it gives you the obligations to implement those functions declared in the interface.
# Interfaces are introduced in PLs to produce a more flexible type system.

#                     Class  Interface  Mixin
# intro a new type    yes    yes        no
# instantiate an obj  yes    no         no
# fields              yes    no         not encouraged
# method body         yes    no         yes

# ============================================================
