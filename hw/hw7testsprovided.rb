# University of Washington, Programming Languages, Homework 7, 
# hw7testsprovided.rb

require "./hw7.rb"

# Will not work completely until you implement all the classes and their methods

# Will print only if code has errors; prints nothing if all tests pass

# These tests do NOT cover all the various cases, especially for intersection

#Constants for testing
ZERO = 0.0
ONE = 1.0
TWO = 2.0
THREE = 3.0
FOUR = 4.0
FIVE = 5.0
SIX = 6.0
SEVEN = 7.0
TEN = 10.0

#Point Tests
a = Point.new(THREE,FIVE)
if not (a.x == THREE and a.y == FIVE)
	puts "Point is not initialized properly"
end
if not (a.eval_prog([]) == a)
	puts "Point eval_prog should return self"
end
if not (a.preprocess_prog == a)
	puts "Point preprocess_prog should return self"
end
a1 = a.shift(THREE,FIVE)
if not (a1.x == SIX and a1.y == TEN)
	puts "Point shift not working properly"
end
a2 = a.intersect(Point.new(THREE,FIVE))
if not (a2.x == THREE and a2.y == FIVE)
	puts "Point intersect not working properly"
end 
a3 = a.intersect(Point.new(FOUR,FIVE))
if not (a3.is_a? NoPoints)
	puts "Point intersect not working properly"
end

#Line Tests
b = Line.new(THREE,FIVE)
if not (b.m == THREE and b.b == FIVE)
	puts "Line not initialized properly"
end
if not (b.eval_prog([]) == b)
	puts "Line eval_prog should return self"
end
if not (b.preprocess_prog == b)
	puts "Line preprocess_prog should return self"
end

b1 = b.shift(THREE,FIVE) 
if not (b1.m == THREE and b1.b == ONE)
	puts "Line shift not working properly"
end

b2 = b.intersect(Line.new(THREE,FIVE))
if not (((b2.is_a? Line)) and b2.m == THREE and b2.b == FIVE)
	puts "Line intersect not working properly"
end
b3 = b.intersect(Line.new(THREE,FOUR))
if not ((b3.is_a? NoPoints))
	puts "Line intersect not working properly"
end

#VerticalLine Tests
c = VerticalLine.new(THREE)
if not (c.x == THREE)
	puts "VerticalLine not initialized properly"
end

if not (c.eval_prog([]) == c)
	puts "VerticalLine eval_prog should return self"
end
if not (c.preprocess_prog == c)
	puts "VerticalLine preprocess_prog should return self"
end
c1 = c.shift(THREE,FIVE)
if not (c1.x == SIX)
	puts "VerticalLine shift not working properly"
end
c2 = c.intersect(VerticalLine.new(THREE))
if not ((c2.is_a? VerticalLine) and c2.x == THREE )
	puts "VerticalLine intersect not working properly"
end
c3 = c.intersect(VerticalLine.new(FOUR))
if not ((c3.is_a? NoPoints))
	puts "VerticalLine intersect not working properly"
end

#LineSegment Tests
d = LineSegment.new(ONE,TWO,-THREE,-FOUR)
if not (d.eval_prog([]) == d)
	puts "LineSegement eval_prog should return self"
end
d1 = LineSegment.new(ONE,TWO,ONE,TWO)
d2 = d1.preprocess_prog
if not ((d2.is_a? Point)and d2.x == ONE and d2.y == TWO) 
	puts "LineSegment preprocess_prog should convert to a Point"
	puts "if ends of segment are real_close"
end

d = d.preprocess_prog
if not (d.x1 == -THREE and d.y1 == -FOUR and d.x2 == ONE and d.y2 == TWO)
	puts "LineSegment preprocess_prog should make x1 and y1"
	puts "on the left of x2 and y2"
end

d3 = d.shift(THREE,FIVE)
if not (d3.x1 == ZERO and d3.y1 == ONE and d3.x2 == FOUR and d3.y2 == SEVEN)
	puts "LineSegment shift not working properly"
