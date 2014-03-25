
# line 1 "lib/oga/xml/lexer.rl"

# line 3 "lib/oga/xml/lexer.rl"
module Oga
  module XML
    ##
    # Low level lexer that supports both XML and HTML (using an extra option). To
    # lex HTML input set the `:html` option to `true` when creating an instance
    # of the lexer:
    #
    #     lexer = Oga::Lexer.new(:html => true)
    #
    # @!attribute [r] html
    #  @return [TrueClass|FalseClass]
    #
    class Lexer
      
# line 20 "lib/oga/xml/lexer.rb"
class << self
	attr_accessor :_lexer_trans_keys
	private :_lexer_trans_keys, :_lexer_trans_keys=
end
self._lexer_trans_keys = [
	0, 0, 45, 100, 45, 45, 
	79, 111, 67, 99, 84, 
	116, 89, 121, 80, 112, 
	69, 101, 9, 32, 9, 104, 
	84, 116, 77, 109, 76, 
	108, 67, 67, 68, 68, 
	65, 65, 84, 84, 65, 65, 
	91, 91, 45, 122, 45, 
	122, 120, 120, 109, 109, 
	108, 108, 85, 85, 66, 66, 
	76, 76, 73, 73, 67, 
	67, 89, 89, 83, 83, 
	84, 84, 69, 69, 77, 77, 
	62, 62, 62, 62, 10, 
	10, 47, 62, 62, 62, 
	33, 122, 45, 122, 34, 34, 
	39, 39, 9, 83, 93, 
	93, 93, 93, 45, 45, 
	45, 45, 63, 63, 62, 62, 
	9, 122, 45, 122, 0
]

class << self
	attr_accessor :_lexer_key_spans
	private :_lexer_key_spans, :_lexer_key_spans=
end
self._lexer_key_spans = [
	0, 56, 1, 33, 33, 33, 33, 33, 
	33, 24, 96, 33, 33, 33, 1, 1, 
	1, 1, 1, 1, 78, 78, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 16, 1, 
	90, 78, 1, 1, 75, 1, 1, 1, 
	1, 1, 1, 114, 78
]

class << self
	attr_accessor :_lexer_index_offsets
	private :_lexer_index_offsets, :_lexer_index_offsets=
end
self._lexer_index_offsets = [
	0, 0, 57, 59, 93, 127, 161, 195, 
	229, 263, 288, 385, 419, 453, 487, 489, 
	491, 493, 495, 497, 499, 578, 657, 659, 
	661, 663, 665, 667, 669, 671, 673, 675, 
	677, 679, 681, 683, 685, 687, 689, 706, 
	708, 799, 878, 880, 882, 958, 960, 962, 
	964, 966, 968, 970, 1085
]

class << self
	attr_accessor :_lexer_indicies
	private :_lexer_indicies, :_lexer_indicies=
