# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.

# ============================================================

class MyPiece < Piece
  # The constant All_My_Pieces should be declared here
  All_My_Pieces = Piece::All_Pieces + [
    rotations([[0, 0], [0, -1], [1, 0], [1, -1], [2, 0]]),  # IL
    [[[0, 0], [-1, 0], [-2, 0], [1, 0], [2, 0]],  # long with 5 squares
     [[0, 0], [0, -1], [0, -2], [0, 1], [0, 2]]],
    rotations([[0 ,0], [1, 0], [0, -1]])  # short L
  ]

  My_Cheat_Piece = [[[0, 0]]]

  # your enhancements here

  # class method to choose the next piece
  def self.next_piece (board)
    MyPiece.new(All_My_Pieces.sample, board)
  end

  # class method to get the cheat piece
  def self.next_cheat_piece (board)
    MyPiece.new(My_Cheat_Piece, board)
  end

end

# ============================================================

class MyBoard < Board
  # your enhancements here

  # ctor
  def initialize (game)
    super(game)
    @current_block = MyPiece.next_piece(self)
    @cheat_mode_on = false
  end

  # rotates the current piece 180 degrees
  def rotate_180_degrees
    if !game_over? and @game.is_running?
      @current_block.move(0, 0, 2)
    end
    draw
  end

  # turn on cheat mode when there is enough score
  def turn_on_cheat_mode
    if !game_over? and @game.is_running? and !@cheat_mode_on and @score >= 100
      @cheat_mode_on = true
      @score -= 100
    end
  end

  # gets the next piece
  def next_piece
    if @cheat_mode_on
      @current_block = MyPiece.next_cheat_piece(self)
      @cheat_mode_on = false
    else
      @current_block = MyPiece.next_piece(self)
    end
    @current_pos = nil
  end

  # gets the information from the current piece about where it is and uses this
  # to store the piece on the board itself.  Then calls remove_filled.
  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    locations.zip(@current_pos).each do |current,rect|
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] = rect
    end
    remove_filled
    @delay = [@delay - 2, 80].max
  end

end

# ============================================================

class MyTetris < Tetris
  # your enhancements here

  # creates a canvas and the board that interacts with it
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end

  def key_bindings  
    super
    @root.bind('u', proc {@board.rotate_180_degrees})
    @root.bind('c', proc {@board.turn_on_cheat_mode})
  end

end

# ============================================================