end

d4 = d.intersect(LineSegment.new(-THREE,-FOUR,ONE,TWO))
if not (((d4.is_a? LineSegment)) and d4.x1 == -THREE and d4.y1 == -FOUR and d4.x2 == ONE and d4.y2 == TWO)	
	puts "LineSegment intersect not working properly"
end
d5 = d.intersect(LineSegment.new(TWO,THREE,FOUR,FIVE))
if not ((d5.is_a? NoPoints))
	puts "LineSegment intersect not working properly"
end

#Intersect Tests
i = Intersect.new(LineSegment.new(-ONE,-TWO,THREE,FOUR), LineSegment.new(THREE,FOUR,-ONE,-TWO))
i1 = i.preprocess_prog.eval_prog([])
if not (i1.x1 == -ONE and i1.y1 == -TWO and i1.x2 == THREE and i1.y2 == FOUR)
	puts "Intersect eval_prog should return the intersect between e1 and e2"
end

#Var Tests
v = Var.new("a")
v1 = v.eval_prog([["a", Point.new(THREE,FIVE)]])
if not ((v1.is_a? Point) and v1.x == THREE and v1.y == FIVE)
	puts "Var eval_prog is not working properly"
end 
if not (v.preprocess_prog == v)
	puts "Var preprocess_prog should return self"
end

#Let Tests
l = Let.new("a", LineSegment.new(-ONE,-TWO,THREE,FOUR),
             Intersect.new(Var.new("a"),LineSegment.new(THREE,FOUR,-ONE,-TWO)))
l1 = l.preprocess_prog.eval_prog([])
if not (l1.x1 == -ONE and l1.y1 == -TWO and l1.x2 == THREE and l1.y2 == FOUR)
	puts "Let eval_prog should evaluate e2 after adding [s, e1] to the environment"
end

#Let Variable Shadowing Test
l2 = Let.new("a", LineSegment.new(-ONE, -TWO, THREE, FOUR),
              Let.new("b", LineSegment.new(THREE,FOUR,-ONE,-TWO), Intersect.new(Var.new("a"),Var.new("b"))))
l2 = l2.preprocess_prog.eval_prog([["a",Point.new(0,0)]])
if not (l2.x1 == -ONE and l2.y1 == -TWO and l2.x2 == THREE and l2.y2 == FOUR)
	puts "Let eval_prog should evaluate e2 after adding [s, e1] to the environment"
end


#Shift Tests
s = Shift.new(THREE,FIVE,LineSegment.new(-ONE,-TWO,THREE,FOUR))
s1 = s.preprocess_prog.eval_prog([])
if not (s1.x1 == TWO and s1.y1 == THREE and s1.x2 == SIX and s1.y2 == 9)
	puts "Shift should shift e by dx and dy"
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

def test_shift
  puts Let.new("x",Point.new(1,2),Shift.new(-1,1,Var.new("x"))).preprocess_prog.eval_prog [["x",Point.new(1,1)]]
  puts Shift.new(1,1,Line.new(1,2)).preprocess_prog.eval_prog []
  puts Shift.new(1,2,VerticalLine.new(3)).preprocess_prog.eval_prog []
  puts Shift.new(1.5,2,LineSegment.new(3,4,5,6)).preprocess_prog.eval_prog []
end

