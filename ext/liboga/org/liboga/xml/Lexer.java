package org.liboga.xml;

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
    public Lexer(Ruby runtime, RubyClass klass)
    {
        super(runtime, klass);
    }

    @JRubyMethod
    public IRubyObject advance_native(ThreadContext context)
    {
        return context.getRuntime().getNil();
    }
}
