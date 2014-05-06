package org.liboga.xml;

%%machine lexer;

import java.io.IOException;

import org.jcodings.Encoding;

import org.jruby.Ruby;
import org.jruby.RubyModule;
import org.jruby.RubyClass;
import org.jruby.RubyObject;
import org.jruby.RubyString;
import org.jruby.anno.JRubyClass;
import org.jruby.anno.JRubyMethod;
import org.jruby.runtime.ThreadContext;
import org.jruby.runtime.ObjectAllocator;
import org.jruby.runtime.builtin.IRubyObject;

@JRubyClass(name="Oga::XML::Lexer", parent="Object")
public class Lexer extends RubyObject
{
    %% write data;

    public static void load(Ruby runtime)
    {
        RubyModule xml = (RubyModule) runtime.getModule("Oga")
            .getConstant("XML");

        RubyClass lexer = xml.defineClassUnder(
            "Lexer",
            runtime.getObject(),
            ALLOCATOR
        );

        lexer.defineAnnotatedMethods(Lexer.class);
    }

    private static final ObjectAllocator ALLOCATOR = new ObjectAllocator()
    {
        public IRubyObject allocate(Ruby runtime, RubyClass klass)
        {
            return new org.liboga.xml.Lexer(runtime, klass);
        }
    };

    public Lexer(Ruby runtime, RubyClass klass)
    {
        super(runtime, klass);
    }

    @JRubyMethod
    public IRubyObject advance_native(ThreadContext context)
    {
        // Pull the data in from Ruby land.
        RubyString rb_str = (RubyString) this.getInstanceVariable("@data");
        Encoding encoding = rb_str.getEncoding();

        byte[] data = rb_str.getBytes();

        int act = 0;
        int cs  = 0;
        int ts  = 0;
        int te  = 0;
        int p   = 0;
        int pe  = data.length;
        int eof = 0;
        int top = 0;

        int[] stack = {};

        %% write init;
        %% write exec;

        return context.nil;
    }
}

%%{
    main := |*
        any;
    *|;
}%%
