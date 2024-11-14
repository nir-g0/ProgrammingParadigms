class Tree
    attr_accessor :value, :left, :right
    def initialize(value, left=nil, right=nil)
      @value = value
      @left = left
      @right = right
    end

    def each_node(&block)
        block.call(@value)
        if @left then @left.each_node(&block);
        end
        if @right then @right.each_node(&block);
        end
    end

    def method_missing(m)
        split = m.to_s.split('_')
        head = split.pop
        current = self
        while head do
            head = split.pop 
            if head == "left" then current = current.left end
            if head == "right" then current = current.right end
        end
        return current.value
    end
  end
  
  my_tree = Tree.new(42,
                     Tree.new(3,
                              Tree.new(1,
                                       Tree.new(7,
                                                Tree.new(22),
                                                Tree.new(123)),
                                       Tree.new(32))),
                     Tree.new(99,
                              Tree.new(81)))

  my_tree.each_node do |v|
    puts v
  end

  
  arr = []
  my_tree.each_node do |v|
    arr.push v
  end
  p arr
  
  p "Getting nodes from tree"
  p my_tree.left_left
  p my_tree.right_left
  p my_tree.left_left_right
  p my_tree.left_left_left_right
  