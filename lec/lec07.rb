# In Ruby:
# 1. All values are references to objects
#    - variable assignment (x=y) creates an alias (aliasing means: same object, same state)
#    - the only operation we have on objects is: calling methods on them
# 2. Objects communicate via method calls, also known as messages
# 3. Each object has its own (private) state
# 4. Every object is an instance of a class
# 5. An object's class determines the object's behavior
#    – How it handles method calls
#    – Class contains method definitions

# Ruby is a dynamic language - anything can change while the program is running.
# - e.g. we can add instance variable to an object just by assigning to it in some methods of its class
# Ruby programs can add/change/replace methods while a program is running.

# Object State
# - State is only directly accessible from object's methods
# - State consists of instance variables (also known as fields)
# - In Ruby, fields (i.e., instance variables) are not part of a class definition
#   because each object instance just creates its own instance variables.

# Class Variable vs. Class Constant vs. Class Method
#
# class ClassName
#
#   ClassConst
# 
#   def self.class_method_name(args)
#     @class_var
#     exprs
#   end
# 
#   def instance_method_name(args)
#     @instance_var
#     @@class_var
#     exprs
#   end
#
# end

# Class Variable
# - Class variable is a state shared by the entire class
#   shared by (and only accessible to) all instances of the class
# - Instance variables are separate for each object, while class variables are not

# Class Constants
# - Starts with capital letter
# - Should not be mutated
# - Visiable outside class C (as C::ClassConst)
# - Class constants are different from class variables who can only be accessed through getters

# Class Methods (Static Methods)
# - Define a class method: def self.method_name(args) ... end
# -    Use a class method: ClassName.method_name(args)
# - Class methods cannot access instance variables

# ========== Ruby Syntax ========== 

# ClassName.new  : create a new object whose class is ClassName
#                  when a new object is created (with new), it has NO initial state
#                  initialize(...) is called when an object is created (as part of new; before new returns)
#                                  arguments to new are passed along to initialize
# e.m(e1,...,en) : evaluate e to an object, and then calls its m method (also known as sending the m message)
#      self      : the object we call the method on
#                  self.m(...) <=> m(...)
#                  we can pass/return/store "the whole object" with self
# @instance_var  : create/access an instance variable (for the current object)
# @@class_var    : create/access a class variable

# ========== OOP: Visibility ========== 

# In Ruby, object state (field) is always private.
# - Only an object's methods can access its instance variables
# - So, we can write @instance_var within class definitions, but not e.@instance_var outside class def

# getter only  : attr_reader :foo :bar
# getter/setter: attr_accessor :foo :bar

# private   : only available to the object itself
# protected : only available to code in the class/subclass
# public    : available to all code (by default, methods are public)

# for private methods, only m(...) is allowed; we cannot write self.m(...)

# ========== OOP: Subclassing ========== 

# class ChildClass < ParentClass ...
# - child class inherits all method definitions from parent class
# - child class can override method definitions as desired

# ========== Reflection ========== 

# All objects have methods:
# - methods
# - class
# We can use them at run-time to query "what an object can do" and respond accordingly (called reflection)

# ========== Data Structures ========== 

# Array
#   a = [3,2,7,9]
#   Array.new(n) { 0 }
#   slicing   : a[i_start,n_elements]
#   as a stack: a.push/pop
#   as a queue: a.push/shift
puts [1,2,3].to_s()

# Range
# - range likes an array of contiguous numbers, but more efficiently represented (so large ranges are fine)
puts (1..1000000)

# Hash
h = {"SML"=>1, "Racket"=>2, "Ruby"=>3}
h.each { |k,v| puts "key: " + k.to_s() + ", val: " + v.to_s() }

# ========== Blocks ========== 

# Blocks (almost just closures)
# - an easy way to pass anonymous functions to methods
# - blocks can take 0 or more arguments
# - blocks use lexical scope (block body uses env where block was defined)
# - can pass 0/1 block to any message/method
# - in Ruby, block is not a first-class expression

i = 7
[4,6,8].each { |x| if i > x then puts (x+1) end }

# First Class Expression
# we say something is a first-class expression when 
# - it can be the result of a computation
# - it can be returned by a function or a method
# - it can be stored in an object
# - it can be passed around just like numbers and objects and anything else we have in a language

# "lambda" turns a block into a proc (which is a first-class expression)
puts (lambda { |x| x + 1 }).call(2)

# ========== MyRational Class ========== 

