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
        org.liboga.xml.Lexer.load(runtime);

        return true;
    }
}
