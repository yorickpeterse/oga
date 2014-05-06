import java.io.IOException;

import org.jruby.Ruby;
import org.jruby.RubyModule;
import org.jruby.RubyClass;
import org.jruby.runtime.load.BasicLibraryService;
import org.jruby.runtime.load.Library;

public class LibogaService implements BasicLibraryService
{
    public boolean basicLoad(final Ruby runtime) throws IOException
    {
        RubyModule xml = (RubyModule) runtime.getModule("Oga")
            .getConstant("XML");

        RubyClass lexer = xml.defineClassUnder(
            "Lexer",
            runtime.getObject(),
            runtime.getObject().getAllocator()
        );

        lexer.defineAnnotatedMethods(org.liboga.xml.Lexer.class);

        return true;
    }
}