class MyRational

  def initialize(num,den=1) # second argument has a default
    if den == 0
      raise "MyRational received an inappropriate argument"
    elsif den < 0 # notice non-english word elsif
      @num = - num # fields created when you assign to them
      @den = - den
    else
      @num = num # semicolons optional to separate expressions on different lines
      @den = den
    end
    reduce # i.e., self.reduce() but private so must write reduce or reduce()
  end

  def to_s 
    ans = @num.to_s
    if @den != 1 # everything true except false _and_ nil objects
      ans += "/"
      ans += @den.to_s 
    end
    ans  # method returns its last expression (Ruby also has an explicit return statement)
  end

  def to_s2 # using some unimportant syntax and a slightly different algorithm
    dens = ""
    dens = "/" + @den.to_s if @den != 1
    @num.to_s + dens
  end

  def to_s3 # using things like Racket's quasiquote and unquote
    "#{@num}#{if @den==1 then "" else "/" + @den.to_s end}"
  end

  def add! r # mutate self in-place
    # we CANNOT do r.@num (because @num is private)
    a = r.num # only works b/c of protected methods below
    b = r.den # only works b/c of protected methods below
    c = @num
    d = @den
    @num = (a * d) + (b * c)
    @den = b * d
    reduce
    self # convenient for stringing calls (obj.m1.m2.m3)
  end

  # a functional addition, so we can write r1.+ r2 to make a new rational
  # and built-in syntactic sugar will work: can write r1 + r2
  def + r
    ans = MyRational.new(@num,@den)  # make a copy
    ans.add! r
    ans
  end
    
protected  
  # there is very common sugar for this (attr_reader)
  # the better way:
  # attr_reader :num, :den
  # protected :num, :den
  # we do not want these methods public, but we cannot make them private
  # because of the add! method above
  def num
    @num
  end
  def den
    @den
  end

private
  def gcd(x,y) # recursive method calls work as expected
    if x == y
      x
    elsif x < y
      gcd(x,y-x)
    else
      gcd(y,x)
    end
  end

  def reduce
    if @num == 0
      @den = 1
    else
      d = gcd(@num.abs, @den) # notice method call on number
      @num = @num / d
      @den = @den / d
    end
  end
end

# can have a top-level method (just part of Object class) for testing, etc.
def use_rationals
  r1 = MyRational.new(3,4)  
  r2 = r1 + r1 + MyRational.new(-5,2)
  puts r2.to_s
  (r2.add! r1).add! (MyRational.new(1,-4))
  puts r2.to_s
  puts r2.to_s2
  puts r2.to_s3
end

# ========== Dynamic Dispatch ========== 

class Point  # < Object (by default)

  attr_accessor :x, :y

  def initialize(x,y)
    @x = x
    @y = y 
  end

  def distFromOrigin
    Math.sqrt(@x * @x + @y * @y)  # use instance variable
  end

  def distFromOrigin2
    Math.sqrt(x * x + y * y)  # use getter methods
  end

end

class ColorPoint < Point

  attr_accessor :color 

  def initialize(x,y,c="clear")
    super(x,y)  # super(...) calls the same method in superclass
    @color = c 
  end

end

cp = ColorPoint.new(1,2)
puts "Is ColorPoint a Point: #{cp.is_a?(Point)}"
puts "Is ColorPoint an instance of Point: #{cp.instance_of?(Point)}"
puts "Superclass of a ColorPoint: #{cp.class.superclass}"

class ThreeDPoint < Point 

  attr_accessor :z

  def initialize(x,y,z)
    super(x,y)
    @z = z 
  end

  def distFromOrigin  # method overriding
    d = super 
    Math.sqrt(d * d + @z * @z)
  end

  def distFromOrigin2
    d = super 
    Math.sqrt(d * d + z * z)
  end

end

# THE essential difference of OOP - Dynamic Dispatch:
# - overriding can make a method defined in the superclass call a method in the subclass
# - call self.m2() in method m1 (defined in class C) can resolve to a method m2 defined in a subclass of C

class PolarPoint < Point
  # Interesting: by not calling super constructor, no x and y instance vars
  # In Java/C#/Smalltalk would just have unused x and y fields
  def initialize(r,theta)
    @r = r
    @theta = theta
  end
  def x
    @r * Math.cos(@theta)
  end
  def y
    @r * Math.sin(@theta)
  end
  def x= a
    b = y # avoids multiple calls to y method
    @theta = Math.atan2(b, a)
    @r = Math.sqrt(a*a + b*b)
    self
  end
  def y= b
    a = x # avoid multiple calls to y method
    @theta = Math.atan2(b, a)
    @r = Math.sqrt(a*a + b*b)
    self
  end
  def distFromOrigin # must override since inherited method does wrong thing
    @r
  end
  # inherited distFromOrigin2 already works!!
  # - distFromOrigin2 is defined in the Point (super) class
  # - it calls a methods (x,y) defined in the PolarPoint (sub) class
end

pp = PolarPoint.new(4,Math::PI/4)
puts "Polar Point x: #{pp.x()}"
puts "Polar Point x: #{pp.y()}"
puts "Polar Point distFromOrigin2: #{pp.distFromOrigin2()}"