end
self._lexer_indicies = [
	1, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 2, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 3, 0, 
	0, 0, 0, 0, 0, 0, 0, 2, 
	0, 4, 0, 5, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 5, 0, 6, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 6, 0, 7, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 7, 
	0, 8, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 8, 0, 9, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 9, 0, 10, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 10, 0, 11, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 11, 0, 
	11, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 11, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 12, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 12, 
	0, 13, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 13, 0, 14, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 14, 0, 15, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 15, 0, 16, 
	0, 17, 0, 18, 0, 19, 0, 20, 
	0, 21, 0, 22, 0, 0, 22, 22, 
	22, 22, 22, 22, 22, 22, 22, 22, 
	22, 0, 0, 0, 0, 0, 0, 22, 
	22, 22, 22, 22, 22, 22, 22, 22, 
	22, 22, 22, 22, 22, 22, 22, 22, 
	22, 22, 22, 22, 22, 22, 22, 22, 
	22, 0, 0, 0, 0, 22, 0, 22, 
	22, 22, 22, 22, 22, 22, 22, 22, 
	22, 22, 22, 22, 22, 22, 22, 22, 
	22, 22, 22, 22, 22, 22, 22, 22, 
	22, 0, 22, 0, 0, 22, 22, 22, 
	22, 22, 22, 22, 22, 22, 22, 22, 
	0, 0, 0, 23, 0, 0, 22, 22, 
	22, 22, 22, 22, 22, 22, 22, 22, 
	22, 22, 22, 22, 22, 22, 22, 22, 
	22, 22, 22, 22, 22, 22, 22, 22, 
	0, 0, 0, 0, 22, 0, 22, 22, 
	22, 22, 22, 22, 22, 22, 22, 22, 
	22, 22, 22, 22, 22, 22, 22, 22, 
	22, 22, 22, 22, 22, 22, 22, 22, 
	0, 24, 0, 25, 0, 26, 0, 27, 
	28, 29, 28, 30, 28, 31, 28, 32, 
	28, 33, 28, 34, 28, 35, 28, 36, 
	28, 32, 28, 38, 37, 40, 39, 41, 
	28, 43, 42, 42, 42, 42, 42, 42, 
	42, 42, 42, 42, 42, 42, 44, 42, 
	45, 42, 47, 46, 48, 46, 46, 46, 
	46, 46, 46, 46, 46, 46, 46, 46, 
	49, 46, 50, 49, 49, 49, 49, 49, 
	49, 49, 49, 49, 49, 49, 46, 46, 
	46, 46, 51, 46, 49, 49, 49, 49, 
	49, 49, 49, 49, 49, 49, 49, 49, 
	49, 49, 49, 49, 49, 49, 49, 49, 
	49, 49, 49, 49, 49, 49, 46, 46, 
	46, 46, 49, 46, 49, 49, 49, 49, 
	49, 49, 49, 49, 49, 49, 49, 49, 
	49, 49, 49, 49, 49, 49, 49, 49, 
	49, 49, 49, 49, 49, 49, 46, 49, 
	52, 52, 49, 49, 49, 49, 49, 49, 
	49, 49, 49, 49, 49, 52, 52, 52, 
	52, 52, 52, 49, 49, 49, 49, 49, 
	49, 49, 49, 49, 49, 49, 49, 49, 
	49, 49, 49, 49, 49, 49, 49, 49, 
	49, 49, 49, 49, 49, 52, 52, 52, 
	52, 49, 52, 49, 49, 49, 49, 49, 
	49, 49, 49, 49, 49, 49, 49, 49, 
	49, 49, 49, 49, 49, 49, 49, 49, 
	49, 49, 49, 49, 49, 52, 54, 53, 
	56, 55, 57, 28, 28, 28, 28, 28, 
	28, 28, 28, 28, 28, 28, 28, 28, 
	28, 28, 28, 28, 28, 28, 28, 28, 
	28, 57, 28, 58, 28, 28, 28, 28, 
	59, 28, 28, 28, 28, 28, 28, 28, 
	28, 28, 28, 28, 28, 28, 28, 28, 
	28, 28, 28, 28, 28, 28, 28, 60, 
	28, 28, 28, 28, 28, 28, 28, 28, 
	28, 28, 28, 28, 28, 28, 28, 28, 
	28, 61, 28, 28, 62, 28, 64, 63, 
	66, 65, 68, 67, 70, 69, 72, 71, 
	74, 73, 75, 41, 28, 28, 76, 28, 
	28, 28, 28, 28, 28, 28, 28, 28, 
	28, 28, 28, 28, 28, 28, 28, 28, 
	28, 75, 28, 77, 28, 28, 28, 28, 
	78, 28, 28, 28, 28, 28, 79, 28, 
	80, 79, 79, 79, 79, 79, 79, 79, 
	79, 79, 79, 79, 28, 28, 75, 80, 
	28, 28, 79, 79, 79, 79, 79, 79, 
	79, 79, 79, 79, 79, 79, 79, 79, 
	79, 79, 79, 79, 79, 79, 79, 79, 
	79, 79, 79, 79, 28, 28, 28, 28, 
	79, 28, 79, 79, 79, 79, 79, 79, 
	79, 79, 79, 79, 79, 79, 79, 79, 
	79, 79, 79, 79, 79, 79, 79, 79, 
	79, 79, 79, 79, 28, 79, 81, 81, 
	79, 79, 79, 79, 79, 79, 79, 79, 
	79, 79, 79, 81, 81, 81, 81, 81, 
	81, 79, 79, 79, 79, 79, 79, 79, 
	79, 79, 79, 79, 79, 79, 79, 79, 
	79, 79, 79, 79, 79, 79, 79, 79, 
	79, 79, 79, 81, 81, 81, 81, 79, 
	81, 79, 79, 79, 79, 79, 79, 79, 
	79, 79, 79, 79, 79, 79, 79, 79, 
	79, 79, 79, 79, 79, 79, 79, 79, 
	79, 79, 79, 81, 0
]

