require_relative 'stepping_piece'

class King < SteppingPiece
  MOVE_DIFFS = [
      [-1, -1], [-1, 0], [-1, 1],
      [ 0, -1],          [ 0, 1],
      [ 1, -1], [ 1, 0], [ 1, 1]
    ]

    def initialize(pos, board, color, moved = false)
      super(pos, board, color)
      @id = "♔"
      @moved = moved
    end

    def move_to(destination)
      super
      if [[0, 2], [0, 6], [7, 2], [7, 6]].include?(destination) && !@moved
        board.castle!(destination)
      end
      @moved = true
    end

    def moves
      normal_moves = super
      normal_moves += castling_locations
    end

    def castling_locations
      queenside_castle_location + kingside_castle_location
    end

    def queenside_castle_location
      krow, kcol = self.pos

      #king and rook unmoved, board empty at all points between,
      # king not in check now or in any of the squares it passes through
      if !@moved && board[[krow, kcol - 4]].rook_unmoved? &&
                    board[[krow, kcol - 1]].empty? &&
                    board[[krow, kcol - 2]].empty? &&
                    board[[krow, kcol - 3]].empty? &&
                    !board.in_check?(self.color)

         new_board = board.deep_dup
         new_board.move!([krow, kcol], [krow, kcol - 1])
         return [] if new_board.in_check?(self.color)

         new_board.move!([krow, kcol - 1], [krow, kcol - 2])
         return [] if new_board.in_check?(self.color)

         return [[krow, kcol - 2]]

       else
         []
       end
    end

    def kingside_castle_location
      krow, kcol = self.pos
      if !@moved && board[[krow, kcol + 3]].rook_unmoved? &&
                    board[[krow, kcol + 1]].empty? &&
                    board[[krow, kcol + 2]].empty? &&
                    !board.in_check?(self.color)

         new_board = board.deep_dup
         new_board.move!([krow, kcol], [krow, kcol + 1])
         return [] if new_board.in_check?(self.color)

         new_board.move!([krow, kcol + 1], [krow, kcol + 2])
         return [] if new_board.in_check?(self.color)

         return [[krow, kcol + 2]]
         
       else
         []
       end
    end

    def king?
      true
    end

    def king_location
      @pos
    end
end
