require 'FileUtils'

print 'Minimize (y/n) '
minimize = /^(y|yes|1)$/.match(readline) ? true : false

if File.exists?('tpl/_head_x.html')
	FileUtils.rm('tpl/_head_x.html')
end

if minimize
	# SCRIPTS
	scripts = Dir.glob('js/*.js')
	scripts = scripts.map { |s| "--js " + s }
	
	cmdLine = 'java -jar tools/closure-compiler.jar --js_output_file _minimized.js ' + scripts.join(' ')
	puts cmdLine
	system(cmdLine)
	
	minimizedScripts = ['../default/js/jquery.js', '../default/js/jquery.cookie.js']
	minimizedScripts.concat(Dir.glob('js/minimized/*.js'))
	
	open('_minimized.js', 'a') { |file|
		minimizedScripts.each { |otherFile|
			open(otherFile).each { |line|
				file.puts line
			}
		}
	}
	
	# CSS
	cssFiles = Dir.glob('styles/*.css')
	
	open('_minimized.css', 'w') { |css|
		cssFiles.each { |cssFile|
			css.puts `java -jar tools/yuicompressor-2.4.7.jar --type css #{cssFile}`
		}
	}
	
	# Fix templates
	FileUtils.cp('tpl/_head_x_minimized.html', 'tpl/_head_x.html');
else
	FileUtils.cp('tpl/_head_x_full.html', 'tpl/_head_x.html');
end