require_relative "polytreenode.rb"

class KnightPathFinder
  attr_reader :start, :visited_positions

  def initialize(starting_pos)
    @start = PolyTreeNode.new(starting_pos)
    @visited_positions = [start.value]
  end

  def new_move_positions(node)
    new_moves = valid_moves(node).reject do |move|
      visited_positions.include?(move)
    end

    new_nodes = new_moves.map do |new_pos|
      visited_positions << new_pos
      new_node = PolyTreeNode.new(new_pos)
      new_node.parent = node
      new_node
    end

    new_nodes
  end

  def valid_moves(node)
    all_possible_moves(node.value).select do |possible_node|
      possible_node.all? { |idx| idx.between?(0, 7) }
    end
  end

  def all_possible_moves(pos)
    row, col = pos
    [
      [row + 2, col + 1], [row + 2, col - 1],
      [row - 2, col + 1], [row - 2, col - 1],
      [row + 1, col + 2], [row + 1, col - 2],
      [row - 1, col + 2], [row - 1, col - 2]
    ]
  end

  def build_move_tree
    queue = []
    queue << start

    until queue.empty?
      current_node = queue.shift
      queue.concat(new_move_positions(current_node))
    end
  end

  def find_path_dfs(ending_pos)
    build_move_tree
    ending_node = start.dfs(ending_pos)
    ending_node.trace_path_back
  end

  def find_path_bfs(ending_pos)
    build_move_tree
    ending_node = start.bfs(ending_pos)
    ending_node.trace_path_back
  end

end

beginning_pos = [0, 0]
kpf = KnightPathFinder.new(beginning_pos)
p kpf.find_path_dfs([7, 6])
p kpf.find_path_dfs([6, 2])