class << self
	attr_accessor :_lexer_trans_targs
	private :_lexer_trans_targs, :_lexer_trans_targs=
end
self._lexer_trans_targs = [
	38, 2, 3, 14, 38, 4, 5, 6, 
	7, 8, 9, 10, 11, 12, 13, 38, 
	15, 16, 17, 18, 19, 38, 21, 38, 
	23, 24, 38, 26, 0, 27, 28, 29, 
	44, 31, 32, 33, 34, 45, 45, 47, 
	47, 51, 38, 39, 40, 38, 38, 38, 
	1, 41, 20, 22, 38, 42, 42, 43, 
	43, 44, 44, 44, 44, 25, 30, 45, 
	46, 45, 35, 47, 48, 47, 36, 49, 
	50, 49, 49, 51, 37, 51, 51, 52, 
	51, 51
]

class << self
	attr_accessor :_lexer_trans_actions
	private :_lexer_trans_actions, :_lexer_trans_actions=
end
self._lexer_trans_actions = [
	1, 0, 0, 0, 2, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 3, 
	0, 0, 0, 0, 0, 4, 0, 5, 
	0, 0, 6, 0, 0, 0, 0, 0, 
	7, 0, 0, 0, 0, 8, 9, 10, 
	11, 12, 15, 0, 16, 17, 18, 19, 
	0, 0, 0, 0, 20, 21, 22, 23, 
	24, 25, 26, 27, 28, 0, 0, 29, 
	16, 30, 0, 31, 16, 32, 0, 33, 
	0, 34, 35, 36, 0, 37, 38, 0, 
	39, 40
]

class << self
	attr_accessor :_lexer_to_state_actions
	private :_lexer_to_state_actions, :_lexer_to_state_actions=
end
self._lexer_to_state_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 13, 0, 
	0, 0, 13, 13, 13, 13, 0, 13, 
	0, 13, 0, 13, 0
]

class << self
	attr_accessor :_lexer_from_state_actions
	private :_lexer_from_state_actions, :_lexer_from_state_actions=
end
self._lexer_from_state_actions = [
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 0, 0, 0, 14, 0, 
	0, 0, 14, 14, 14, 14, 0, 14, 
	0, 14, 0, 14, 0
]

class << self
	attr_accessor :_lexer_eof_trans
	private :_lexer_eof_trans, :_lexer_eof_trans=
end
self._lexer_eof_trans = [
	0, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 1, 1, 1, 1, 1, 1, 1, 
	1, 0, 0, 0, 0, 0, 0, 0, 
	0, 0, 0, 38, 40, 0, 0, 47, 
	47, 53, 0, 0, 0, 0, 66, 0, 
	70, 0, 74, 0, 82
]

class << self
	attr_accessor :lexer_start
end
self.lexer_start = 38;
class << self
	attr_accessor :lexer_first_final
end
self.lexer_first_final = 38;
class << self
	attr_accessor :lexer_error
end
self.lexer_error = 0;

class << self
	attr_accessor :lexer_en_string_dquote
end
self.lexer_en_string_dquote = 42;
class << self
	attr_accessor :lexer_en_string_squote
end
self.lexer_en_string_squote = 43;
class << self
	attr_accessor :lexer_en_doctype
end
self.lexer_en_doctype = 44;
class << self
	attr_accessor :lexer_en_cdata
end
self.lexer_en_cdata = 45;
class << self
	attr_accessor :lexer_en_comment
