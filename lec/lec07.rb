# ========== Ruby Intro ========== 

# In Ruby:
# 1. All values are references to objects
#    - variable assignment (x=y) creates an alias (aliasing means: same object, same state)
# 2. Objects communicate via method calls, also known as messages
# 3. Each object has its own (private) state
# 4. Every object is an instance of a class
# 5. An object's class determines the object's behavior
#    – How it handles method calls
#    – Class contains method definitions

# Object State
# - State is only directly accessible from object's methods
# - State consists of instance variables (also known as fields)

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
    a = r.num # only works b/c of protected methods below
    b = r.den # only works b/c of protected methods below
    c = @num
    d = @den
    @num = (a * d) + (b * c)
    @den = b * d
    reduce
    self # convenient for stringing calls
  end

  # a functional addition, so we can write r1.+ r2 to make a new rational
  # and built-in syntactic sugar will work: can write r1 + r2
  def + r
    ans = MyRational.new(@num,@den)
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
