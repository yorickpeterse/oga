package org.liboga.xml;

%%machine java_lexer;

import java.io.IOException;

import org.jcodings.Encoding;

import org.jruby.Ruby;
import org.jruby.RubyModule;
import org.jruby.RubyClass;
import org.jruby.RubyObject;
import org.jruby.RubyString;
import org.jruby.util.ByteList;
import org.jruby.anno.JRubyClass;
import org.jruby.anno.JRubyMethod;
import org.jruby.runtime.ThreadContext;
import org.jruby.runtime.ObjectAllocator;
import org.jruby.runtime.builtin.IRubyObject;

/**
 * Lexer support class for JRuby.
 *
 * The Lexer class contains the raw Ragel loop and calls back in to Ruby land
 * whenever a Ragel action is needed similar to the C extension setup.
 *
 * This class requires Ruby land to first define the `Oga::XML` namespace.
 */
@JRubyClass(name="Oga::XML::Lexer", parent="Object")
public class Lexer extends RubyObject
{
    /**
     * The current Ruby runtime.
     */
    private Ruby runtime;

    %% write data;

    /**
     * Sets up the current class in the Ruby runtime.
     */
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

        this.runtime = runtime;
    }

    /**
     * Runs the bulk of the Ragel loop and calls back in to Ruby.
     *
     * This method pulls its data in from the instance variable `@data`. The
     * Ruby side of the Lexer class should set this variable to a String in its
     * constructor method. Encodings are passed along to make sure that token
     * values share the same encoding as the input.
     *
     * This method always returns nil.
     */
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
        int eof = data.length;
        int top = 0;

        // Fixed stack size of 8 should be more than enough.
        int[] stack = new int[8];

        %% write init;
        %% write exec;

        return context.nil;
    }

    /**
     * Calls back in to Ruby land passing the current token value along.
     *
     * This method calls back in to Ruby land based on the method name
     * specified in `name`. The Ruby callback should take one argument. This
     * argument will be a String containing the value of the current token.
     */
    public void callback(String name, byte[] data, Encoding enc, int ts, int te)
    {
        ByteList bytelist = new ByteList(data, ts, te - ts, enc, true);

        RubyString value = this.runtime.newString(bytelist);

        ThreadContext context = this.runtime.getCurrentContext();

        this.callMethod(context, name, value);
    }

    /**
     * Calls back in to Ruby land without passing any arguments.
     */
    public void callback_simple(String name)
    {
        ThreadContext context = this.runtime.getCurrentContext();

        this.callMethod(context, name);
    }
}

%%{
    include base_lexer "base_lexer.rl";
}%%