end
self.lexer_en_comment = 47;
class << self
	attr_accessor :lexer_en_xml_decl
end
self.lexer_en_xml_decl = 49;
class << self
	attr_accessor :lexer_en_element_head
end
self.lexer_en_element_head = 51;
class << self
	attr_accessor :lexer_en_main
end
self.lexer_en_main = 38;


# line 18 "lib/oga/xml/lexer.rl"
      attr_reader :html

      ##
      # Names of the HTML void elements that should be handled when HTML lexing
      # is enabled.
      #
      # @return [Array]
      #
      HTML_VOID_ELEMENTS = [
        'area',
        'base',
        'br',
        'col',
        'command',
        'embed',
        'hr',
        'img',
        'input',
        'keygen',
        'link',
        'meta',
        'param',
        'source',
        'track',
        'wbr'
      ]

      # Lazy way of forwarding instance method calls used internally by Ragel to
      # their corresponding class methods.
      private_methods.grep(/^_lexer_/).each do |name|
        define_method(name) do
          return self.class.send(name)
        end

        private(name)
      end

      ##
      # @param [Hash] options
      #
      # @option options [Symbol] :html When set to `true` the lexer will treat
      #  the input as HTML instead of SGML/XML. This makes it possible to lex
      #  HTML void elements such as `<link href="">`.
      #
      def initialize(options = {})
        options.each do |key, value|
          instance_variable_set("@#{key}", value) if respond_to?(key)
        end

        reset
      end

      ##
      # Resets the internal state of the lexer. Typically you don't need to call
      # this method yourself as its called by #lex after lexing a given String.
      #
      def reset
        @line     = 1
        @data     = nil
        @ts       = nil
        @te       = nil
        @tokens   = []
        @stack    = []
        @top      = 0
        @elements = []

        @buffer_start_position = nil
      end

      ##
      # Lexes the supplied String and returns an Array of tokens. Each token is
      # an Array in the following format:
      #
      #     [TYPE, VALUE]
      #
      # The type is a symbol, the value is either nil or a String.
      #
      # @param [String] data The string to lex.
      # @return [Array]
      #
      def lex(data)
        @data       = data.unpack('U*')
        lexer_start = self.class.lexer_start
        eof         = data.length

        
# line 441 "lib/oga/xml/lexer.rb"
begin
	p ||= 0
	pe ||=  @data.length
	 @cs = lexer_start
	 @top = 0
	 @ts = nil
	 @te = nil
	 @act = 0
end

# line 104 "lib/oga/xml/lexer.rl"
        
# line 454 "lib/oga/xml/lexer.rb"
begin
	testEof = false
	_slen, _trans, _keys, _inds, _acts, _nacts = nil
	_goto_level = 0
	_resume = 10
	_eof_trans = 15
	_again = 20
	_test_eof = 30
	_out = 40
	while true
	if _goto_level <= 0
	if p == pe
		_goto_level = _test_eof
		next
	end
	if  @cs == 0
		_goto_level = _out
		next
	end
	end
	if _goto_level <= _resume
	case _lexer_from_state_actions[ @cs] 
	when 14 then
# line 1 "NONE"
		begin
 @ts = p
		end
# line 482 "lib/oga/xml/lexer.rb"
	end
	_keys =  @cs << 1
	_inds = _lexer_index_offsets[ @cs]
	_slen = _lexer_key_spans[ @cs]
	_trans = if (   _slen > 0 && 
			_lexer_trans_keys[_keys] <= ( (@data[p] || 0)) && 
			( (@data[p] || 0)) <= _lexer_trans_keys[_keys + 1] 
		    ) then
			_lexer_indicies[ _inds + ( (@data[p] || 0)) - _lexer_trans_keys[_keys] ] 
		 else 
			_lexer_indicies[ _inds + _slen ]
		 end
	end
	if _goto_level <= _eof_trans
	 @cs = _lexer_trans_targs[_trans]
	if _lexer_trans_actions[_trans] != 0
	case _lexer_trans_actions[_trans]
	when 16 then
