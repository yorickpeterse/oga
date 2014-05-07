import java.io.IOException;

import org.jruby.Ruby;
import org.jruby.RubyModule;
import org.jruby.RubyClass;
import org.jruby.runtime.load.BasicLibraryService;
import org.jruby.runtime.load.Library;

public class LibogaService implements BasicLibraryService
{
    /**
     * Bootstraps the JRuby extension.
     *
     * In order to load this extension properly you have to make sure that the
     * lib/ directory is in the Ruby load path. If this is the case you can
     * load it as following:
     *
     *     require 'liboga'
     *
     * Using absolute paths (e.g. with `require_relative`) requires you to
     * manually call this method:
     *
     *     LibogaService.new.basicLoad(JRuby.runtime)
     */
    public boolean basicLoad(final Ruby runtime) throws IOException
    {
        org.liboga.xml.Lexer.load(runtime);

        return true;
    }
}
