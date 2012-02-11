#!/usr/bin/env ruby

require 'FileUtils'

generatedHeadFile = 'tpl/_head_x.html'

print 'Minimize (y/n) '
minimize = /^(y|yes|1)$/.match(readline) ? true : false

if File.exists?(generatedHeadFile)
	FileUtils.rm(generatedHeadFile)
end

if minimize
	# SCRIPTS
	scripts = Dir.glob('js/*.js')
    scripts.concat(Dir.glob('js/syntaxhighlighter/*.js'))
	scripts = scripts.map { |s| "--js " + s }
	
	cmdLine = 'java -jar tools/closure-compiler.jar --js_output_file _minimized_tmp.js ' + scripts.join(' ')
	puts cmdLine
	system(cmdLine)
	
	minimizedScripts = ['../default/js/jquery.js', '../default/js/jquery.cookie.js']
	minimizedScripts.concat(Dir.glob('js/minimized/*.js'))
	minimizedScripts.concat(['_minimized_tmp.js']) # Goes last as it may use jQuery and other scripts
    
	File.open("minimized-output/minimized.js", "w") { |file|
		minimizedScripts.each { |otherFilePath|
			open(otherFilePath) { | otherFile|
                otherFile.each { |line|
                    file.puts line
                }
			}
			file.puts ';'
		}
	}
	
    if File.exists?('_minimized_tmp.js')
        FileUtils.rm('_minimized_tmp.js')
    end
    
	# CSS
	cssFiles = Dir.glob('styles/*.css')
    cssFiles.concat(Dir.glob('styles/syntaxhighlighter/*.css'))
	
	open('minimized-output/minimized.css', 'w') { |css|
		cssFiles.each { |cssFile|
			css.puts `java -jar tools/yuicompressor-2.4.7.jar --type css #{cssFile}`
		}
	}
	
	# Fix templates
	FileUtils.cp('tpl/_head_x_minimized.html', generatedHeadFile);
else
	FileUtils.cp('tpl/_head_x_full.html', generatedHeadFile);
end