# line 1 "NONE"
		begin
 @te = p+1
		end
	when 22 then
# line 254 "lib/oga/xml/lexer.rl"
		begin
 @te = p+1
 begin 
            emit_buffer(@ts, :T_STRING)
            	begin
		 @top -= 1
		 @cs =  @stack[ @top]
		_goto_level = _again
		next
	end

           end
		end
	when 21 then
# line 259 "lib/oga/xml/lexer.rl"
		begin
 @te = p+1
		end
	when 24 then
# line 264 "lib/oga/xml/lexer.rl"
		begin
 @te = p+1
 begin 
            emit_buffer(@ts, :T_STRING)
            	begin
		 @top -= 1
		 @cs =  @stack[ @top]
		_goto_level = _again
		next
	end

           end
		end
	when 23 then
# line 269 "lib/oga/xml/lexer.rl"
		begin
 @te = p+1
		end
	when 7 then
# line 293 "lib/oga/xml/lexer.rl"
		begin
 @te = p+1
 begin  t(:T_DOCTYPE_TYPE)  end
		end
	when 26 then
# line 240 "lib/oga/xml/lexer.rl"
		begin
 @te = p+1
 begin 
          start_buffer

          	begin
		 @stack[ @top] =  @cs
		 @top+= 1
		 @cs = 42
		_goto_level = _again
		next
	end

         end
		end
	when 27 then
# line 246 "lib/oga/xml/lexer.rl"
		begin
 @te = p+1
 begin 
          start_buffer

          	begin
		 @stack[ @top] =  @cs
		 @top+= 1
		 @cs = 43
		_goto_level = _again
		next
	end

         end
		end
	when 25 then
# line 301 "lib/oga/xml/lexer.rl"
		begin
 @te = p+1
		end
	when 28 then
# line 303 "lib/oga/xml/lexer.rl"
		begin
 @te = p+1
 begin 
            add_token(:T_DOCTYPE_END)
            	begin
		 @top -= 1
		 @cs =  @stack[ @top]
		_goto_level = _again
		next
	end

           end
		end
	when 9 then
# line 334 "lib/oga/xml/lexer.rl"
		begin
 @te = p+1
 begin 
            emit_buffer
            add_token(:T_CDATA_END)

            	begin
		 @top -= 1
		 @cs =  @stack[ @top]
		_goto_level = _again
		next
	end

           end
		end
	when 29 then
# line 341 "lib/oga/xml/lexer.rl"
		begin
 @te = p+1
		end
	when 30 then
# line 341 "lib/oga/xml/lexer.rl"
		begin
 @te = p
p = p - 1;		end
	when 8 then
# line 341 "lib/oga/xml/lexer.rl"
		begin
 begin p = (( @te))-1; end
		end
	when 11 then
# line 370 "lib/oga/xml/lexer.rl"
		begin
 @te = p+1
 begin 
            emit_buffer
            add_token(:T_COMMENT_END)

            	begin
		 @top -= 1
		 @cs =  @stack[ @top]
		_goto_level = _again
		next
	end

           end
		end
	when 31 then
# line 377 "lib/oga/xml/lexer.rl"
		begin
 @te = p+1
		end
	when 32 then
# line 377 "lib/oga/xml/lexer.rl"
		begin
 @te = p
p = p - 1;		end
	when 10 then
# line 377 "lib/oga/xml/lexer.rl"
		begin
 begin p = (( @te))-1; end
		end
	when 35 then
# line 398 "lib/oga/xml/lexer.rl"
		begin
 @te = p+1
 begin 
            emit_buffer
            add_token(:T_XML_DECL_END)

            	begin
		 @top -= 1
		 @cs =  @stack[ @top]
		_goto_level = _again
		next
	end

           end
		end
	when 33 then
# line 405 "lib/oga/xml/lexer.rl"
		begin
 @te = p+1
		end
	when 34 then
# line 405 "lib/oga/xml/lexer.rl"
		begin
 @te = p
p = p - 1;		end
	when 36 then
# line 446 "lib/oga/xml/lexer.rl"
		begin
 @te = p+1
		end
	when 12 then