def test_intersect
  puts "====== Point ======"
  puts Intersect.new(Point.new(1,2),Point.new(1,2)).preprocess_prog.eval_prog []
  puts Intersect.new(Point.new(1,2),Point.new(1,3)).preprocess_prog.eval_prog []
  puts Intersect.new(Point.new(1,2),Line.new(1,1)).preprocess_prog.eval_prog []
  puts Intersect.new(Point.new(1,1),Line.new(1,1)).preprocess_prog.eval_prog []
  puts Intersect.new(Point.new(1,2),VerticalLine.new(1)).preprocess_prog.eval_prog []
  puts Intersect.new(Point.new(1,2),VerticalLine.new(2)).preprocess_prog.eval_prog []
  puts "====== Line ======"
  puts Intersect.new(Line.new(1,1),Point.new(1,2)).preprocess_prog.eval_prog []
  puts Intersect.new(Line.new(1,1),Line.new(1,1)).preprocess_prog.eval_prog []
  puts Intersect.new(Line.new(-1,0),Line.new(1,1)).preprocess_prog.eval_prog []
  puts Intersect.new(Line.new(2,0),Line.new(1,1)).preprocess_prog.eval_prog []
  puts Intersect.new(Line.new(1,2),Line.new(1,1)).preprocess_prog.eval_prog []
  puts Intersect.new(Line.new(2,3),VerticalLine.new(2)).preprocess_prog.eval_prog []
  puts "====== VerticalLine ======"
  puts Intersect.new(VerticalLine.new(2),Point.new(2,3)).preprocess_prog.eval_prog []
  puts Intersect.new(VerticalLine.new(2),Line.new(2,3)).preprocess_prog.eval_prog []
  puts Intersect.new(VerticalLine.new(2),VerticalLine.new(2)).preprocess_prog.eval_prog []
  puts Intersect.new(VerticalLine.new(2),VerticalLine.new(3)).preprocess_prog.eval_prog []
  puts "====== LineSegment ======"
  puts Intersect.new(LineSegment.new(1,1,3,3),Point.new(2,2)).preprocess_prog.eval_prog []
  puts Intersect.new(LineSegment.new(1,1,3,3),Point.new(2,2.1)).preprocess_prog.eval_prog []
  puts Intersect.new(LineSegment.new(1,2,3,4),Line.new(1,1)).preprocess_prog.eval_prog []
  puts Intersect.new(LineSegment.new(1,2,3,4),Line.new(1,2)).preprocess_prog.eval_prog []
  puts Intersect.new(LineSegment.new(1,2,3,4),Line.new(2,0)).preprocess_prog.eval_prog []
  puts Intersect.new(LineSegment.new(1,2,1,4),VerticalLine.new(1)).preprocess_prog.eval_prog []
  puts Intersect.new(LineSegment.new(1,2,1,4),VerticalLine.new(1.5)).preprocess_prog.eval_prog []
  puts Intersect.new(LineSegment.new(1,2,3,4),VerticalLine.new(2.0)).preprocess_prog.eval_prog []
  puts Intersect.new(LineSegment.new(1,3,1,2),LineSegment.new(1,0,1,2)).preprocess_prog.eval_prog []
  puts Intersect.new(LineSegment.new(1,3,1,2),LineSegment.new(1,0,1,1)).preprocess_prog.eval_prog []
  puts Intersect.new(LineSegment.new(1,4,1,1),LineSegment.new(1,2,1,3)).preprocess_prog.eval_prog []
  puts Intersect.new(LineSegment.new(1,3,1,1),LineSegment.new(1,2,1,4)).preprocess_prog.eval_prog []
  puts Intersect.new(LineSegment.new(1,1,3,3),LineSegment.new(0,0,1,1)).preprocess_prog.eval_prog []
  puts Intersect.new(LineSegment.new(2,2,3,3),LineSegment.new(0,0,1,1)).preprocess_prog.eval_prog []
  puts Intersect.new(LineSegment.new(1,1,3,3),LineSegment.new(0,0,2,2)).preprocess_prog.eval_prog []
  puts Intersect.new(LineSegment.new(-1,-1,3,3),LineSegment.new(0,0,2,2)).preprocess_prog.eval_prog []
  puts Intersect.new(LineSegment.new(0,0,2,2),LineSegment.new(0,2,1,0)).preprocess_prog.eval_prog []
  puts Intersect.new(LineSegment.new(0,0,1,1),LineSegment.new(0,1,1,2)).preprocess_prog.eval_prog []
end

def run_tests
  test_preprocess_prog
  test_eval_prog
  test_shift
  test_intersect
end

# run_tests

# ============================================================
