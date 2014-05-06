package org.liboga.xml;

%%machine lexer;

import java.io.IOException;

import org.jruby.Ruby;
import org.jruby.RubyModule;
import org.jruby.RubyClass;
import org.jruby.RubyObject;
import org.jruby.anno.JRubyClass;
import org.jruby.anno.JRubyMethod;
import org.jruby.runtime.ThreadContext;
import org.jruby.runtime.builtin.IRubyObject;

@JRubyClass(name="Oga::XML::Lexer", parent="Object")
public class Lexer extends RubyObject
{
    %% write data;

    public Lexer(Ruby runtime, RubyClass klass)
    {
        super(runtime, klass);
    }

    @JRubyMethod
    public IRubyObject advance_native(ThreadContext context)
    {
        int act = 0;
        int cs  = 0;
        int ts  = 0;
        int te  = 0;
        int p   = 0;
        int pe  = 0;
        int eof = 0;
        int top = 0;

        int[] data  = {};
        int[] stack = {};

        %% write init;
        %% write exec;

        return context.getRuntime().getNil();
    }
}

%%{
    main := |*
        any;
    *|;
}%%