# line 448 "lib/oga/xml/lexer.rl"
		begin
 @te = p+1
 begin  advance_line  end
		end
	when 37 then
# line 240 "lib/oga/xml/lexer.rl"
		begin
 @te = p+1
 begin 
          start_buffer

          	begin
		 @stack[ @top] =  @cs
		 @top+= 1
		 @cs = 42
		_goto_level = _again
		next
	end

         end
		end
	when 38 then
# line 246 "lib/oga/xml/lexer.rl"
		begin
 @te = p+1
 begin 
          start_buffer

          	begin
		 @stack[ @top] =  @cs
		 @top+= 1
		 @cs = 43
		_goto_level = _again
		next
	end

         end
		end
	when 39 then
# line 458 "lib/oga/xml/lexer.rl"
		begin
 @te = p+1
 begin 
            p = p - 1;
            	begin
		 @top -= 1
		 @cs =  @stack[ @top]
		_goto_level = _again
		next
	end

           end
		end
	when 40 then
# line 451 "lib/oga/xml/lexer.rl"
		begin
 @te = p
p = p - 1; begin  t(:T_ATTR)  end
		end
	when 3 then
# line 284 "lib/oga/xml/lexer.rl"
		begin
 @te = p+1
 begin 
          emit_buffer
          add_token(:T_DOCTYPE_START)
          	begin
		 @stack[ @top] =  @cs
		 @top+= 1
		 @cs = 44
		_goto_level = _again
		next
	end

         end
		end
	when 4 then
# line 322 "lib/oga/xml/lexer.rl"
		begin
 @te = p+1
 begin 
          emit_buffer
          add_token(:T_CDATA_START)

          start_buffer

          	begin
		 @stack[ @top] =  @cs
		 @top+= 1
		 @cs = 45
		_goto_level = _again
		next
	end

         end
		end
	when 2 then
# line 358 "lib/oga/xml/lexer.rl"
		begin
 @te = p+1
 begin 
          emit_buffer
          add_token(:T_COMMENT_START)

          start_buffer

          	begin
		 @stack[ @top] =  @cs
		 @top+= 1
		 @cs = 47
		_goto_level = _again
		next
	end

         end
		end
	when 6 then
# line 387 "lib/oga/xml/lexer.rl"
		begin
 @te = p+1
 begin 
          emit_buffer
          add_token(:T_XML_DECL_START)

          start_buffer

          	begin
		 @stack[ @top] =  @cs
		 @top+= 1
		 @cs = 49
		_goto_level = _again
		next
	end

         end
		end
	when 17 then
# line 473 "lib/oga/xml/lexer.rl"
		begin
 @te = p+1
 begin 
            if html? and HTML_VOID_ELEMENTS.include?(current_element)
              add_token(:T_ELEM_END, nil)
              @elements.pop
            end
           end
		end
	when 5 then
# line 481 "lib/oga/xml/lexer.rl"
		begin
 @te = p+1
 begin 
            emit_buffer
            add_token(:T_ELEM_END, nil)

            @elements.pop
           end
		end
	when 19 then
# line 489 "lib/oga/xml/lexer.rl"
		begin
 @te = p+1
 begin 
            add_token(:T_ELEM_END, nil)

            @elements.pop
           end
		end
	when 15 then
# line 497 "lib/oga/xml/lexer.rl"
		begin
 @te = p+1
 begin 
            # First character, start buffering (unless we already are buffering).
            start_buffer(@ts) unless buffering?

            # EOF, emit the text buffer.
            if @te == eof
              emit_buffer(@te)
            end
           end
		end
	when 20 then
# line 415 "lib/oga/xml/lexer.rl"
		begin
 @te = p
p = p - 1; begin 
          emit_buffer
          add_token(:T_ELEM_START)

          # Add the element name. If the name includes a namespace we'll break
          # the name up into two separate tokens.
          name = text(@ts + 1)

          if name.include?(':')
            ns, name = name.split(':')

            add_token(:T_ELEM_NS, ns)
          end

          @elements << name

          add_token(:T_ELEM_NAME, name)

          	begin
		 @stack[ @top] =  @cs
		 @top+= 1
		 @cs = 51
		_goto_level = _again
		next
	end

         end
		end
	when 18 then
