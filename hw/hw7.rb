# University of Washington, Programming Languages, Homework 7, hw7.rb 
# (See also ML code)

# a little language for 2D geometry objects

# each subclass of GeometryExpression, including subclasses of GeometryValue,
#  needs to respond to messages preprocess_prog and eval_prog
#
# each subclass of GeometryValue additionally needs:
#   * shift
#   * intersect, which uses the double-dispatch pattern
#   * intersectPoint, intersectLine, and intersectVerticalLine for 
#       for being called by intersect of appropriate clases and doing
#       the correct intersection calculuation
#   * (We would need intersectNoPoints and intersectLineSegment, but these
#      are provided by GeometryValue and should not be overridden.)
#   *  intersectWithSegmentAsLineResult, which is used by 
#      intersectLineSegment as described in the assignment
#
# you can define other helper methods, but will not find much need to

# Note: geometry objects should be immutable: assign to fields only during
#       object construction

# Note: For eval_prog, represent environments as arrays of 2-element arrays
#       as described in the assignment

# ============================================================

class GeometryValue 
  # do *not* change methods in this class definition
  # you can add methods if you wish

  private
  # some helper methods that may be generally useful
  def real_close(r1,r2) 
    (r1 - r2).abs < GeometryExpression::Epsilon
  end
  def real_close_point(x1,y1,x2,y2) 
    real_close(x1,x2) && real_close(y1,y2)
  end
  # two_points_to_line could return a Line or a VerticalLine
  def two_points_to_line(x1,y1,x2,y2) 
    if real_close(x1,x2)
      VerticalLine.new x1
    else
      m = (y2 - y1).to_f / (x2 - x1)
      b = y1 - m * x1
      Line.new(m,b)
    end
  end

  public
  # all values evaluate to self
  def eval_prog env 
    self
  end

  # no pre-processing to do for most values (except LineSegment)
  def preprocess_prog
    self 
  end

  # we put this in this class so all subclasses can inherit it:
  # the intersection of self with a NoPoints is a NoPoints object
  def intersectNoPoints np
    np # could also have NoPoints.new here instead
  end

  # we put this in this class so all subclasses can inhert it:
  # the intersection of self with a LineSegment is computed by
  # first intersecting with the line containing the segment and then
  # calling the result's intersectWithSegmentAsLineResult with the segment
  def intersectLineSegment seg
    line_result = intersect(two_points_to_line(seg.x1,seg.y1,seg.x2,seg.y2))
    line_result.intersectWithSegmentAsLineResult seg
  end
end

# ------------------------------------------------------------

class NoPoints < GeometryValue
  # do *not* change this class definition: everything is done for you
  # (although this is the easiest class, it shows what methods every subclass
  # of geometry values needs)
  # However, you *may* move methods from here to a superclass if you wish to

  # Note: no initialize method only because there is nothing it needs to do
  def shift(dx,dy)
    self # shifting no-points is no-points
  end
  def intersect other
    other.intersectNoPoints self # will be NoPoints but follow double-dispatch
  end
  def intersectPoint p
    self # intersection with point and no-points is no-points
  end
  def intersectLine line
    self # intersection with line and no-points is no-points
  end
  def intersectVerticalLine vline
    self # intersection with line and no-points is no-points
  end
  # if self is the intersection of (1) some shape s and (2) 
  # the line containing seg, then we return the intersection of the 
  # shape s and the seg.  seg is an instance of LineSegment
  def intersectWithSegmentAsLineResult seg
    self
  end
end

# ------------------------------------------------------------

class Point < GeometryValue
  # *add* methods to this class -- do *not* change given code and do not
  # override any methods

  # Note: You may want a private helper method like the local
  # helper function inbetween in the ML code
  attr_reader :x, :y
  def initialize(x,y)
    @x = x
    @y = y
  end

  def shift(dx,dy)
    Point.new(x+dx,y+dy)
  end

  def to_s
    "Point(x="+x.to_s+",y="+y.to_s+")"
  end
end

# ------------------------------------------------------------

class Line < GeometryValue
  # *add* methods to this class -- do *not* change given code and do not
  # override any methods
  attr_reader :m, :b 
  def initialize(m,b)
    @m = m
    @b = b
  end

  def shift(dx,dy)
    Line.new(m,b+dy-m*dx)
  end

  def to_s
    "Line(m="+m.to_s+",b="+b.to_s+")"
  end
end

# ------------------------------------------------------------

class VerticalLine < GeometryValue
  # *add* methods to this class -- do *not* change given code and do not
  # override any methods
  attr_reader :x
  def initialize x
    @x = x
  end

  def shift(dx,dy)
    VerticalLine.new(x+dx)
  end

  def to_s
    "VerticalLine(x="+x.to_s+")"
  end
end

# ------------------------------------------------------------

