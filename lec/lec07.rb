# ========== syntax ==========

# class Name
# 
#   ClassConst
#   def self.class_method_name method_args
#     expression0
#   end
# 
#   def method_name1 method_args1
#     expression1
#   end
#   def method_name2 method_args2
#     expression2
#   end
#
# end

class Hello
  def my_first_method
    puts "hello world"
  end
end

# Hello.new: creates a new object whose class is Hello
x = Hello.new
# e.m: evaluate e to an object, and then calls its m method
#      also known as sending the m message
x.my_first_method

class A 
  def m1 
    34
  end
  def m2(x,y)
    z = 7  # local variable, whose scope is the method body
    if x > y 
      false
    else
      x + y * z 
    end
  end
end

class B 
  def m1 
    4
  end
  def m3(x)
    # self: the current object we call the method on
    x.abs * 2 + self.m1
  end
end

b = B.new
puts b.m3(-3)

class C 
  def m1 
    print "hi"
    self
  end
  def m2 
    print "bye"
    self
  end
  def m3
    print "\n"
    self
  end
end

c = C.new 
c.m1.m2.m3.m1.m3

class D 

  # class constant (should not be mutated)
  # class constants are visible outside of the class: MyClass::ClassConst
  # this is different from class variables who can only be accessed through getters
  DansAge = 39

  # initialize will be called before the object returns from ClassName.new
  def initialize(f=0)
    # it's a good style to create instance variables in initialize(...)
    @foo = f
  end

  def self.reset_bar()  # class method
    @@bar = 0           # class variable (shared by all instances)
  end

  def m1 
    @foo = 0  # instance variable (field)
  end
  def m2(x)
    @@bar += 1
    @foo += x 
  end
  def foo 
    @foo 
  end
  def bar 
    @@bar 
  end
end

d1 = D.new(19)   # ctor
d2 = D.new(18)

D.reset_bar      # call class method
puts d1.m2(3)    # call (instance) method
puts d1.m1
puts d1.m2(3)
puts d1.foo
puts D::DansAge  # access class constant
puts d1.bar      # access class variable
puts d2.m2(5)
puts d1.bar
D.reset_bar
puts d1.bar 
puts d2.bar
