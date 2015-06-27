class PolyTreeNode
  attr_accessor :value
  attr_reader :children, :parent

  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end

  def inspect
    parent_value = parent ? parent.value : "nil!"
    "<PolyTreeNode: #{@value} | parent: #{parent_value}> \n"
  end

  def parent=(new_parent)
    if new_parent.nil?
      @parent = nil
      return
    end

    @parent.children.delete(self) unless @parent.nil?
    unless new_parent.children.include?(self) && @parent
      new_parent.children << self
    end

    @parent = new_parent
  end

  def add_child(child_node)
    child_node.parent = self
  end

  def remove_child(child)
    child.parent = nil
    raise "Node is not this node's child" unless self.children.include?(child)
  end

  def trace_path_back
    ancestry = []
    current_node = self

    until current_node.parent.nil?
      ancestry.unshift(current_node.value)
      current_node = current_node.parent
    end

    ancestry.unshift(current_node.value) #root node
    ancestry
  end

  def dfs(target_value)
    return self if self.value == target_value

    @children.each do |child_node|
      result = child_node.dfs(target_value)
      return result if result
    end

    nil
  end

  def bfs(target_value)
    queue = []
    queue << self

    until queue.empty?
      current_node = queue.shift
      return current_node if current_node.value == target_value
      queue.concat(current_node.children)
    end
  end
end