class LineSegment < GeometryValue
  # *add* methods to this class -- do *not* change given code and do not
  # override any methods
  # Note: This is the most difficult class.  In the sample solution,
  #  preprocess_prog is about 15 lines long and 
  # intersectWithSegmentAsLineResult is about 40 lines long
  attr_reader :x1, :y1, :x2, :y2
  def initialize (x1,y1,x2,y2)
    @x1 = x1
    @y1 = y1
    @x2 = x2
    @y2 = y2
  end

  def preprocess_prog
    if real_close_point(x1,y1,x2,y2)
      Point.new(x1,y1)
    elsif real_close(x1,x2)
      if y1 < y2
        LineSegment.new(x1,y1,x1,y2)
      else
        LineSegment.new(x1,y2,x1,y1)
      end
    elsif x1 > x2 
      LineSegment.new(x2,y2,x1,y1)
    else
      self
    end
  end

  def shift(dx,dy)
    LineSegment.new(x1+dx,y1+dy,x2+dx,y2+dy)
  end

  def to_s
    "LineSegment(x1="+x1.to_s+",y1="+y1.to_s+";x2="+x2.to_s+",y2="+y2.to_s+")"
  end
end

# ============================================================

class GeometryExpression  
  # do *not* change this class definition
  Epsilon = 0.00001
end

# ------------------------------------------------------------

# Note: there is no need for getter methods for the non-value classes

class Intersect < GeometryExpression
  # *add* methods to this class -- do *not* change given code and do not
  # override any methods
  def initialize(e1,e2)
    @e1 = e1
    @e2 = e2
  end

  def eval_prog env 
    self  # TODO: impl
  end

  def preprocess_prog
    Intersect.new(@e1.preprocess_prog, @e2.preprocess_prog)
  end

  def to_s
    "Intersect("+@e1.to_s+","+@e2.to_s+")"
  end
end

# ------------------------------------------------------------

class Let < GeometryExpression
  # *add* methods to this class -- do *not* change given code and do not
  # override any methods
  # Note: Look at Var to guide how you implement Let
  def initialize(s,e1,e2)
    @s = s
    @e1 = e1
    @e2 = e2
  end

  # The first subexpression is evaluated and the result bound to a variable 
  # that is added to the environment for evaluating the second subexpression.
  def eval_prog env 
    @e2.eval_prog([[@s,@e1.eval_prog(env)]]+env)
  end

  def preprocess_prog
    Let.new(@s, @e1.preprocess_prog, @e2.preprocess_prog)
  end

  def to_s
    "Let("+@s.to_s+","+@e1.to_s+","+@e2.to_s+")"
  end
end

# ------------------------------------------------------------

class Var < GeometryExpression
  # *add* methods to this class -- do *not* change given code and do not
  # override any methods
  def initialize s
    @s = s
  end

  def eval_prog env # remember: do not change this method
    pr = env.assoc @s
    raise "undefined variable" if pr.nil?
    pr[1]
  end

  def preprocess_prog
    self
  end

  def to_s
    "Var("+@s.to_s+")"
  end
end

# ------------------------------------------------------------

class Shift < GeometryExpression
  # *add* methods to this class -- do *not* change given code and do not
  # override any methods
  def initialize(dx,dy,e)
    @dx = dx
    @dy = dy
    @e = e
  end

  # Every subclass of GeometryValue should have a shift method that 
  # takes two arguments dx and dy and returns the result of shifting self by dx and dy.
  def eval_prog env 
    @e.eval_prog(env).shift(@dx,@dy)
  end

  def preprocess_prog
    Shift.new(@dx,@dy,@e.preprocess_prog)
  end

  def to_s
    "Shift("+@e.to_s+" by ("+@dx.to_s+","+@dy.to_s+"))"
  end
end

# ============================================================

def test_preprocess_prog
  # values
  np = NoPoints.new()
  puts np
  puts np.preprocess_prog
  puts Point.new(1,2)
  puts Line.new(3,5)
  puts VerticalLine.new(10)
  puts LineSegment.new(1,2,3,4).preprocess_prog
  puts LineSegment.new(3.2,4.1,3.2,4.1).preprocess_prog
  puts LineSegment.new(1.1,3.3,1.1,2.2).preprocess_prog
  puts LineSegment.new(3,1,2,4).preprocess_prog
  # expressions
  l1 = LineSegment.new(1,2,3,4)
  l2 = LineSegment.new(3,1,2,4)
  puts Intersect.new(l1,l2)
  puts Intersect.new(l1,l2).preprocess_prog
  puts Let.new("x", l2, Var.new("x")).preprocess_prog
  puts Shift.new(-1, 1, l2).preprocess_prog
end

def test_eval_prog
  puts NoPoints.new().preprocess_prog.eval_prog []
  puts LineSegment.new(3.2,4.1,3.2,4.1).preprocess_prog.eval_prog []
  puts Let.new("p",Point.new(1,2),Var.new("p")).preprocess_prog.eval_prog []
  puts Let.new("p",Point.new(3,4),Shift.new(-1,1,Var.new("p"))).preprocess_prog.eval_prog []
  puts Let.new("l",LineSegment.new(3,1,2,4),Shift.new(5,10,Var.new("l"))).preprocess_prog.eval_prog []
end

def run_tests
  # test_preprocess_prog
  test_eval_prog
end

run_tests

# ============================================================