# line 497 "lib/oga/xml/lexer.rl"
		begin
 @te = p
p = p - 1; begin 
            # First character, start buffering (unless we already are buffering).
            start_buffer(@ts) unless buffering?

            # EOF, emit the text buffer.
            if @te == eof
              emit_buffer(@te)
            end
           end
		end
	when 1 then
# line 497 "lib/oga/xml/lexer.rl"
		begin
 begin p = (( @te))-1; end
 begin 
            # First character, start buffering (unless we already are buffering).
            start_buffer(@ts) unless buffering?

            # EOF, emit the text buffer.
            if @te == eof
              emit_buffer(@te)
            end
           end
		end
# line 945 "lib/oga/xml/lexer.rb"
	end
	end
	end
	if _goto_level <= _again
	case _lexer_to_state_actions[ @cs] 
	when 13 then
# line 1 "NONE"
		begin
 @ts = nil;		end
# line 955 "lib/oga/xml/lexer.rb"
	end

	if  @cs == 0
		_goto_level = _out
		next
	end
	p += 1
	if p != pe
		_goto_level = _resume
		next
	end
	end
	if _goto_level <= _test_eof
	if p == eof
	if _lexer_eof_trans[ @cs] > 0
		_trans = _lexer_eof_trans[ @cs] - 1;
		_goto_level = _eof_trans
		next;
	end
	end

	end
	if _goto_level <= _out
		break
	end
end
	end

# line 105 "lib/oga/xml/lexer.rl"

        tokens = @tokens

        reset

        return tokens
      end

      ##
      # @return [TrueClass|FalseClass]
      #
      def html?
        return !!html
      end

      private

      ##
      # @param [Fixnum] amount The amount of lines to advance.
      #
      def advance_line(amount = 1)
        @line += amount
      end

      ##
      # Emits a token who's value is based on the supplied start/stop position.
      #
      # @param [Symbol] type The token type.
      # @param [Fixnum] start
      # @param [Fixnum] stop
      #
      # @see #text
      # @see #add_token
      #
      def t(type, start = @ts, stop = @te)
        value = text(start, stop)

        add_token(type, value)
      end

      ##
      # Returns the text of the current buffer based on the supplied start and
      # stop position.
      #
      # By default `@ts` and `@te` are used as the start/stop position.
      #
      # @param [Fixnum] start
      # @param [Fixnum] stop
      # @return [String]
      #
      def text(start = @ts, stop = @te)
        return @data[start...stop].pack('U*')
      end

      ##
      # Adds a token with the given type and value to the list.
      #
      # @param [Symbol] type The token type.
      # @param [String] value The token value.
      #
      def add_token(type, value = nil)
        token = [type, value, @line]

        @tokens << token
      end

      ##
      # Enables buffering starting at the given position.
      #
      # @param [Fixnum] position The start position of the buffer, set to `@te`
      #  by default.
      #
      def start_buffer(position = @te)
        @buffer_start_position = position
      end

      ##
      # Returns `true` if we're currently buffering.
      #
      # @return [TrueClass|FalseClass]
      #
      def buffering?
        return !!@buffer_start_position
      end

      ##
      # Emits the current buffer if we have any. The current line number is
      # advanced based on the amount of newlines in the buffer.
      #
      # @param [Fixnum] position The end position of the buffer, set to `@ts` by
      #  default.
      #
      # @param [Symbol] type The type of node to emit.
      #
      def emit_buffer(position = @ts, type = :T_TEXT)
        return unless @buffer_start_position

        content = text(@buffer_start_position, position)

        unless content.empty?
          add_token(type, content)

          lines = content.count("\n")

          advance_line(lines) if lines > 0
        end

        @buffer_start_position = nil
      end

      ##
      # Returns the name of the element we're currently in.
      #
      # @return [String]
      #
      def current_element
        return @elements.last
      end

      
# line 507 "lib/oga/xml/lexer.rl"

    end # Lexer
  end # XML
end # Oga
